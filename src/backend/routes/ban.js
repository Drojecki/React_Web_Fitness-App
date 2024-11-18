const express = require('express');
const { getDb } = require('../config/db');
const router = express.Router();

//banowanie usera
router.post('/ban/:id', async (req, res) => {
    const token = req.headers['authorization']?.split(' ')[1];
    if (!token) {
      return res.status(401).json({ error: 'Token is required' });
    }
  
    const userId = req.params.id;
    const sql = 'UPDATE users SET is_banned = 1 WHERE id = ?';
  
    try {
      const db = await getDb();
      await db.execute(sql, [userId]);
      res.json({ message: 'User banned' });
    } catch (err) {
      console.error('Query error', err);
      res.status(500).json({ error: 'DB error' });
    }
  });
  

//unban usera
router.post('/unban/:id', async (req, res) => {
    const token = req.headers['authorization']?.split(' ')[1];
    if (!token) {
      return res.status(401).json({ error: 'Token is required' });
    }
  
    const userId = req.params.id;
    const sql = 'UPDATE users SET is_banned = 0 WHERE id = ?';
  
    try {
      const db = await getDb();
      await db.execute(sql, [userId]);
      res.json({ message: 'User unbanned' });
    } catch (err) {
      console.error('Query error', err);
      res.status(500).json({ error: 'DB error' });
    }
  });
  

module.exports = router;
