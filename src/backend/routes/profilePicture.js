const express = require('express');
const multer = require('multer');
const path = require('path');
const { getDb } = require('../config/db');
const fs = require('fs').promises; 

const router = express.Router();

//folder do zdjęć
const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    const uploadPath = '/app/src/uploads';
    
    cb(null, uploadPath);
  },
  filename: (req, file, cb) => {
    const uniqueName = `${Date.now()}-${file.originalname}`;
    cb(null, uniqueName); 
  },
});

const upload = multer({ storage });

/**
 * @swagger
 * /api/profilePicture:
 *   post:
 *     summary: Update user profile picture delete previous from storage
 *     parameters:
 *       - name: Authorization
 *         in: header
 *         required: true
 *         description: AuthToken
 *         schema:
 *           type: string
 *     requestBody:
 *       required: true
 *       content:
 *         multipart/form-data:
 *           schema:
 *             type: object
 *             properties:
 *               file:
 *                 type: string
 *                 format: binary
 *                 description: The new profile picture file to upload
 *               userId:
 *                 type: integer
 *                 description: ID of the user 
 *             required:
 *               - file
 *               - userId
 *     responses:
 *       200:
 *         description: Profile picture updated successfully
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 url:
 *                   type: string
 *                   description: URL of the new profile picture
 *       400:
 *         description: File missing or bad request
 *       401:
 *         description: Token is required
 *       500:
 *         description: Server error or file deletion error
 */

//wstawianie nowego / usuwanie starego zdjęcia profilowego
router.post('/', upload.single('file'), async (req, res) => {
  const token = req.headers['authorization']?.split(' ')[1];
  
  if (!token) {
    return res.status(401).json({ error: 'Token is required' });
  }
  
  if (!req.file) {
    return res.status(400).send('File missing');
  }

  const userId = req.body.userId;

  try {
    const db = await getDb();
    const getUserQuery = 'SELECT profilePicture FROM users WHERE id = ?';
    const [results] = await db.execute(getUserQuery, [userId]);

    if (results.length === 0) {
      return res.status(404).send('User not found');
    }

    const currentProfilePicturePath = results[0]?.profilePicture;

    if (currentProfilePicturePath) {
      const oldPicturePath = path.join('/app/src/uploads', path.basename(currentProfilePicturePath));

      try {
        await fs.unlink(oldPicturePath);
        console.log('Success photo deleted');
      } catch (err) {
        console.error('Error deleting old photo', err);
        // return res.status(500).send('Error deleting old photo');
      }
    }

    const newProfilePicturePath = `/app/src/uploads/${req.file.filename}`;
    const updateQuery = 'UPDATE users SET profilePicture = ? WHERE id = ?';
    await db.execute(updateQuery, [newProfilePicturePath, userId]);

    res.status(200).send({ url: newProfilePicturePath });
  } catch (err) {
    console.error('Server error', err);
    res.status(500).send('Server error');
  }
});

router.delete('/', async (req, res) => {
  const token = req.headers['authorization']?.split(' ')[1];
  
  if (!token) {
    return res.status(401).json({ error: 'Token is required' });
  }

  const { userId } = req.body;

  try {
    const db = await getDb();
    const getUserQuery = 'SELECT profilePicture FROM users WHERE id = ?';
    const [results] = await db.execute(getUserQuery, [userId]);

    if (results.length === 0) {
      return res.status(404).send('User not found');
    }

    const currentProfilePicturePath = results[0]?.profilePicture;

    if (currentProfilePicturePath) {
      const oldPicturePath = path.join('/app/src/uploads', path.basename(currentProfilePicturePath));

      try {
        await fs.unlink(oldPicturePath);
        console.log('Success: Photo deleted');
      } catch (err) {
        console.error('Error deleting photo', err);
        return res.status(500).send('Error deleting photo');
      }

      const updateQuery = 'UPDATE users SET profilePicture = NULL WHERE id = ?';
      await db.execute(updateQuery, [userId]);

      res.status(200).send('Profile picture deleted successfully');
    } else {
      res.status(400).send('Error: No photo to delete');
    }
  } catch (err) {
    console.error('Error:', err);
    res.status(500).send('Server error');
  }
});

module.exports = router;
