const { Appointment, Room, RoomImage, User } = require('../models');
const { Op } = require('sequelize');

/**
 * Chuẩn hóa chuỗi thời gian HH:mm sang dạng chuẩn HH:mm:ss
 */
const normalizeTime = (timeStr) => {
  if (!timeStr) return null;
  const parts = timeStr.trim().split(':');
  if (parts.length === 2) {
    const h = parts[0].padStart(2, '0');
    const m = parts[1].padStart(2, '0');
    return `${h}:${m}:00`;
  }
  if (parts.length === 3) {
    const h = parts[0].padStart(2, '0');
    const m = parts[1].padStart(2, '0');
    const s = parts[2].padStart(2, '0');
    return `${h}:${m}:${s}`;
  }
  return timeStr;
};

/**
 * Tính toán end_time mặc định (thường là 45 phút - 1 tiếng sau start_time nếu không truyền)
 */
const calculateEndTime = (startTimeStr, durationMinutes = 60) => {
  const norm = normalizeTime(startTimeStr);
  const [h, m, s] = norm.split(':').map(Number);
  const date = new Date(2000, 0, 1, h, m, s || 0);
  date.setMinutes(date.getMinutes() + durationMinutes);
  const endH = String(date.getHours()).padStart(2, '0');
  const endM = String(date.getMinutes()).padStart(2, '0');
  const endS = String(date.getSeconds()).padStart(2, '0');
  return `${endH}:${endM}:${endS}`;
};

/**
 * GET /api/student/appointments/occupied-slots
 * Lấy danh sách các khung giờ đã có người đặt trong một ngày cho phòng cụ thể
 * Query: roomId, date (YYYY-MM-DD)
 */
const getOccupiedSlots = async (req, res, next) => {
  try {
    const { roomId, date } = req.query;

    if (!roomId || !date) {
      return res.status(400).json({
        success: false,
        message: 'Vui lòng cung cấp roomId và date (định dạng YYYY-MM-DD)',
      });
    }

    // Các lịch hẹn hợp lệ làm chiếm khung giờ: PENDING hoặc CONFIRMED
    const appointments = await Appointment.findAll({
      where: {
        room_id: roomId,
        appointment_date: date,
        status: {
          [Op.in]: ['PENDING', 'CONFIRMED'],
        },
      },
      attributes: ['id', 'start_time', 'end_time', 'status'],
      order: [['start_time', 'ASC']],
    });

    const occupiedSlots = appointments.map((app) => ({
      start_time: app.start_time ? app.start_time.slice(0, 5) : null,
      end_time: app.end_time ? app.end_time.slice(0, 5) : null,
      status: app.status,
    }));

    return res.json({
      success: true,
      room_id: Number(roomId),
      date,
      occupied_slots: occupiedSlots,
    });
  } catch (error) {
    console.error('❌ [getOccupiedSlots Error]:', error);
    next(error);
  }
};

/**
 * POST /api/student/appointments
 * Sinh viên đặt lịch xem phòng
 * Body: { room_id, appointment_date, start_time, end_time, student_note }
 */
const createAppointment = async (req, res, next) => {
  try {
    const studentId = req.user.id;
    const { room_id, appointment_date, start_time, end_time, student_note } = req.body;

    // 1. Kiểm tra xem sinh viên này đã có lịch hẹn PENDING hoặc CONFIRMED cho phòng này chưa
    const existingStudentAppointment = await Appointment.findOne({
      where: {
        room_id,
        student_id: studentId,
        status: {
          [Op.in]: ['PENDING', 'CONFIRMED'],
        },
      },
    });

    if (existingStudentAppointment) {
      return res.status(400).json({
        success: false,
        message: 'Bạn đã gửi yêu cầu xem phòng rồi',
        already_booked: true,
        data: existingStudentAppointment,
      });
    }

    // Validate đầu vào
    if (!room_id || !appointment_date || !start_time) {
      return res.status(400).json({
        success: false,
        message: 'Vui lòng cung cấp đầy đủ: room_id, appointment_date (YYYY-MM-DD), start_time (HH:mm)',
      });
    }

    // Kiểm tra định dạng ngày và không cho phép đặt ngày trong quá khứ
    const reqDate = new Date(`${appointment_date}T00:00:00`);
    const today = new Date();
    today.setHours(0, 0, 0, 0);

    if (isNaN(reqDate.getTime())) {
      return res.status(400).json({
        success: false,
        message: 'Định dạng ngày hẹn không hợp lệ (YYYY-MM-DD)',
      });
    }

    if (reqDate < today) {
      return res.status(400).json({
        success: false,
        message: 'Không thể đặt lịch xem phòng vào ngày trong quá khứ',
      });
    }

    // Kiểm tra phòng có tồn tại không
    const room = await Room.findByPk(room_id);
    if (!room) {
      return res.status(404).json({
        success: false,
        message: 'Phòng trọ không tồn tại',
      });
    }

    // Nếu phòng đã cho thuê hoặc bị ẩn
    if (room.room_status !== 'AVAILABLE') {
      return res.status(400).json({
        success: false,
        message: 'Phòng trọ hiện không khả dụng để đặt lịch xem',
      });
    }

    // Chuẩn hóa thời gian
    const reqStartTime = normalizeTime(start_time);
    const reqEndTime = end_time ? normalizeTime(end_time) : calculateEndTime(start_time, 60);

    if (reqEndTime <= reqStartTime) {
      return res.status(400).json({
        success: false,
        message: 'Thời gian kết thúc phải sau thời gian bắt đầu',
      });
    }

    // Kiểm tra xung đột khung giờ (Collision Detection)
    // Điều kiện trùng giờ:
    // (ExistingStart < NewEnd) AND (ExistingEnd > NewStart)
    const conflictingAppointment = await Appointment.findOne({
      where: {
        room_id: room.id,
        appointment_date,
        status: {
          [Op.in]: ['PENDING', 'CONFIRMED'],
        },
        [Op.and]: [
          {
            start_time: {
              [Op.lt]: reqEndTime,
            },
          },
          {
            [Op.or]: [
              {
                end_time: {
                  [Op.gt]: reqStartTime,
                },
              },
              // Trường hợp end_time null thì mặc định start_time bằng nhau là trùng
              {
                end_time: null,
                start_time: reqStartTime,
              },
            ],
          },
        ],
      },
    });

    if (conflictingAppointment) {
      const conflictStart = conflictingAppointment.start_time ? conflictingAppointment.start_time.slice(0, 5) : '';
      const conflictEnd = conflictingAppointment.end_time ? conflictingAppointment.end_time.slice(0, 5) : '';
      return res.status(409).json({
        success: false,
        message: `Khung giờ ${conflictStart}${conflictEnd ? ' - ' + conflictEnd : ''} ngày ${appointment_date} đã có người đặt lịch xem phòng này. Vui lòng chọn khung giờ khác!`,
      });
    }

    // Tạo cuộc hẹn
    const appointment = await Appointment.create({
      student_id: studentId,
      landlord_id: room.landlord_id,
      room_id: room.id,
      appointment_date,
      start_time: reqStartTime,
      end_time: reqEndTime,
      student_note: student_note || null,
      status: 'PENDING',
    });

    return res.status(201).json({
      success: true,
      message: 'Đặt lịch xem phòng thành công! Đang chờ chủ trọ xác nhận.',
      data: appointment,
    });
  } catch (error) {
    console.error('❌ [createAppointment Error]:', error);
    next(error);
  }
};

/**
 * GET /api/student/appointments
 * Lấy danh sách lịch hẹn của sinh viên
 * Query: status, page, limit
 */
const getMyAppointments = async (req, res, next) => {
  try {
    const studentId = req.user.id;
    const { status, page = 1, limit = 10 } = req.query;

    const limitNum = Math.max(1, parseInt(limit) || 10);
    const pageNum = Math.max(1, parseInt(page) || 1);
    const offset = (pageNum - 1) * limitNum;

    const where = { student_id: studentId };
    if (status) {
      where.status = status;
    }

    const { count, rows: appointments } = await Appointment.findAndCountAll({
      where,
      include: [
        {
          model: Room,
          as: 'room',
          include: [
            {
              model: RoomImage,
              as: 'images',
              attributes: ['id', 'image_url', 'is_cover'],
            },
          ],
        },
        {
          model: User,
          as: 'landlord',
          attributes: ['id', 'full_name', 'phone_number', 'avatar_url'],
        },
      ],
      order: [
        ['appointment_date', 'DESC'],
        ['start_time', 'DESC'],
      ],
      limit: limitNum,
      offset,
    });

    const data = appointments.map((item) => {
      const plain = item.get({ plain: true });
      const images = plain.room?.images || [];
      const coverImg = images.find((i) => i.is_cover) || images[0];

      return {
        id: plain.id,
        appointment_date: plain.appointment_date,
        start_time: plain.start_time ? plain.start_time.slice(0, 5) : null,
        end_time: plain.end_time ? plain.end_time.slice(0, 5) : null,
        status: plain.status,
        student_note: plain.student_note,
        rejection_reason: plain.rejection_reason,
        cancellation_reason: plain.cancellation_reason,
        created_at: plain.created_at,
        room: plain.room
          ? {
              id: plain.room.id,
              title: plain.room.title,
              price: plain.room.price,
              address: `${plain.room.street_address}, ${plain.room.ward}, ${plain.room.district}, ${plain.room.province}`,
              thumbnail_url: coverImg ? coverImg.image_url : null,
            }
          : null,
        landlord: plain.landlord,
      };
    });

    return res.json({
      success: true,
      total: count,
      page: pageNum,
      totalPages: Math.ceil(count / limitNum),
      data,
    });
  } catch (error) {
    console.error('❌ [getMyAppointments Error]:', error);
    next(error);
  }
};

/**
 * GET /api/student/appointments/:id
 * Chi tiết lịch hẹn
 */
const getAppointmentDetail = async (req, res, next) => {
  try {
    const studentId = req.user.id;
    const { id } = req.params;

    const appointment = await Appointment.findOne({
      where: { id, student_id: studentId },
      include: [
        {
          model: Room,
          as: 'room',
          include: [
            {
              model: RoomImage,
              as: 'images',
              attributes: ['id', 'image_url', 'is_cover'],
            },
          ],
        },
        {
          model: User,
          as: 'landlord',
          attributes: ['id', 'full_name', 'phone_number', 'avatar_url'],
        },
      ],
    });

    if (!appointment) {
      return res.status(404).json({
        success: false,
        message: 'Lịch hẹn không tồn tại hoặc bạn không có quyền truy cập',
      });
    }

    const plain = appointment.get({ plain: true });
    const images = plain.room?.images || [];
    const coverImg = images.find((i) => i.is_cover) || images[0];

    return res.json({
      success: true,
      data: {
        id: plain.id,
        appointment_date: plain.appointment_date,
        start_time: plain.start_time ? plain.start_time.slice(0, 5) : null,
        end_time: plain.end_time ? plain.end_time.slice(0, 5) : null,
        status: plain.status,
        student_note: plain.student_note,
        rejection_reason: plain.rejection_reason,
        cancellation_reason: plain.cancellation_reason,
        created_at: plain.created_at,
        room: plain.room
          ? {
              id: plain.room.id,
              title: plain.room.title,
              price: plain.room.price,
              address: `${plain.room.street_address}, ${plain.room.ward}, ${plain.room.district}, ${plain.room.province}`,
              thumbnail_url: coverImg ? coverImg.image_url : null,
            }
          : null,
        landlord: plain.landlord,
      },
    });
  } catch (error) {
    console.error('❌ [getAppointmentDetail Error]:', error);
    next(error);
  }
};

/**
 * PATCH /api/student/appointments/:id/cancel
 * Sinh viên hủy lịch hẹn
 * Body: { cancellation_reason }
 */
const cancelAppointment = async (req, res, next) => {
  try {
    const studentId = req.user.id;
    const { id } = req.params;
    const { cancellation_reason } = req.body;

    const appointment = await Appointment.findOne({
      where: { id, student_id: studentId },
    });

    if (!appointment) {
      return res.status(404).json({
        success: false,
        message: 'Lịch hẹn không tồn tại hoặc bạn không có quyền hủy',
      });
    }

    if (['COMPLETED', 'CANCELLED', 'REJECTED'].includes(appointment.status)) {
      return res.status(400).json({
        success: false,
        message: `Không thể hủy lịch hẹn đã ở trạng thái ${appointment.status}`,
      });
    }

    appointment.status = 'CANCELLED';
    appointment.cancellation_reason = cancellation_reason || 'Sinh viên hủy lịch hẹn';
    await appointment.save();

    return res.json({
      success: true,
      message: 'Hủy lịch hẹn thành công',
      data: {
        id: appointment.id,
        status: appointment.status,
        cancellation_reason: appointment.cancellation_reason,
      },
    });
  } catch (error) {
    console.error('❌ [cancelAppointment Error]:', error);
    next(error);
  }
};

/**
 * GET /api/student/appointments/check/:roomId
 * Kiểm tra xem sinh viên hiện tại đã đặt lịch xem phòng này chưa (ở trạng thái PENDING hoặc CONFIRMED)
 */
const checkStudentRoomAppointment = async (req, res, next) => {
  try {
    const studentId = req.user.id;
    const { roomId } = req.params;

    const appointment = await Appointment.findOne({
      where: {
        room_id: roomId,
        student_id: studentId,
        status: {
          [Op.in]: ['PENDING', 'CONFIRMED'],
        },
      },
      attributes: ['id', 'appointment_date', 'start_time', 'end_time', 'status'],
    });

    return res.json({
      success: true,
      has_booked: !!appointment,
      appointment: appointment || null,
    });
  } catch (error) {
    console.error('❌ [checkStudentRoomAppointment Error]:', error);
    next(error);
  }
};

module.exports = {
  getOccupiedSlots,
  checkStudentRoomAppointment,
  createAppointment,
  getMyAppointments,
  getAppointmentDetail,
  cancelAppointment,
};
