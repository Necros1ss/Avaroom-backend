const express = require('express');
const router = express.Router();
const { auth, authorize } = require('../middleware/auth.middleware');
const {
  getRooms,
  getRoomById,
  createRoom,
  updateRoom,
  deleteRoom,
  getMyRooms,
} = require('../controllers/room.controller');

// ─── PUBLIC (Sinh viên không cần đăng nhập để xem danh sách & chi tiết) ───────
router.get('/', getRooms);                      // GET /api/rooms
router.get('/:id', getRoomById);                // GET /api/rooms/:id

// ─── LANDLORD ONLY (Cần đăng nhập + role LANDLORD) ────────────────────────────
router.get('/landlord/my-rooms', auth, authorize('LANDLORD'), getMyRooms);   // GET /api/rooms/landlord/my-rooms
router.post('/', auth, authorize('LANDLORD'), createRoom);                    // POST /api/rooms
router.put('/:id', auth, authorize('LANDLORD'), updateRoom);                  // PUT /api/rooms/:id
router.delete('/:id', auth, authorize('LANDLORD'), deleteRoom);               // DELETE /api/rooms/:id

module.exports = router;

