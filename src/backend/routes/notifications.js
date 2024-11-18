const express = require('express');
const { getDb } = require('../config/db');
const router = express.Router();

//tworzenie notyfikacji 
router.post('/', async (req, res) => {
  const token = req.headers['authorization']?.split(' ')[1];

  if (!token) {
    return res.status(401).json({ error: 'Token is required' });
  }

  const { content, header } = req.body;

  try {
    const db = await getDb();
    const sqlInsertNotification = 'INSERT INTO notifications_popup (content, header) VALUES (?, ?)';
    await db.execute(sqlInsertNotification, [content, header]);
    res.status(200).json({ message: 'Success' });
  } catch (err) {
    console.error('Query error', err);
    return res.status(500).json({ error: 'DB error' });
  }
});


//wyświetlanie notyfikacji przy logowaniu
router.get('/popup', async (req, res) => {
  const token = req.headers['authorization']?.split(' ')[1];

  if (!token) {
    return res.status(401).json({ error: 'Token is required' });
  }

  try {
    const db = await getDb();
    const sqlGetNotifications = 'SELECT id, content, header FROM notifications_popup';
    const [results] = await db.execute(sqlGetNotifications);
    res.status(200).json(results);
  } catch (err) {
    console.error('Query error', err);
    return res.status(500).json({ error: 'DB error' });
  }
});


//usuwanie notyfikacji
router.delete('/popup/:id', async (req, res) => {
  const token = req.headers['authorization']?.split(' ')[1];

  if (!token) {
    return res.status(401).json({ error: 'Token is required' });
  }

  const { id } = req.params;

  try {
    const db = await getDb();
    const sqlDeleteNotification = 'DELETE FROM notifications_popup WHERE id = ?';
    const [result] = await db.execute(sqlDeleteNotification, [id]);
    if (result.affectedRows === 0) {
      return res.status(404).json({ error: 'Notification not found' });
    }
    res.status(200).json({ message: 'Notification deleted successfully' });
  } catch (err) {
    console.error('Query error', err);
    return res.status(500).json({ error: 'DB error' });
  }
});


module.exports = router;