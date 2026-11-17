const { DataTypes, Model } = require('sequelize');
const { sequelize } = require('../config/database');

/**
 * Model Tiện Nghi - khớp với bảng amenities trong schema.sql
 */
class Amenity extends Model {}

Amenity.init(
  {
    id: { type: DataTypes.BIGINT, autoIncrement: true, primaryKey: true },
    name: { type: DataTypes.STRING(100), allowNull: false, unique: true },
    icon_url: { type: DataTypes.STRING(500), allowNull: true },
  },
  {
    sequelize,
    modelName: 'Amenity',
    tableName: 'amenities',
    timestamps: true,
    createdAt: 'created_at',
    updatedAt: false,
  }
);

module.exports = Amenity;

