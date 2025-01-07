const express = require('express');
const bcrypt = require('bcryptjs');
const moment = require('moment');
const { getDb } = require('../config/db');
const jwt = require('jsonwebtoken');
require('dotenv').config();
const router = express.Router();
const SECRET_KEY = process.env.SECRET_KEY;
const crypto = require('crypto');

/**
 * @swagger
 * /api/auth/register:
 *   post:
 *     summary: User registration
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               name:
 *                 type: string
 *                 description: The username of the new user
 *               password:
 *                 type: string
 *                 description: The password for the user account
 *               email:
 *                 type: string
 *                 description: The email of the new user
 *               age:
 *                 type: integer
 *                 description: The age of the user
 *               gender:
 *                 type: string
 *                 description: The gender of the user
 *     responses:
 *       200:
 *         description: User registration successful
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message:
 *                   type: string
 *                   example: success
 *       400:
 *         description: Missing field or username/email already exists
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 error:
 *                   type: string
 *                   example: 
 *                     - 'missing field'
 *                     - 'username exists'
 *                     - 'email exists'
 *       500:
 *         description: Database error or server issue
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 error:
 *                   type: string
 *                   example: 
 *                     - 'DB error'
 *                     - 'error'
 */

//obsługa rejestracji
router.post('/register', async (req, res) => {
  const { name, password, email, age, gender } = req.body;

  if (!name || !password || !email || !age || !gender) {
    return res.status(400).json({ error: 'missing field' });
  }

  try {
    const db = await getDb();
    const checkQuery = `SELECT * FROM users WHERE username = ? OR email = ?`;
    const [existingUsers] = await db.execute(checkQuery, [name, email]);

    if (existingUsers.length > 0) {
      const existingUser = existingUsers[0];
      if (existingUser.username === name) {
        return res.status(400).json({ error: 'username exists' });
      }
      if (existingUser.email === email) {
        return res.status(400).json({ error: 'email exists' });
      }
    }

    const hashedPassword = await bcrypt.hash(password, 10);

    const query = `
      INSERT INTO users (username, password_hash, email, age, gender, created_at)
      VALUES (?, ?, ?, ?, ?, ?)
    `;
    const values = [
      name,
      hashedPassword,
      email,
      age,
      gender,
      moment().format('YYYY-MM-DD HH:mm:ss'),
    ];

    await db.execute(query, values);

    res.status(201).json({ message: 'User registered successfully' });
  } catch (error) {
    console.error('Error occurred:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

/**
 * @swagger
 * /api/auth/login:
 *   post:
 *     summary: User login
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               username:
 *                 type: string
 *                 description: The username of the user
 *               password:
 *                 type: string
 *                 description: The password for the user account
 *     responses:
 *       200:
 *         description: User login successful, returns a JWT token
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 token:
 *                   type: string
 *                   description: The JWT token for authenticated requests
 *       400:
 *         description: Invalid username/password or user not found
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 error:
 *                   type: string
 *                   example: 'error'
 *       500:
 *         description: Server or database error
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 error:
 *                   type: string
 *                   example: 'error'
 */

//obsługa loginu
router.post('/login', async (req, res) => {
  const { username, password } = req.body;

  if (!username || !password) {
    return res.status(400).json('Username and password are required');
  }

  try {
    const db = await getDb();
    const [results] = await db.execute('SELECT * FROM users WHERE username = ?', [username]);

    if (results.length === 0) {
      return res.status(400).json('Invalid credentials');
    }

    const user = results[0];
    const isMatch = await bcrypt.compare(password, user.password_hash);

    if (isMatch) {
      const sessionKey = crypto.randomBytes(64).toString('hex');
      
      await db.execute('UPDATE users SET session_key = ? WHERE id = ?', [sessionKey, user.id]);

      const token = jwt.sign(
        { id: user.id, username: user.username, Admin: user.is_Admin, sessionKey },
        process.env.SECRET_KEY,
        { expiresIn: '12h' }
      );
      res.json({ token });
    } else {
      return res.status(400).json('Invalid credentials');
    }
  } catch (error) {
    console.error('Error during login process:', error);
    res.status(500).json('Server error');
  }
});



module.exports = { router };
