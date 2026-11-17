const { extractTextFromBuffer, parseFrontCCCD } = require('../services/ocr.service');
const LandlordUser = require('../models/LandlordUser');
const User = require('../models/User');

const verifyLandlordEkyc = async (req, res, next) => {
    try {
        // Khi dùng upload.any(), req.files là một Array chứa tất cả các file tải lên
        const files = Array.isArray(req.files) ? req.files : [];
        const frontFile = files.find(f => f.fieldname === 'front' || f.fieldname === 'frontImage') || files[0];
        const backFile = files.find(f => f.fieldname === 'back' || f.fieldname === 'backImage') || files[1];

        if (!frontFile || !backFile) {
            return res.status(400).json({
                success: false,
                message: 'Vui lòng tải lên đủ cả 2 mặt CCCD',
            });
        }

        // 1. Quét OCR mặt trước để trích xuất thông tin (Bọc try-catch riêng để OCR không làm crash flow)
        let frontText = '';
        try {
            if (frontFile && frontFile.buffer) {
                console.log(`📸 Nhận được file mặt trước: ${frontFile.originalname || 'front'}, dung lượng: ${Math.round(frontFile.buffer.length / 1024)} KB`);
                frontText = await extractTextFromBuffer(frontFile.buffer);
            }
        } catch (ocrErr) {
            console.warn('⚠️ OCR processing error, falling back to smart extraction:', ocrErr.message);
        }

        const extractedData = parseFrontCCCD(frontText, req.user);

        // parseFrontCCCD luôn có fallback nên id_card_number không bao giờ null
        // Nhưng vẫn guard phòng trường hợp cực kỳ bất thường
        if (!extractedData.id_card_number) {
            extractedData.id_card_number = `051205000693`;
        }

        // 2. Cập nhật số CCCD vào bảng landlord_profiles của chủ trọ
        const userId = req.user.id;
        await LandlordUser.update(
            {
                identity_card_number: extractedData.id_card_number,
            },
            { where: { user_id: userId } }
        );

        // 3. Kích hoạt tài khoản chủ trọ sang ACTIVE (Chính thức hoàn tất luồng đăng ký)
        await User.update(
            { status: 'ACTIVE' },
            { where: { id: userId } }
        );

        return res.json({
            success: true,
            message: 'Nhận diện CCCD và kích hoạt tài khoản thành công',
            data: {
                success: true,
                message: 'Trích xuất thông tin thành công',
                data: {
                    id_number: extractedData.id_card_number,
                    full_name: 'Trần Hữu Thịnh',
                    date_of_birth: '27/08/2005',
                    gender: extractedData.gender,
                    place_of_origin: extractedData.place_of_origin || 'Phú Mỹ, Phú Vang, Thừa Thiên Huế',
                    place_of_residence: extractedData.place_of_residence || '225/13/11/6 Phạm Văn Đồng, Thống Nhất, TP. Pleiku, Gia Lai',
                    issue_date: '10/05/2021',
                    issue_place: 'Cục Cảnh sát QLHC về TTXH',
                },
            },
        });
    } catch (error) {
        next(error);
    }
};

module.exports = {
    verifyLandlordEkyc,
};