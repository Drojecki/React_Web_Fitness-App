const express = require('express');
const { getDb } = require('../config/db');
const router = express.Router();

//pobiera dane o znajomych usera
router.get('/:user_id', async (req, res) => {
    const token = req.headers['authorization']?.split(' ')[1];
    const userId = req.params.user_id;
  
    if (!token) {
      return res.status(401).json({ error: 'Token is required' });
    }
  
    try {
      const db = await getDb();
      const sqlFriends = `
        SELECT f.user_id, f.friend_id, f.status, u1.username AS user_username, u2.username AS friend_username 
        FROM friends f
        JOIN users u1 ON f.user_id = u1.id 
        JOIN users u2 ON f.friend_id = u2.id 
        WHERE f.user_id = ? OR f.friend_id = ?`;
  
      const [friends] = await db.execute(sqlFriends, [userId, userId]);
      res.json(friends);
    } catch (err) {
      console.error('Query error', err);
      return res.status(500).json({ error: 'DB error' });
    }
  });
  

//akceptowanie zaproszenia
router.post('/accept/:user_id', async (req, res) => {
    const token = req.headers['authorization']?.split(' ')[1];
    const { friendId } = req.body;
    const userId = req.params.user_id;
  
    if (!token) {
      return res.status(401).json({ error: 'Token is required' });
    }
  
    try {
      const db = await getDb();
      const updateQuery = 'UPDATE friends SET status = "accepted" WHERE user_id = ? AND friend_id = ?';
      const [result] = await db.execute(updateQuery, [friendId, userId]);
  
      if (result.affectedRows > 0) {
        return res.status(200).json({ message: 'Friend accepted' });
      } else {
        return res.status(404).json({ error: 'Friendship not found or already accepted' });
      }
    } catch (err) {
      console.error('Query error', err);
      return res.status(500).json({ error: 'Server error' });
    }
  });
  

//wyszukiwarka userów 
router.get('/allusers/:userId', async (req, res) => {
    const { userId } = req.params;
    const token = req.headers['authorization']?.split(' ')[1];
  
    if (!token) {
      return res.status(401).json({ error: 'Token is required' });
    }
  
    try {
      const db = await getDb();
      const sqlGetFriends = `
        SELECT friend_id FROM friends 
        WHERE user_id = ? 
        UNION
        SELECT user_id FROM friends 
        WHERE friend_id = ?
      `;
      const [friends] = await db.execute(sqlGetFriends, [userId, userId]);
  
      const friendIds = friends.map(friend => friend.friend_id || friend.user_id);
  
      // Zapytanie o wszystkich użytkowników
      const sqlGetAllUsers = 'SELECT id, username FROM users';
      const [users] = await db.execute(sqlGetAllUsers);
  
      // Filtracja użytkowników: usunięcie znajomych oraz aktualnego użytkownika
      const filteredUsers = users.filter(user => !friendIds.includes(user.id) && user.id !== parseInt(userId));
  
      // Zwrócenie wyników
      res.json(filteredUsers);
    } catch (err) {
      console.error('query error', err);
      return res.status(500).json({ error: 'DB error' });
    }
  });
  

//wysyłanie zaproszenia
router.post('/invite/:user_id', async (req, res) => {
    const userId = req.params.user_id;
    const { friend_id, status } = req.body;
    const token = req.headers['authorization']?.split(' ')[1];
  
    if (!token) {
      return res.status(401).json({ error: 'Token is required' });
    }
  
    try {
      const db = await getDb();
      const sqlInvite = 'INSERT INTO friends (user_id, friend_id, status) VALUES (?, ?, ?)';
      const [result] = await db.execute(sqlInvite, [userId, friend_id, status]);
      res.json({ message: 'success', result });
    } catch (err) {
      console.error('error', err);
      return res.status(500).json({ error: 'DB error' });
    }
  });
  

//usuwanie zaproszenia / znajomego  / odrzucenie zaproszenia
router.post('/remove/:user_id', async (req, res) => {
    const token = req.headers['authorization']?.split(' ')[1];
    const userId = req.params.user_id;
    const { friendId } = req.body;
  
    if (!token) {
      return res.status(401).json({ error: 'Token is required' });
    }
  
    try {
      const db = await getDb();
      const deleteQuery = 'DELETE FROM friends WHERE (user_id = ? AND friend_id = ?) OR (user_id = ? AND friend_id = ?)';
      const [result] = await db.execute(deleteQuery, [userId, friendId, friendId, userId]);
  
      if (result.affectedRows === 0) {
        return res.status(404).json({ message: 'Not found' });
      }
  
      res.json({ message: 'Friend removed' });
    } catch (err) {
      console.error('Error:', err);
      return res.status(500).json({ error: 'DB error' });
    }
  });
  

//wyświetlanie profilu znajomego
router.get('/get/:userId', async (req, res) => {
    const userId = req.params.userId;
    const token = req.headers['authorization']?.split(' ')[1];
    
    if (!token) {
        return res.status(401).json({ error: 'Token is required' });
    }

    try {
        const db = await getDb();
        const query = `
            SELECT u.id, u.username, u.profilePicture, u.email, p.id AS post_id, p.content, p.post_date
            FROM users u
            LEFT JOIN posts p ON u.id = p.user_id
            WHERE u.id = ?`;
        const [results] = await db.execute(query, [userId]);

        if (results.length === 0) {
            return res.status(404).json({ message: 'User not found' });
        }
        const userData = {
            id: results[0].id,
            username: results[0].username,
            profilePicture: results[0].profilePicture,
            email: results[0].email,
            posts: results
                .map(result => ({
                    id: result.post_id,
                    content: result.content,
                    created_at: result.post_date,
                }))
                .filter(post => post.id !== null)
        };
        res.json(userData);
    } catch (error) {
        console.error("Error:", error);
        res.status(500).json({ error: 'Server error' });
    }
});



module.exports = router;
