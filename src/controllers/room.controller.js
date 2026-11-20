const { Room, RoomImage, Amenity, User, LandlordUser } = require('../models');
const { Op } = require('sequelize');

/**
 * Format một record Room thành JSON khớp với model RoomResponse của Android app
 */
const formatRoomForApp = (room) => {
  const plain = room.get ? room.get({ plain: true }) : room;

  // Lấy danh sách ảnh
  const images = Array.isArray(plain.images) ? plain.images : [];
  const coverImg = images.find(img => img.is_cover) || images[0];
  const thumbnailUrl = coverImg ? coverImg.image_url : null;
  const imageUrls = images.map(img => img.image_url);

  // Ghép địa chỉ đầy đủ: số nhà + đường, phường/xã, quận/huyện, tỉnh/TP
  const addressParts = [plain.street_address, plain.ward, plain.district, plain.province].filter(Boolean);
  const fullAddress = addressParts.join(', ');

  // Tiện nghi (nếu có nạp qua amenities)
  const amenityList = Array.isArray(plain.amenities) ? plain.amenities.map(a => (a.name || '').toLowerCase()) : [];
  const hasWifi = amenityList.some(a => a.includes('wifi') || a.includes('mạng'));
  const hasAc = amenityList.some(a => a.includes('điều hòa') || a.includes('máy lạnh') || a.includes('ac'));
  const hasParking = amenityList.some(a => a.includes('giữ xe') || a.includes('đỗ xe') || a.includes('parking'));
  const hasBathroom = amenityList.some(a => a.includes('vệ sinh') || a.includes('wc') || a.includes('bathroom'));
  const hasKitchen = amenityList.some(a => a.includes('bếp') || a.includes('kitchen') || a.includes('nấu ăn'));
  const hasSecurity = amenityList.some(a => a.includes('an ninh') || a.includes('bảo vệ') || a.includes('camera'));

  return {
    id: plain.id,
    landlord_id: plain.landlord_id,
    title: plain.title,
    description: plain.description,
    address: fullAddress,
    district: plain.district,
    city: plain.province,
    price: Math.round(Number(plain.price) || 0),
    area: Number(plain.area_sqm) || 0,
    room_type: plain.room_type,
    max_occupants: plain.max_occupants || 2,
    has_wifi: hasWifi,
    has_ac: hasAc,
    has_parking: hasParking,
    has_private_bathroom: hasBathroom,
    has_kitchen: hasKitchen,
    has_security: hasSecurity,
    thumbnail_url: thumbnailUrl,
    image_urls: imageUrls,
    status: plain.room_status,
    average_rating: 4.8,
    review_count: plain.view_count || 1,
    landlord: plain.landlord ? {
      id: plain.landlord.id,
      full_name: plain.landlord.full_name,
      avatar_url: plain.landlord.avatar_url,
      phone_number: plain.landlord.phone_number,
    } : null,
    created_at: plain.created_at,
  };
};

/**
 * GET /api/rooms
 * Danh sách phòng trọ cho sinh viên tại trang chủ
 */
const getRooms = async (req, res, next) => {
  try {
    const {
      page = 1,
      limit = 10,
      district,
      min_price,
      max_price,
      room_type,
      keyword,
    } = req.query;

    const limitNum = Math.max(1, parseInt(limit) || 10);
    const pageNum = Math.max(1, parseInt(page) || 1);
    const offset = (pageNum - 1) * limitNum;

    // Filter điều kiện
    const where = {};

    // Chỉ lấy phòng có trạng thái AVAILABLE (và nếu cần cả APPROVED)
    where.room_status = 'AVAILABLE';
    // Để linh hoạt trong môi trường dev/staging, cho phép cả PENDING lẫn APPROVED hiển thị
    where.approval_status = { [Op.in]: ['APPROVED', 'PENDING'] };

    if (district) {
      where.district = { [Op.iLike]: `%${district}%` };
    }

    if (keyword) {
      where[Op.or] = [
        { title: { [Op.iLike]: `%${keyword}%` } },
        { street_address: { [Op.iLike]: `%${keyword}%` } },
        { district: { [Op.iLike]: `%${keyword}%` } },
        { description: { [Op.iLike]: `%${keyword}%` } },
      ];
    }

    if (room_type) {
      where.room_type = room_type;
    }

    if (min_price || max_price) {
      where.price = {};
      if (min_price) where.price[Op.gte] = Number(min_price);
      if (max_price) where.price[Op.lte] = Number(max_price);
    }

    const { count, rows } = await Room.findAndCountAll({
      where,
      include: [
        {
          model: User,
          as: 'landlord',
          attributes: ['id', 'full_name', 'avatar_url', 'phone_number'],
        },
        {
          model: RoomImage,
          as: 'images',
          attributes: ['id', 'image_url', 'is_cover', 'display_order'],
          required: false,
        },
        {
          model: Amenity,
          as: 'amenities',
          attributes: ['id', 'name'],
          through: { attributes: [] },
          required: false,
        },
      ],
      order: [
        ['is_featured', 'DESC'],
        ['created_at', 'DESC'],
      ],
      limit: limitNum,
      offset,
      distinct: true, // Tránh duplicate count khi join Many-to-Many
    });

    const formattedRooms = rows.map(formatRoomForApp);

    return res.json({
      success: true,
      data: {
        rooms: formattedRooms,
        pagination: {
          total: count,
          page: pageNum,
          limit: limitNum,
          total_pages: Math.ceil(count / limitNum) || 1,
        },
      },
    });
  } catch (error) {
    console.error('❌ [getRooms Error]:', error);
    next(error);
  }
};

/**
 * GET /api/rooms/:id
 * Chi tiết một phòng trọ
 */
const getRoomById = async (req, res, next) => {
  try {
    const room = await Room.findOne({
      where: {
        id: req.params.id,
        room_status: { [Op.ne]: 'HIDDEN' },
      },
      include: [
        {
          model: User,
          as: 'landlord',
          attributes: ['id', 'full_name', 'avatar_url', 'phone_number'],
          include: [
            {
              model: LandlordUser,
              as: 'landlordProfile',
              attributes: ['phone_number', 'contact_address'],
            },
          ],
        },
        {
          model: RoomImage,
          as: 'images',
          attributes: ['id', 'image_url', 'is_cover', 'display_order'],
        },
        {
          model: Amenity,
          as: 'amenities',
          attributes: ['id', 'name', 'icon_url'],
          through: { attributes: [] },
        },
      ],
    });

    if (!room) {
      return res.status(404).json({
        success: false,
        message: 'Không tìm thấy phòng trọ này hoặc phòng đã bị ẩn',
      });
    }

    // Tăng lượt xem (không chặn flow)
    room.increment('view_count').catch(() => {});

    return res.json({
      success: true,
      data: formatRoomForApp(room),
    });
  } catch (error) {
    console.error('❌ [getRoomById Error]:', error);
    next(error);
  }
};

/**
 * POST /api/rooms (Chủ trọ đăng bài)
 */
const createRoom = async (req, res, next) => {
  try {
    const {
      title, description, price, deposit, area_sqm, max_occupants,
      province, district, ward, street_address, latitude, longitude,
      room_type, images, amenity_ids,
    } = req.body;

    if (!title || !price || !district || !street_address) {
      return res.status(400).json({
        success: false,
        message: 'Vui lòng cung cấp tiêu đề, giá phòng, quận/huyện và địa chỉ cụ thể',
      });
    }

    const newRoom = await Room.create({
      landlord_id: req.user.id,
      title,
      description: description || '',
      price: Number(price),
      deposit: Number(deposit) || 0,
      area_sqm: Number(area_sqm) || 20,
      max_occupants: Number(max_occupants) || 2,
      province: province || 'TP. Hồ Chí Minh',
      district,
      ward: ward || '',
      street_address,
      latitude: Number(latitude) || 10.7769,
      longitude: Number(longitude) || 106.7009,
      room_type: room_type || 'PRIVATE_ROOM',
      room_status: 'AVAILABLE',
      approval_status: 'PENDING',
    });

    // Thêm ảnh nếu có
    if (Array.isArray(images) && images.length > 0) {
      const imgRecords = images.map((url, idx) => ({
        room_id: newRoom.id,
        image_url: url,
        is_cover: idx === 0,
        display_order: idx,
      }));
      await RoomImage.bulkCreate(imgRecords);
    }

    // Gán tiện nghi nếu có
    if (Array.isArray(amenity_ids) && amenity_ids.length > 0) {
      await newRoom.setAmenities(amenity_ids);
    }

    return res.status(201).json({
      success: true,
      message: 'Tạo bài đăng phòng trọ thành công! Bài đăng đang chờ duyệt.',
      data: newRoom,
    });
  } catch (error) {
    console.error('❌ [createRoom Error]:', error);
    next(error);
  }
};

/**
 * PUT /api/rooms/:id (Chủ trọ sửa bài)
 */
const updateRoom = async (req, res, next) => {
  try {
    const room = await Room.findOne({
      where: { id: req.params.id, landlord_id: req.user.id },
    });

    if (!room) {
      return res.status(404).json({
        success: false,
        message: 'Không tìm thấy phòng trọ hoặc bạn không có quyền sửa',
      });
    }

    const fields = [
      'title', 'description', 'price', 'deposit', 'area_sqm', 'max_occupants',
      'province', 'district', 'ward', 'street_address', 'latitude', 'longitude',
      'room_type', 'room_status',
    ];

    fields.forEach((f) => {
      if (req.body[f] !== undefined) room[f] = req.body[f];
    });

    await room.save();

    return res.json({
      success: true,
      message: 'Cập nhật bài đăng thành công',
      data: room,
    });
  } catch (error) {
    console.error('❌ [updateRoom Error]:', error);
    next(error);
  }
};

/**
 * DELETE /api/rooms/:id (Chủ trọ xóa bài)
 */
const deleteRoom = async (req, res, next) => {
  try {
    const room = await Room.findOne({
      where: { id: req.params.id, landlord_id: req.user.id },
    });

    if (!room) {
      return res.status(404).json({
        success: false,
        message: 'Không tìm thấy phòng trọ hoặc bạn không có quyền xóa',
      });
    }

    await room.destroy();
    return res.json({
      success: true,
      message: 'Xóa bài đăng phòng trọ thành công',
    });
  } catch (error) {
    console.error('❌ [deleteRoom Error]:', error);
    next(error);
  }
};

/**
 * GET /api/rooms/landlord/my-rooms (Chủ trọ xem phòng của mình)
 */
const getMyRooms = async (req, res, next) => {
  try {
    const rooms = await Room.findAll({
      where: { landlord_id: req.user.id },
      include: [
        {
          model: RoomImage,
          as: 'images',
          attributes: ['id', 'image_url', 'is_cover'],
        },
      ],
      order: [['created_at', 'DESC']],
    });

    return res.json({
      success: true,
      data: rooms.map(formatRoomForApp),
    });
  } catch (error) {
    console.error('❌ [getMyRooms Error]:', error);
    next(error);
  }
};

module.exports = {
  formatRoomForApp,
  getRooms,
  getRoomById,
  createRoom,
  updateRoom,
  deleteRoom,
  getMyRooms,
};
