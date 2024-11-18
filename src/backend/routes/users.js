const express = require('express');
const { getDb } = require('../config/db');
const jwt = require('jsonwebtoken');
const router = express.Router();

//pobieranie danych zalogowanego usera / weryfikacja dostępu
router.get('/:id', async (req, res) => {
  const id = req.params.id;
  const token = req.headers['authorization']?.split(' ')[1];
  const sessionKey = req.headers['sessionkey'];

  if (!id) {
    return res.status(400).json({ error: 'Id is required' });
  }
  if (!token) {
    return res.status(401).json({ error: 'Token is required' });
  }

  try {
    const decoded = jwt.verify(token, process.env.SECRET_KEY);
    const db = await getDb();
    const sqlUser = 'SELECT id, username, is_banned, profilePicture, session_key FROM users WHERE id = ?';
    const [results] = await db.execute(sqlUser, [id]);

    if (results.length > 0) {
      const user = results[0];

      if (user.session_key === sessionKey) {
        return res.json(results);
      } else {
        return res.status(403).json({ error: 'No access' });
      }
    } else {
      return res.status(404).json({ error: 'User not found' });
    }
  } catch (err) {
    console.error('Error during the request:', err);
    if (err.name === 'JsonWebTokenError') {
      return res.status(403).json({ error: 'Invalid token' });
    }
    return res.status(500).json({ error: 'Server error' });
  }
});

//pobieranie danych o wszystkich userach dla admina
router.get('/:id/admin', async (req, res) => {
  const id = req.params.id;
  const token = req.headers['authorization']?.split(' ')[1];
  const sessionKey = req.headers['sessionkey'];

  if (!id) {
    return res.status(400).json({ error: 'Id is required' });
  }
  if (!token) {
    return res.status(401).json({ error: 'Token is required' });
  }

  try {
    const decoded = jwt.verify(token, process.env.SECRET_KEY);

    const db = await getDb();

    const sqlUser = 'SELECT id, session_key FROM users WHERE id = ?';
    const [userResults] = await db.execute(sqlUser, [id]);

    if (userResults.length > 0) {
      const user = userResults[0];

      if (user.session_key === sessionKey) {
        const sqlAllUsers = 'SELECT id, username, email, age, gender, is_banned, email_notifications, push_notifications FROM users';
        const [allUsers] = await db.execute(sqlAllUsers);

        return res.json(allUsers);
      } else {
        return res.status(403).json({ error: 'No access' });
      }
    } else {
      return res.status(404).json({ error: 'User not found' });
    }
  } catch (err) {
    console.error('Error during the request:', err);
    if (err.name === 'JsonWebTokenError') {
      return res.status(403).json({ error: 'Invalid token' });
    }
    return res.status(500).json({ error: 'Server error' });
  }
});


//pobieranie dokładniejszych danych profilu uzytkownika
router.get('/:id/profile', async (req, res) => {
  const id = req.params.id;
  const token = req.headers['authorization']?.split(' ')[1];
  const sessionKey = req.headers['sessionkey'];

  if (!id) {
    return res.status(400).json({ error: 'Id is required' });
  }
  if (!token) {
    return res.status(401).json({ error: 'Token is required' });
  }

  try {
    const decoded = jwt.verify(token, process.env.SECRET_KEY);

    const db = await getDb();

    const sqlUser = 'SELECT id, age, gender, email, username, email_notifications, push_notifications, is_banned, profilePicture, session_key FROM users WHERE id = ?';
    const [results] = await db.execute(sqlUser, [id]);

    if (results.length > 0) {
      const user = results[0];

      if (user.session_key === sessionKey) {
        return res.json(user);
      } else {
        return res.status(403).json({ error: 'No access' });
      }
    } else {
      return res.status(404).json({ error: 'User not found' });
    }
  } catch (err) {
    console.error('Error during the request:', err);
    if (err.name === 'JsonWebTokenError') {
      return res.status(403).json({ error: 'Invalid token' });
    }
    return res.status(500).json({ error: 'Server error' });
  }
});


//pobieranie globanych statystyk userów do rankingu
router.get('/:id/routes_with_usernames', async (req, res) => {
  const token = req.headers['authorization']?.split(' ')[1];
  if (!token) {
    return res.status(401).json({ error: 'Token is required' });
  }

  const userId = req.params.id;

  if (!userId) {
    return res.status(400).json({ error: 'Id is required' });
  }

  try {
    const decoded = jwt.verify(token, process.env.SECRET_KEY);

    const db = await getDb();

    const sql = `
      SELECT ur.user_id, ur.CO2, ur.kcal, ur.money, u.username, u.profilePicture
      FROM user_routes ur
      JOIN users u ON ur.user_id = u.id
      WHERE ur.user_id = ?;
    `;

    const [results] = await db.execute(sql, [userId]);

    if (results.length > 0) {
      res.json(results);
    } else {
      res.status(404).json({ error: 'No routes found for this user' });
    }
  } catch (err) {
    console.error('Error during the request:', err);
    if (err.name === 'JsonWebTokenError') {
      return res.status(403).json({ error: 'Invalid token' });
    }
    return res.status(500).json({ error: 'Server error' });
  }
});


//pobieranie tras usera
router.get('/:id/routes', async (req, res) => {
  const userId = req.params.id;
  const token = req.headers['authorization']?.split(' ')[1];

  if (!token) {
    return res.status(401).json({ error: 'Token is required' });
  }
  if (!userId) {
    return res.status(400).json({ error: 'Id is required' });
  }
  try {
    const decoded = jwt.verify(token, process.env.SECRET_KEY);
    const db = await getDb();
    const sql = 'SELECT * FROM user_routes WHERE user_id = ?';

    const [results] = await db.execute(sql, [userId]);
    if (results.length > 0) {
      res.json(results); 
    } else {
      res.status(404).json({ error: 'No routes found for this user' });
    }
  } catch (err) {
    console.error('Error during the request:', err);
    if (err.name === 'JsonWebTokenError') {
      return res.status(403).json({ error: 'Invalid token' });
    }
    return res.status(500).json({ error: 'Server error' });
  }
});


//zmienianie preferencji do otrzymywanych powiadomien w profilu
router.put('/:id/notifications', async (req, res) => {
  const token = req.headers['authorization']?.split(' ')[1];
  
  if (!token) {
    return res.status(401).json({ error: 'Token is required' });
  }
  const { email_notifications, push_notifications } = req.body;
  const userId = req.params.id;

  try {
    const updateQuery = 'UPDATE users SET email_notifications = ?, push_notifications = ? WHERE id = ?';
    const db = await getDb();
    
    const [result] = await db.execute(updateQuery, [email_notifications, push_notifications, userId]);

    if (result.affectedRows > 0) {
      return res.status(200).json({ message: 'Ustawienia powiadomień zostały zaktualizowane' });
    } else {
      return res.status(404).json({ error: 'Użytkownik nie znaleziony' });
    }
  } catch (error) {
    console.error('Błąd podczas aktualizacji ustawień:', error);
    res.status(500).json({ message: 'Wystąpił błąd podczas aktualizacji ustawień.' });
  }
});


module.exports = router;
