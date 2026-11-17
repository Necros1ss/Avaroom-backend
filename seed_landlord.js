const { sequelize } = require('./src/config/database');
const User = require('./src/models/User');
const LandlordUser = require('./src/models/LandlordUser');

(async () => {
  try {
    await sequelize.authenticate();
    console.log('🔗 Kết nối database thành công...');

    let [user, created] = await User.findOrCreate({
      where: { email: 'chutro@gmail.com' },
      defaults: {
        password_hash: '1',
        full_name: 'Chủ Trọ Demo',
        phone_number: '0987654321',
        role: 'LANDLORD',
        status: 'ACTIVE'
      }
    });

    if (!created) {
      user.password_hash = '1';
      user.role = 'LANDLORD';
      user.status = 'ACTIVE';
      await user.save();
    }

    await LandlordUser.findOrCreate({
      where: { user_id: user.id },
      defaults: { phone_number: '0987654321' }
    });

    console.log('✅ Đã tạo/cập nhật thành công tài khoản chutro@gmail.com với pass là 1');
    process.exit(0);
  } catch (err) {
    console.error('❌ Lỗi:', err);
    process.exit(1);
  }
})();
