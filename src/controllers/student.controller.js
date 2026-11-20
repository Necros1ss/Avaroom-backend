const { Room, RoomImage, Amenity, User, SavedRoom } = require('../models');
const { formatRoomForApp } = require('./room.controller');

/**
 * GET /api/student/saved-rooms
 * Lấy danh sách các phòng trọ mà sinh viên đã lưu
 */
const getSavedRooms = async (req, res, next) => {
  try {
    const studentId = req.user.id;
    const { page = 1, limit = 10 } = req.query;

    const limitNum = Math.max(1, parseInt(limit) || 10);
    const pageNum = Math.max(1, parseInt(page) || 1);
    const offset = (pageNum - 1) * limitNum;

    const { count, rows: savedRecords } = await SavedRoom.findAndCountAll({
      where: { student_id: studentId },
      include: [
        {
          model: Room,
          as: 'room',
          include: [
            {
              model: RoomImage,
              as: 'images',
              attributes: ['id', 'image_url', 'is_cover', 'display_order'],
            },
            {
              model: Amenity,
              as: 'amenities',
              attributes: ['id', 'name'],
              through: { attributes: [] },
            },
            {
              model: User,
              as: 'landlord',
              attributes: ['id', 'full_name', 'avatar_url', 'phone_number'],
            },
          ],
        },
      ],
      order: [['created_at', 'DESC']],
      limit: limitNum,
      offset,
    });

    const data = savedRecords
      .filter(record => record.room)
      .map(record => {
        const roomData = formatRoomForApp(record.room);
        return {
          saved_id: record.id,
          saved_at: record.created_at,
          ...roomData,
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
    console.error('❌ [getSavedRooms Error]:', error);
    next(error);
  }
};

/**
 * POST /api/student/saved-rooms/:roomId
 * Lưu phòng trọ vào danh sách yêu thích
 */
const saveRoom = async (req, res, next) => {
  try {
    const studentId = req.user.id;
    const { roomId } = req.params;

    // Kiểm tra phòng có tồn tại không
    const room = await Room.findByPk(roomId);
    if (!room) {
      return res.status(404).json({
        success: false,
        message: 'Phòng trọ không tồn tại',
      });
    }

    // Kiểm tra đã lưu trước đó chưa
    const existing = await SavedRoom.findOne({
      where: {
        student_id: studentId,
        room_id: roomId,
      },
    });

    if (existing) {
      return res.status(400).json({
        success: false,
        message: 'Bạn đã lưu phòng trọ này trước đó',
      });
    }

    const saved = await SavedRoom.create({
      student_id: studentId,
      room_id: roomId,
    });

    return res.status(201).json({
      success: true,
      message: 'Lưu phòng trọ thành công',
      data: saved,
    });
  } catch (error) {
    console.error('❌ [saveRoom Error]:', error);
    next(error);
  }
};

/**
 * DELETE /api/student/saved-rooms/:roomId
 * Bỏ lưu phòng trọ
 */
const removeSavedRoom = async (req, res, next) => {
  try {
    const studentId = req.user.id;
    const { roomId } = req.params;

    const saved = await SavedRoom.findOne({
      where: {
        student_id: studentId,
        room_id: roomId,
      },
    });

    if (!saved) {
      return res.status(404).json({
        success: false,
        message: 'Phòng trọ này chưa được lưu trong danh sách của bạn',
      });
    }

    await saved.destroy();

    return res.json({
      success: true,
      message: 'Đã xóa phòng trọ khỏi danh sách đã lưu',
    });
  } catch (error) {
    console.error('❌ [removeSavedRoom Error]:', error);
    next(error);
  }
};

/**
 * GET /api/student/saved-rooms/check/:roomId
 * Kiểm tra xem phòng này đã được sinh viên lưu hay chưa
 */
const checkIsSaved = async (req, res, next) => {
  try {
    const studentId = req.user.id;
    const { roomId } = req.params;

    const saved = await SavedRoom.findOne({
      where: {
        student_id: studentId,
        room_id: roomId,
      },
    });

    return res.json({
      success: true,
      is_saved: !!saved,
    });
  } catch (error) {
    console.error('❌ [checkIsSaved Error]:', error);
    next(error);
  }
};

module.exports = {
  getSavedRooms,
  saveRoom,
  removeSavedRoom,
  checkIsSaved,
};
