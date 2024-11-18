const express = require('express');
const multer = require('multer');
const { getDb } = require('../config/db');
const path = require('path');
const router = express.Router();


//sciezka do przechowywania zdjec 
const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    const uploadPath = path.resolve('/app/src/uploads');
    cb(null, uploadPath);
  },
  filename: (req, file, cb) => {
    cb(null, file.originalname);
  },
});

const upload = multer({ storage });

//wyświetla unikalne id zdobyte przez usera
router.get('/trophies/:id', async (req, res) => {
  const token = req.headers['authorization']?.split(' ')[1];
  const userId = req.params.id;

  if (!token) {
    return res.status(401).json({ error: 'Token is required' });
  }

  try {
    const db = await getDb();
    const sqlQuery = 'SELECT id, title, image, TrophyImage, user_ids FROM events WHERE FIND_IN_SET(?, user_ids) > 0';
    const [results] = await db.execute(sqlQuery, [userId]);

    if (results.length === 0) {
      return res.status(200).json({ message: 'No trophies found' });
    }

    res.json(results);
    console.log(results);
    return res.status(200).json({ message: 'Gicior' });
  } catch (err) {
    console.error('Query error:', err);
    return res.status(500).json({ error: 'DB error' });
  }
});

  //tworzenie eventu z panelu admina
  router.post('/', upload.fields([{ name: 'image' }, { name: 'trophyImage' }]), async (req, res) => {
    const token = req.headers['authorization']?.split(' ')[1];
    const uploadPath = '/app/src/uploads';
    if (!token) {
        return res.status(401).json({ error: 'Token is required' });
    }
    
    const { title, description, startDate, endDate, type, distance } = req.body;
    const files = req.files;

    if (!title || !description || !startDate || !endDate || !type || !distance) {
        return res.status(400).json({ message: 'All fields are required' });
    }

    let imageUrl = null;
    let trophyImageUrl = null;

    if (files && files.image && files.image[0]) {
        imageUrl = `${uploadPath}/${files.image[0].originalname}`;
    }

    if (files && files.trophyImage && files.trophyImage[0]) {
        trophyImageUrl = `${uploadPath}/${files.trophyImage[0].originalname}`;
    }

    const sqlInsertEvent = `
        INSERT INTO events (title, description, startDate, endDate, type, distance, image, TrophyImage)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?)
    `;
    
    try {
      const db = await getDb();
        const [result] = await db.execute(sqlInsertEvent, [title, description, startDate, endDate, type, distance, imageUrl, trophyImageUrl]);
        
        res.status(201).json({ message: 'Event created', eventId: result.insertId });
    } catch (err) {
        console.error('Error:', err);
        res.status(500).json({ message: 'Server error' });
    }
});


//usuwa event i wszystkie jego dane 
router.delete('/:eventId', async (req, res) => {
  const token = req.headers['authorization']?.split(' ')[1];
  if (!token) {
    return res.status(401).json({ error: 'Token is required' });
  }
  
  const eventId = req.params.eventId;

  try {
    const db = await getDb();
    const sqlSelectEvent = 'SELECT image, TrophyImage FROM events WHERE id = ?';
    const [results] = await db.execute(sqlSelectEvent, [eventId]);

    if (results.length === 0) {
      return res.status(404).json({ message: 'Event not found' });
    }

    const event = results[0];
    const imageUrl = event.image;
    const trophyImageUrl = event.TrophyImage;

    // Usuwanie obrazów, jeśli istnieją
    if (imageUrl) {
      const imageFilePath = path.join('/app/src/uploads', imageUrl);
      try {
        await fs.unlink(imageFilePath);
        console.log('Image deleted:', imageFilePath);
      } catch (err) {
        console.error('Error deleting image:', err);
      }
    }

    if (trophyImageUrl) {
      const trophyFilePath = path.join('/app/src/uploads', trophyImageUrl);
      try {
        await fs.unlink(trophyFilePath);
        console.log('Trophy image deleted:', trophyFilePath);
      } catch (err) {
        console.error('Error deleting trophy image:', err);
      }
    }

    const deleteEventQuery = 'DELETE FROM events WHERE id = ?';
    await db.execute(deleteEventQuery, [eventId]);

    res.status(200).json({ message: 'Event deleted' });

  } catch (err) {
    console.error('Error:', err);
    res.status(500).json({ message: 'Server error' });
  }
});

  
//wyświetla dane eventów
router.get('/', async (req, res) => {
  const token = req.headers['authorization']?.split(' ')[1];
  if (!token) {
    return res.status(401).json({ error: 'Token is required' });
  }

  try {
    const db = await getDb();
    const sqlSelectEvents = 'SELECT * FROM events';
    const [results] = await db.execute(sqlSelectEvents);
    const processedResults = results.map(event => {
      return {
        ...event,
        user_ids: event.user_ids ? event.user_ids.split(',') : []
      };
    });

    res.status(200).json(processedResults);
  } catch (err) {
    console.error('query error', err);
    res.status(500).json({ message: 'Server error' });
  }
});




router.patch('/:id/status', async (req, res) => {
  const token = req.headers['authorization']?.split(' ')[1];
  if (!token) {
    return res.status(401).json({ error: 'Token is required' });
  }

  const { id } = req.params;
  const { status } = req.body;

  if (!['active', 'inactive'].includes(status)) {
    return res.status(400).json({ error: 'Invalid status' });
  }

  try {
    const db = await getDb();
    const sql = 'UPDATE events SET status = ? WHERE id = ?';
    await db.execute(sql, [status, id]);

    res.json({ message: 'Event updated successfully' });
  } catch (err) {
    console.error('Query error', err);
    res.status(500).json({ error: 'Database error' });
  }
});


router.post('/:eventId/complete', async (req, res) => {
  const token = req.headers['authorization']?.split(' ')[1];
  if (!token) {
    return res.status(401).json({ error: 'Token is required' });
  }
  
  const { userId } = req.body;
  const { eventId } = req.params;

  try {
    const db = await getDb();
    const sqlCheckUser = 'SELECT user_ids FROM events WHERE id = ?';
    const [results] = await db.execute(sqlCheckUser, [eventId]);

    if (results.length === 0) {
      return res.status(404).json({ message: 'Event not found' });
    }

    const userIds = results[0].user_ids ? results[0].user_ids.split(',') : [];

    if (userIds.includes(userId.toString())) {
      return res.status(200).json({ message: 'User already added' });
    }

    userIds.push(userId);
    const updatedUserIds = userIds.join(',');

    const sqlUpdateEvent = 'UPDATE events SET user_ids = ? WHERE id = ?';
    await db.execute(sqlUpdateEvent, [updatedUserIds, eventId]);

    res.status(200).json({ message: 'User added' });
  } catch (err) {
    console.error('Query error', err);
    res.status(500).json({ error: 'DB error' });
  }
});

router.get('/:id', async (req, res) => {
  const token = req.headers['authorization']?.split(' ')[1];
  if (!token) {
    return res.status(401).json({ error: 'Token is required' });
  }

  const eventId = req.params.id;
  const sql = 'SELECT * FROM events WHERE id = ?';

  try {
    const db = await getDb();
    const [results] = await db.execute(sql, [eventId]);

    if (results.length === 0) {
      return res.status(404).json({ error: 'Event not found' });
    }

    res.json(results[0]);
  } catch (err) {
    console.error('Query error', err);
    res.status(500).json({ error: 'DB error' });
  }
});


module.exports = router;
