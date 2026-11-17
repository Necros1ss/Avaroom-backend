/**
 * Seed dữ liệu phòng trọ mẫu chuẩn theo schema.sql
 * Chạy trên VPS: node seed_rooms.js
 */
require('dotenv').config({ path: __dirname + '/.env' });
const { sequelize } = require('./src/config/database');
const { Room, RoomImage, Amenity, User } = require('./src/models');

const seedRooms = async () => {
  try {
    await sequelize.authenticate();
    console.log('✅ Kết nối PostgreSQL thành công');

    // Đồng bộ cấu trúc bảng nếu chưa có
    await sequelize.sync();
    console.log('✅ Đã đồng bộ cấu trúc bảng Sequelize');

    // Tìm một chủ trọ để liên kết làm người đăng
    let landlord = await User.findOne({ where: { role: 'LANDLORD' } });
    if (!landlord) {
      console.log('⚠️ Chưa có chủ trọ, lấy tạm bất kỳ user nào');
      landlord = await User.findOne();
    }

    if (!landlord) {
      console.error('❌ Database chưa có bất kỳ user nào để gán làm chủ bài đăng');
      process.exit(1);
    }

    console.log(`👤 Gán bài đăng cho User ID=${landlord.id} (${landlord.full_name})`);

    // Danh sách 5 phòng mẫu
    const sampleRooms = [
      {
        landlord_id: landlord.id,
        title: 'Phòng trọ cao cấp Quận 1 - Full nội thất gần ĐH Kinh Tế',
        description: 'Phòng mới xây cực kỳ sạch sẽ, thoáng mát, view đẹp. Đầy đủ tiện nghi: máy lạnh, tủ lạnh, giường nệm cao cấp, giờ giấc tự do không chung chủ.',
        room_type: 'PRIVATE_ROOM',
        price: 3800000,
        deposit: 3800000,
        electricity_cost: 3500,
        water_cost: 100000,
        internet_cost: 100000,
        parking_fee: 120000,
        area_sqm: 25.5,
        max_occupants: 2,
        province: 'TP. Hồ Chí Minh',
        district: 'Quận 1',
        ward: 'Phường Bến Thành',
        street_address: '45 Nguyễn Thị Nghĩa',
        latitude: 10.7716,
        longitude: 106.6934,
        room_status: 'AVAILABLE',
        approval_status: 'APPROVED',
        is_featured: true,
        images: [
          'https://images.unsplash.com/photo-1555854877-bab0e564b8d5?w=800',
          'https://images.unsplash.com/photo-1522771739844-6a9f6d5f14af?w=800',
        ],
      },
      {
        landlord_id: landlord.id,
        title: 'Studio Chung cư mini Bình Thạnh - Gần ĐH HUTECH & ĐH GTVT',
        description: 'Căn hộ dịch vụ mini có ban công thoáng mát, bếp nấu ăn riêng biệt, thang máy, bảo vệ 24/7, camera an ninh, khóa vân tay ra vào tự do.',
        room_type: 'MINI_APARTMENT',
        price: 4500000,
        deposit: 4500000,
        electricity_cost: 3800,
        water_cost: 120000,
        internet_cost: 80000,
        parking_fee: 100000,
        area_sqm: 32.0,
        max_occupants: 2,
        province: 'TP. Hồ Chí Minh',
        district: 'Bình Thạnh',
        ward: 'Phường 25',
        street_address: '12/5 Điện Biên Phủ',
        latitude: 10.8015,
        longitude: 106.7118,
        room_status: 'AVAILABLE',
        approval_status: 'APPROVED',
        is_featured: true,
        images: [
          'https://images.unsplash.com/photo-1502672260266-1c1ef2d93688?w=800',
          'https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?w=800',
        ],
      },
      {
        landlord_id: landlord.id,
        title: 'Phòng trọ sinh viên giá rẻ Gò Vấp - Ưu tiên SV ĐH Công Nghiệp',
        description: 'Phòng sạch sẽ có gác lửng, toilet riêng trong phòng, có chỗ để xe máy an toàn, khu dân cư an ninh, đi bộ 5 phút đến trường IUH.',
        room_type: 'PRIVATE_ROOM',
        price: 2200000,
        deposit: 2200000,
        electricity_cost: 3500,
        water_cost: 80000,
        internet_cost: 70000,
        parking_fee: 0,
        area_sqm: 18.0,
        max_occupants: 3,
        province: 'TP. Hồ Chí Minh',
        district: 'Gò Vấp',
        ward: 'Phường 4',
        street_address: '88 Nguyễn Văn Bảo',
        latitude: 10.8231,
        longitude: 106.6872,
        room_status: 'AVAILABLE',
        approval_status: 'APPROVED',
        is_featured: false,
        images: [
          'https://images.unsplash.com/photo-1540518614846-7eded433c457?w=800',
        ],
      },
      {
        landlord_id: landlord.id,
        title: 'Căn hộ 1 phòng ngủ Thủ Đức - Gần Làng Đại học Quốc gia',
        description: 'Căn hộ chung cư cao cấp đầy đủ tiện ích: hồ bơi, siêu thị, phòng gym. Phòng ngủ riêng biệt, phòng khách view thoáng mát.',
        room_type: 'MINI_APARTMENT',
        price: 5200000,
        deposit: 5200000,
        electricity_cost: 3000,
        water_cost: 100000,
        internet_cost: 100000,
        parking_fee: 100000,
        area_sqm: 40.0,
        max_occupants: 3,
        province: 'TP. Hồ Chí Minh',
        district: 'Thủ Đức',
        ward: 'Phường Linh Trung',
        street_address: '25 Lê Văn Chí',
        latitude: 10.8584,
        longitude: 106.7725,
        room_status: 'AVAILABLE',
        approval_status: 'APPROVED',
        is_featured: true,
        images: [
          'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?w=800',
        ],
      },
      {
        landlord_id: landlord.id,
        title: 'Nhà nguyên căn Tân Bình - Phù hợp nhóm bạn ở chung 4-5 người',
        description: 'Nhà 1 trệt 1 lầu, 2 phòng ngủ, 2 WC, phòng khách rộng rãi, bếp nấu ăn thoải mái, sân phơi đồ riêng. Gần ĐH Bách Khoa và chợ Tân Bình.',
        room_type: 'WHOLE_HOUSE',
        price: 7800000,
        deposit: 7800000,
        electricity_cost: 2500,
        water_cost: 50000,
        internet_cost: 120000,
        parking_fee: 0,
        area_sqm: 65.0,
        max_occupants: 5,
        province: 'TP. Hồ Chí Minh',
        district: 'Tân Bình',
        ward: 'Phường 7',
        street_address: '15 Lý Thường Kiệt',
        latitude: 10.7892,
        longitude: 106.6578,
        room_status: 'AVAILABLE',
        approval_status: 'APPROVED',
        is_featured: false,
        images: [
          'https://images.unsplash.com/photo-1484154218962-a197022b5858?w=800',
        ],
      },
    ];

    for (const data of sampleRooms) {
      const { images, ...roomFields } = data;
      const [room, created] = await Room.findOrCreate({
        where: { title: roomFields.title, landlord_id: roomFields.landlord_id },
        defaults: roomFields,
      });

      if (created && images && images.length > 0) {
        for (let i = 0; i < images.length; i++) {
          await RoomImage.create({
            room_id: room.id,
            image_url: images[i],
            is_cover: i === 0,
            display_order: i,
          });
        }
      }
      console.log(`${created ? '➕ Đã tạo mới' : '✔️  Đã có sẵn'}: "${room.title}" (ID=${room.id})`);
    }

    console.log('\n🎉 Hoàn thành seed phòng trọ mẫu!');
    process.exit(0);
  } catch (error) {
    console.error('❌ Lỗi seed:', error);
    process.exit(1);
  }
};

seedRooms();
