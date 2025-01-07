const express = require('express');
const { getDb } = require('../config/db');
const router = express.Router();

/**
 * @swagger
 * /api/ban/ban/{id}:
 *   post:
 *     summary: Ban user
 *     parameters:
 *       - name: id
 *         in: path
 *         required: true
 *         description: User Id to ban
 *         schema:
 *           type: integer
 *       - name: Authorization
 *         in: header
 *         required: true
 *         description: AuthToken
 *         schema:
 *           type: string
 *     responses:
 *       200:
 *         description: UserBanned
 *       401:
 *         description: Token is required
 *       500:
 *         description: DB error
 */

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
  

/**
 * @swagger
 * /api/ban/unban/{id}:
 *   post:
 *     summary: Unban user
 *     parameters:
 *       - name: id
 *         in: path
 *         required: true
 *         description: User Id to unban
 *         schema:
 *           type: integer
 *       - name: Authorization
 *         in: header
 *         required: true
 *         description: AuthToken
 *         schema:
 *           type: string
 *     responses:
 *       200:
 *         description: UserUnbanned
 *       401:
 *         description: Token is required
 *       500:
 *         description: DB error
 */


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
