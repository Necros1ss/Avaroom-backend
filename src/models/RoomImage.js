const { DataTypes, Model } = require('sequelize');
const { sequelize } = require('../config/database');

/**
 * Model Ảnh Phòng Trọ - khớp với bảng room_images trong schema.sql
 */
class RoomImage extends Model {}

RoomImage.init(
  {
    id: { type: DataTypes.BIGINT, autoIncrement: true, primaryKey: true },
    room_id: {
      type: DataTypes.BIGINT,
      allowNull: false,
      references: { model: 'rooms', key: 'id' },
      onDelete: 'CASCADE',
    },
    image_url: { type: DataTypes.STRING(500), allowNull: false },
    is_cover: { type: DataTypes.BOOLEAN, allowNull: false, defaultValue: false },
    display_order: { type: DataTypes.INTEGER, allowNull: false, defaultValue: 0 },
  },
  {
    sequelize,
    modelName: 'RoomImage',
    tableName: 'room_images',
    timestamps: true,
    createdAt: 'created_at',
    updatedAt: false,
  }
);

module.exports = RoomImage;

