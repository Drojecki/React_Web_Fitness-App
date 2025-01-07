const express = require('express');
const { getDb } = require('../config/db');
const router = express.Router();

/**
 * @swagger
 * /api/notifications:
 *   post:
 *     summary: Create a new popup notification
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
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               content:
 *                 type: string
 *                 description: The content of the notification
 *               header:
 *                 type: string
 *                 description: The header of the notification
 *             required:
 *               - content
 *               - header
 *     responses:
 *       200:
 *         description: Notification created successfully
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message:
 *                   type: string
 *                   description: Success message
 *       401:
 *         description: Token is required
 *       500:
 *         description: Database error
 */


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

/**
 * @swagger
 * /api/popup:
 *   get:
 *     summary: Get all popup notifications
 *     parameters:
 *       - name: Authorization
 *         in: header
 *         required: true
 *         description: AuthToken
 *         schema:
 *           type: string
 *     responses:
 *       200:
 *         description: List of popup notifications retrieved successfully
 *         content:
 *           application/json:
 *             schema:
 *               type: array
 *               items:
 *                 type: object
 *                 properties:
 *                   id:
 *                     type: integer
 *                     description: ID of the notification
 *                   content:
 *                     type: string
 *                     description: Content of the notification
 *                   header:
 *                     type: string
 *                     description: Header of the notification
 *       401:
 *         description: Token is required
 *       500:
 *         description: Database error
 */

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

/**
 * @swagger
 * /api/notifications/popup/{id}:
 *   delete:
 *     summary: Delete a notification
 *     parameters:
 *       - name: id
 *         in: path
 *         required: true
 *         description: ID of the popup to delete
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
 *         description: Notification deleted successfully
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message:
 *                   type: string
 *                   description: Success message
 *       401:
 *         description: Token is required
 *       404:
 *         description: Notification not found
 *       500:
 *         description: Database error
 */

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