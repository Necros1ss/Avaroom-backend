const { DataTypes, Model } = require('sequelize');
const { sequelize } = require('../config/database');

/**
 * Model Phòng Trọ - khớp với schema.sql thực tế trên PostgreSQL
 * Bảng: rooms
 */
class Room extends Model {}

Room.init(
  {
    id: { type: DataTypes.BIGINT, autoIncrement: true, primaryKey: true },
    landlord_id: {
      type: DataTypes.BIGINT,
      allowNull: false,
      references: { model: 'users', key: 'id' },
      onDelete: 'CASCADE',
    },
    title: { type: DataTypes.STRING(255), allowNull: false },
    description: { type: DataTypes.TEXT, allowNull: false, defaultValue: '' },
    room_type: {
      type: DataTypes.ENUM('DORMITORY', 'PRIVATE_ROOM', 'SHARED_ROOM', 'MINI_APARTMENT', 'WHOLE_HOUSE'),
      allowNull: false,
      defaultValue: 'PRIVATE_ROOM',
    },
    price: { type: DataTypes.DECIMAL(12, 2), allowNull: false },
    deposit: { type: DataTypes.DECIMAL(12, 2), allowNull: false, defaultValue: 0 },
    electricity_cost: { type: DataTypes.DECIMAL(10, 2), allowNull: true },
    water_cost: { type: DataTypes.DECIMAL(10, 2), allowNull: true },
    internet_cost: { type: DataTypes.DECIMAL(10, 2), allowNull: true },
    parking_fee: { type: DataTypes.DECIMAL(10, 2), allowNull: true },
    area_sqm: { type: DataTypes.DOUBLE, allowNull: false, defaultValue: 0 },
    max_occupants: { type: DataTypes.INTEGER, allowNull: false, defaultValue: 2 },
    // Địa chỉ phân cấp đầy đủ
    province: { type: DataTypes.STRING(100), allowNull: false, defaultValue: 'TP. Hồ Chí Minh' },
    district: { type: DataTypes.STRING(100), allowNull: false },
    ward: { type: DataTypes.STRING(100), allowNull: false, defaultValue: '' },
    street_address: { type: DataTypes.STRING(255), allowNull: false },
    latitude: { type: DataTypes.DOUBLE, allowNull: false, defaultValue: 10.7769 },
    longitude: { type: DataTypes.DOUBLE, allowNull: false, defaultValue: 106.7009 },
    // Trạng thái phòng và phê duyệt
    room_status: {
      type: DataTypes.ENUM('AVAILABLE', 'RENTED', 'HIDDEN'),
      allowNull: false,
      defaultValue: 'AVAILABLE',
    },
    approval_status: {
      type: DataTypes.ENUM('PENDING', 'APPROVED', 'REJECTED'),
      allowNull: false,
      defaultValue: 'PENDING',
    },
    rejection_reason: { type: DataTypes.TEXT, allowNull: true },
    moderated_by: { type: DataTypes.BIGINT, allowNull: true },
    moderated_at: { type: DataTypes.DATE, allowNull: true },
    view_count: { type: DataTypes.INTEGER, defaultValue: 0 },
    is_featured: { type: DataTypes.BOOLEAN, defaultValue: false },
  },
  {
    sequelize,
    modelName: 'Room',
    tableName: 'rooms',
    timestamps: true,
    createdAt: 'created_at',
    updatedAt: 'updated_at',
  }
);

module.exports = Room;
