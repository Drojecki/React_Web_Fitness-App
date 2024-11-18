const express = require('express');
const bcrypt = require('bcrypt');
const moment = require('moment');
const { getDb } = require('../config/db');
const jwt = require('jsonwebtoken');
require('dotenv').config();
const router = express.Router();
const SECRET_KEY = process.env.SECRET_KEY;
const crypto = require('crypto');


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
