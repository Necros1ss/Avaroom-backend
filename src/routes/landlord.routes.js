const express = require('express');
const router = express.Router();
const upload = require('../middleware/upload.middleware');
const { authForEkyc } = require('../middleware/auth.middleware');
const { verifyLandlordEkyc } = require('../controllers/id.controller');

// Endpoint: POST /api/landlord/ekyc (chính xác theo mount trong app.js: app.use('/api/landlord', ...))
// Dùng authForEkyc để cho phép chủ trọ (đang ở trạng thái INACTIVE chờ eKYC) đi qua
router.post(
    '/ekyc',
    authForEkyc,
    upload.any(),
    verifyLandlordEkyc
);

module.exports = router;