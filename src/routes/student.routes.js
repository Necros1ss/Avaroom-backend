const express = require('express');
const router = express.Router();
const { auth, authorize } = require('../middleware/auth.middleware');
const {
  getSavedRooms,
  saveRoom,
  removeSavedRoom,
  checkIsSaved,
} = require('../controllers/student.controller');
const {
  getOccupiedSlots,
  checkStudentRoomAppointment,
  createAppointment,
  getMyAppointments,
  getAppointmentDetail,
  cancelAppointment,
} = require('../controllers/appointment.controller');

// Tất cả endpoints đều yêu cầu đăng nhập và có role STUDENT
router.use(auth, authorize('STUDENT'));

// Quản lý phòng đã lưu
router.get('/saved-rooms', getSavedRooms);
router.get('/saved-rooms/check/:roomId', checkIsSaved);
router.post('/saved-rooms/:roomId', saveRoom);
router.delete('/saved-rooms/:roomId', removeSavedRoom);

// Đặt lịch xem phòng
router.get('/appointments/check/:roomId', checkStudentRoomAppointment);
router.get('/appointments/occupied-slots', getOccupiedSlots);
router.post('/appointments', createAppointment);
router.get('/appointments', getMyAppointments);
router.get('/appointments/:id', getAppointmentDetail);
router.patch('/appointments/:id/cancel', cancelAppointment);

module.exports = router;
