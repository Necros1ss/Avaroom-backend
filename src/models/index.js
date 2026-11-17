const User = require('./User');
const StudentUser = require('./StudentUser');
const LandlordUser = require('./LandlordUser');
const RefreshToken = require('./RefreshToken');
const PasswordResetOtp = require('./PasswordResetOTP');
const Room = require('./Room');
const RoomImage = require('./RoomImage');
const Amenity = require('./Amenity');

// Room <-> User (Landlord)
User.hasMany(Room, { as: 'rooms', foreignKey: 'landlord_id', onDelete: 'CASCADE' });
Room.belongsTo(User, { as: 'landlord', foreignKey: 'landlord_id' });

// Room <-> RoomImage
Room.hasMany(RoomImage, { as: 'images', foreignKey: 'room_id', onDelete: 'CASCADE' });
RoomImage.belongsTo(Room, { as: 'room', foreignKey: 'room_id' });

// Room <-> Amenity (Many-to-Many qua bảng room_amenities)
Room.belongsToMany(Amenity, {
  through: 'room_amenities',
  as: 'amenities',
  foreignKey: 'room_id',
  otherKey: 'amenity_id',
  timestamps: false,
});
Amenity.belongsToMany(Room, {
  through: 'room_amenities',
  as: 'rooms',
  foreignKey: 'amenity_id',
  otherKey: 'room_id',
  timestamps: false,
});

module.exports = {
  User,
  StudentUser,
  LandlordUser,
  RefreshToken,
  PasswordResetOtp,
  Room,
  RoomImage,
  Amenity,
};
