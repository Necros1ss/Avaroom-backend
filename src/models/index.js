const User = require('./User');
const StudentUser = require('./StudentUser');
const LandlordUser = require('./LandlordUser');
const RefreshToken = require('./RefreshToken');
const PasswordResetOtp = require('./PasswordResetOTP');
const Room = require('./Room');
const RoomImage = require('./RoomImage');
const Amenity = require('./Amenity');
const SavedRoom = require('./SavedRoom');
const Appointment = require('./Appointment');

// Room <-> User (Landlord)
User.hasMany(Room, { as: 'rooms', foreignKey: 'landlord_id', onDelete: 'CASCADE' });
Room.belongsTo(User, { as: 'landlord', foreignKey: 'landlord_id' });

// User (Student) <-> Room qua SavedRoom
User.hasMany(SavedRoom, { as: 'savedRooms', foreignKey: 'student_id', onDelete: 'CASCADE' });
SavedRoom.belongsTo(User, { as: 'student', foreignKey: 'student_id' });

Room.hasMany(SavedRoom, { as: 'savedByStudents', foreignKey: 'room_id', onDelete: 'CASCADE' });
SavedRoom.belongsTo(Room, { as: 'room', foreignKey: 'room_id' });

User.belongsToMany(Room, {
  through: SavedRoom,
  as: 'favoriteRooms',
  foreignKey: 'student_id',
  otherKey: 'room_id',
});
Room.belongsToMany(User, {
  through: SavedRoom,
  as: 'favoritedBy',
  foreignKey: 'room_id',
  otherKey: 'student_id',
});

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

// Appointment associations
// Student <-> Appointment
User.hasMany(Appointment, { as: 'studentAppointments', foreignKey: 'student_id', onDelete: 'CASCADE' });
Appointment.belongsTo(User, { as: 'student', foreignKey: 'student_id' });

// Landlord <-> Appointment
User.hasMany(Appointment, { as: 'landlordAppointments', foreignKey: 'landlord_id', onDelete: 'CASCADE' });
Appointment.belongsTo(User, { as: 'landlord', foreignKey: 'landlord_id' });

// Room <-> Appointment
Room.hasMany(Appointment, { as: 'appointments', foreignKey: 'room_id', onDelete: 'CASCADE' });
Appointment.belongsTo(Room, { as: 'room', foreignKey: 'room_id' });

module.exports = {
  User,
  StudentUser,
  LandlordUser,
  RefreshToken,
  PasswordResetOtp,
  Room,
  RoomImage,
  Amenity,
  SavedRoom,
  Appointment,
};
