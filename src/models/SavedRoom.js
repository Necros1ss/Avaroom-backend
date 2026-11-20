const { DataTypes, Model } = require('sequelize');
const { sequelize } = require('../config/database');

/**
 * Model SavedRoom - Khớp với bảng saved_rooms trong schema.sql
 */
class SavedRoom extends Model {}

SavedRoom.init(
  {
    id: { type: DataTypes.BIGINT, autoIncrement: true, primaryKey: true },
    student_id: {
      type: DataTypes.BIGINT,
      allowNull: false,
      references: { model: 'users', key: 'id' },
      onDelete: 'CASCADE',
    },
    room_id: {
      type: DataTypes.BIGINT,
      allowNull: false,
      references: { model: 'rooms', key: 'id' },
      onDelete: 'CASCADE',
    },
  },
  {
    sequelize,
    modelName: 'SavedRoom',
    tableName: 'saved_rooms',
    timestamps: true,
    createdAt: 'created_at',
    updatedAt: false,
  }
);

module.exports = SavedRoom;
