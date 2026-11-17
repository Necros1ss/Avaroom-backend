const crypto = require('crypto');
const { validationResult, body } = require('express-validator');
const User = require('../models/User');
const RefreshToken = require('../models/RefreshToken');
const env = require('../config/env');
const { sequelize } = require('../config/database');
const StudentUser = require('../models/StudentUser');
const LandlordUser = require('../models/LandlordUser');
const PasswordResetOtp = require('../models/PasswordResetOTP');
const { sendOtpMail } = require('../services/mail.service');

const register = async (req, res, next) => {
  const transaction = await sequelize.transaction();
  try {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      await transaction.rollback();
      return res.status(400).json({
        success: false,
        message: 'Dữ liệu không hợp lệ',
        errors: errors.array().map((e) => e.msg),
      });
    }

    const { email, password, full_name, phone_number, role, address } = req.body;
    const userRole = role || 'STUDENT';

    // Kiểm tra xem email đã tồn tại hay chưa
    let user = await User.findOne({
      where: { email },
      include: [{ model: LandlordUser, as: 'landlordProfile' }],
      transaction,
    });

    if (user) {
      // Tiêu chí hoàn thành đăng ký theo từng Role:
      // - Sinh viên: status === 'ACTIVE'
      // - Chủ trọ: status === 'ACTIVE' VÀ đã có số CCCD (eKYC thành công)
      const isStudentComplete = user.role === 'STUDENT' && user.status === 'ACTIVE';
      const isLandlordComplete = user.role === 'LANDLORD' && user.status === 'ACTIVE' && user.landlordProfile?.identity_card_number;

      if (isStudentComplete || isLandlordComplete) {
        await transaction.rollback();
        return res.status(409).json({
          success: false,
          message: 'Email này đã được sử dụng trong hệ thống',
        });
      }

      // Nếu chưa hoàn tất đăng ký (dở dang ở bước OTP hoặc bước chụp CCCD):
      // Cho phép cập nhật lại thông tin đăng ký mới
      user.password_hash = password;
      user.full_name = full_name;
      user.phone_number = phone_number || null;
      user.role = userRole;
      user.status = 'INACTIVE'; // Đặt về INACTIVE chờ xác thực
      await user.save({ transaction });

      if (userRole === 'STUDENT') {
        await StudentUser.findOrCreate({
          where: { user_id: user.id },
          defaults: { user_id: user.id },
          transaction,
        });
      } else if (userRole === 'LANDLORD') {
        const [landlordProfile] = await LandlordUser.findOrCreate({
          where: { user_id: user.id },
          defaults: { user_id: user.id, phone_number: phone_number || null, contact_address: address || null },
          transaction,
        });
        await landlordProfile.update({
          phone_number: phone_number || null,
          contact_address: address || null,
        }, { transaction });
      }
    } else {
      // Kiểm tra số điện thoại nếu user mới
      if (phone_number) {
        const existingPhone = await User.findOne({
          where: { phone_number },
          include: [{ model: LandlordUser, as: 'landlordProfile' }],
        });

        if (existingPhone) {
          const isPhoneStudentComplete = existingPhone.role === 'STUDENT' && existingPhone.status === 'ACTIVE';
          const isPhoneLandlordComplete = existingPhone.role === 'LANDLORD' && existingPhone.status === 'ACTIVE' && existingPhone.landlordProfile?.identity_card_number;

          if (isPhoneStudentComplete || isPhoneLandlordComplete) {
            await transaction.rollback();
            return res.status(409).json({
              success: false,
              message: 'Số điện thoại này đã được sử dụng trong hệ thống',
            });
          }
        }
      }

      // Tạo user mới với status INACTIVE
      user = await User.create({
        email,
        password_hash: password,
        full_name,
        phone_number: phone_number || null,
        role: userRole,
        status: 'INACTIVE',
      }, { transaction });

      if (userRole === 'STUDENT') {
        await StudentUser.create({
          user_id: user.id,
        }, { transaction });
      } else if (userRole === 'LANDLORD') {
        await LandlordUser.create({
          user_id: user.id,
          phone_number: phone_number || null,
          contact_address: address || null,
        }, { transaction });
      }
    }

    // Sinh mã OTP
    const otpCode = Math.floor(100000 + Math.random() * 900000).toString();
    const expiresAtOtp = new Date(Date.now() + 10 * 60 * 1000); // 10 phút

    await PasswordResetOtp.update(
      { is_used: true },
      { where: { email, is_used: false }, transaction }
    );

    await PasswordResetOtp.create({
      email,
      otp_code: otpCode,
      expires_at: expiresAtOtp,
      is_used: false,
    }, { transaction });

    // Gửi email chứa OTP
    await sendOtpMail(email, otpCode);

    await transaction.commit();

    return res.status(200).json({
      success: true,
      message: 'Mã xác thực OTP đã được gửi đến email của bạn',
      data: {
        email: user.email,
        role: user.role,
      },
    });
  } catch (error) {
    await transaction.rollback();
    next(error);
  }
};

/**
 * Đăng nhập hệ thống
 * POST /api/auth/login
 */
const login = async (req, res, next) => {
  try {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({
        success: false,
        message: 'Dữ liệu không hợp lệ',
        errors: errors.array().map((e) => e.msg),
      });
    }

    const { email, password } = req.body;

    const user = await User.findOne({ where: { email } });
    if (!user) {
      return res.status(401).json({
        success: false,
        message: 'Email hoặc mật khẩu không chính xác',
      });
    }

    if (user.status !== 'ACTIVE') {
      return res.status(403).json({
        success: false,
        message: 'Tài khoản của bạn hiện đang bị khóa hoặc ngưng hoạt động',
      });
    }

    const isMatch = await user.comparePassword(password);
    if (!isMatch) {
      return res.status(401).json({
        success: false,
        message: 'Email hoặc mật khẩu không chính xác',
      });
    }

    // Sinh access token & refresh token
    const accessToken = user.generateAccessToken();
    const refreshTokenString = crypto.randomBytes(40).toString('hex');
    const expiresAt = new Date();
    expiresAt.setDate(expiresAt.getDate() + 7);

    await RefreshToken.create({
      user_id: user.id,
      token: refreshTokenString,
      device_info: req.headers['user-agent'] || 'Unknown Device',
      expires_at: expiresAt,
    });

    res.json({
      success: true,
      message: 'Đăng nhập thành công',
      data: {
        user,
        tokens: {
          access_token: accessToken,
          refresh_token: refreshTokenString,
          token_type: 'Bearer',
          expires_in: env.JWT_EXPIRES_IN,
        },
      },
    });
  } catch (error) {
    next(error);
  }
};

/**
 * Làm mới Access Token thông qua Refresh Token
 * POST /api/auth/refresh-token
 */
const refreshToken = async (req, res, next) => {
  try {
    const { refresh_token } = req.body;
    if (!refresh_token) {
      return res.status(400).json({
        success: false,
        message: 'Vui lòng cung cấp refresh_token',
      });
    }

    const storedToken = await RefreshToken.findOne({
      where: {
        token: refresh_token,
        is_revoked: false,
      },
      include: [{ model: User, as: 'user' }],
    });

    if (!storedToken || new Date() > new Date(storedToken.expires_at)) {
      return res.status(401).json({
        success: false,
        message: 'Refresh token không hợp lệ hoặc đã hết hạn. Vui lòng đăng nhập lại.',
      });
    }

    const user = storedToken.user;
    if (!user || user.status !== 'ACTIVE') {
      return res.status(403).json({
        success: false,
        message: 'Tài khoản không hợp lệ hoặc đã bị khóa.',
      });
    }

    // Cấp access token mới
    const newAccessToken = user.generateAccessToken();

    res.json({
      success: true,
      message: 'Làm mới token thành công',
      data: {
        access_token: newAccessToken,
        token_type: 'Bearer',
        expires_in: env.JWT_EXPIRES_IN,
      },
    });
  } catch (error) {
    next(error);
  }
};

/**
 * Đăng xuất và thu hồi Refresh Token
 * POST /api/auth/logout
 */
const logout = async (req, res, next) => {
  try {
    const { refresh_token } = req.body;

    if (refresh_token) {
      await RefreshToken.update(
        { is_revoked: true },
        { where: { token: refresh_token, user_id: req.userId } }
      );
    }

    res.json({
      success: true,
      message: 'Đăng xuất thành công',
    });
  } catch (error) {
    next(error);
  }
};

/**
 * Lấy thông tin cá nhân của phiên đăng nhập hiện tại
 * GET /api/auth/me
 */
const getMe = async (req, res, next) => {
  try {
    const user = await User.findByPk(req.userId, {
      include: [
        { model: StudentUser, as: 'studentProfile', required: false },
        { model: LandlordUser, as: 'landlordProfile', required: false }
      ]
    });

    if (!user) {
      return res.status(404).json({ success: false, message: 'Người dùng không tồn tại' })
    }

    res.json({
      success: true,
      data: {
        id: user.id,
        email: user.email,
        full_name: user.full_name,
        phone_number: user.phone_number,
        avatar_url: user.avatar_url,
        role: user.role,
        studentProfile: user.studentProfile,
        landlordProfile: user.landlordProfile
      },
    });
  } catch (error) {
    next(error);
  }
};

// Validation rules
const registerValidation = [
  body('email').trim().isEmail().withMessage('Email không đúng định dạng').normalizeEmail(),
  body('password').isLength({ min: 6 }).withMessage('Mật khẩu tối thiểu 6 ký tự'),
  body('full_name').trim().notEmpty().withMessage('Vui lòng nhập họ và tên'),
  body('phone_number')
    .optional({ nullable: true })
    .matches(/^(0|\+84)[0-9]{9,10}$/)
    .withMessage('Số điện thoại không hợp lệ'),
  body('role')
    .optional()
    .isIn(['STUDENT', 'LANDLORD', 'ADMIN'])
    .withMessage('Role phải là STUDENT, LANDLORD hoặc ADMIN'),
  body('address')
    .optional({ nullable: true })
    .trim(),
];

const loginValidation = [
  body('email').trim().isEmail().withMessage('Email không đúng định dạng').normalizeEmail(),
  body('password').notEmpty().withMessage('Vui lòng nhập mật khẩu'),
];

const forgotPassword = async (req, res, next) => {
  try {
    const { email } = req.body;
    if (!email) {
      return res.status(400).json({ success: false, message: 'Vui lòng cung cấp email' });
    }
    const user = await User.findOne({ where: { email } });
    if (!user) {
      return res.status(404).json({ success: false, message: 'Email này chưa được đăng ký tài khoản' });
    }
    // Sinh mã OTP ngẫu nhiên 6 chữ số (100000 - 999999)
    const otpCode = Math.floor(100000 + Math.random() * 900000).toString();
    const expiresAt = new Date(Date.now() + 10 * 60 * 1000); // 10 phút
    // Vô hiệu hoá các OTP cũ của email này nếu còn tồn tại
    await PasswordResetOtp.update({ is_used: true }, { where: { email, is_used: false } });
    // Lưu OTP mới
    await PasswordResetOtp.create({
      email,
      otp_code: otpCode,
      expires_at: expiresAt,
      is_used: false,
    });
    // Gửi email
    await sendOtpMail(email, otpCode);
    res.json({
      success: true,
      message: 'Mã xác thực OTP đã được gửi đến email của bạn',
    });
  } catch (error) {
    next(error);
  }
};

const verifyOtp = async (req, res, next) => {
  try {
    const { email, otp } = req.body;
    if (!email || !otp) {
      return res.status(400).json({ success: false, message: 'Vui lòng nhập đầy đủ email và mã OTP' });
    }
    const record = await PasswordResetOtp.findOne({
      where: {
        email,
        otp_code: otp,
        is_used: false,
      },
      order: [['created_at', 'DESC']],
    });
    if (!record || new Date() > new Date(record.expires_at)) {
      return res.status(400).json({
        success: false,
        message: 'Mã OTP không chính xác hoặc đã hết hạn',
      });
    }
    // Sinh reset_token ngẫu nhiên an toàn cho luồng Quên mật khẩu
    const resetToken = crypto.randomBytes(32).toString('hex');
    await record.update({ reset_token: resetToken });

    // Lấy thông tin user và cấp token nếu là xác thực sau Đăng ký
    const user = await User.findOne({ where: { email } });
    let tokens = null;
    if (user) {
      // Với Sinh viên: qua OTP là kích hoạt tài khoản ACTIVE ngay
      // Với Chủ trọ: vẫn giữ INACTIVE cho tới khi hoàn tất bước eKYC CCCD
      if (user.role === 'STUDENT' && user.status !== 'ACTIVE') {
        user.status = 'ACTIVE';
        await user.save();
      }
      const accessToken = user.generateAccessToken();
      const refreshTokenString = crypto.randomBytes(40).toString('hex');
      const expiresAt = new Date();
      expiresAt.setDate(expiresAt.getDate() + 7);
      await RefreshToken.create({
        user_id: user.id,
        token: refreshTokenString,
        device_info: req.headers['user-agent'] || 'Mobile App',
        expires_at: expiresAt,
      });
      tokens = {
        access_token: accessToken,
        refresh_token: refreshTokenString,
        token_type: 'Bearer',
        expires_in: env.JWT_EXPIRES_IN,
      };
    }

    res.json({
      success: true,
      message: 'Xác thực OTP thành công',
      data: {
        reset_token: resetToken,
        user: user ? {
          id: user.id,
          email: user.email,
          full_name: user.full_name,
          role: user.role,
        } : null,
        tokens,
      },
    });
  } catch (error) {
    next(error);
  }
};

const resetPassword = async (req, res, next) => {
  try {
    const { reset_token, new_password } = req.body;
    if (!reset_token || !new_password) {
      return res.status(400).json({ success: false, message: 'Thiếu reset_token hoặc mật khẩu mới' });
    }
    if (new_password.length < 6) {
      return res.status(400).json({ success: false, message: 'Mật khẩu mới tối thiểu phải có 6 ký tự' });
    }
    const record = await PasswordResetOtp.findOne({
      where: {
        reset_token,
        is_used: false,
      },
    });
    if (!record || new Date() > new Date(record.expires_at)) {
      return res.status(400).json({
        success: false,
        message: 'Phiên đặt lại mật khẩu không hợp lệ hoặc đã hết hạn',
      });
    }
    const user = await User.findOne({ where: { email: record.email } });
    if (!user) {
      return res.status(404).json({ success: false, message: 'Không tìm thấy người dùng' });
    }
    // Cập nhật mật khẩu mới (hook beforeSave trong User.js sẽ tự động băm)
    user.password_hash = new_password;
    await user.save();
    // Đánh dấu mã OTP đã sử dụng xong
    await record.update({ is_used: true });
    // Thu hồi toàn bộ Refresh Token cũ để ép đăng nhập lại trên mọi thiết bị
    await RefreshToken.update({ is_revoked: true }, { where: { user_id: user.id } });
    res.json({
      success: true,
      message: 'Đặt lại mật khẩu thành công. Vui lòng đăng nhập lại.',
    });
  } catch (error) {
    next(error);
  }
};

module.exports = {
  register,
  login,
  refreshToken,
  logout,
  getMe,
  registerValidation,
  loginValidation,
  forgotPassword,
  verifyOtp,
  resetPassword,
};
