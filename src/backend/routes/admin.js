const express = require('express');
const { getDb } = require('../config/db');
const router = express.Router();

//wylicza ile mamy userów łącznie
router.get('/', async (req, res) => {
    const token = req.headers['authorization']?.split(' ')[1];
    
    if (!token) {
      return res.status(401).json({ error: 'Token is required' });
    }
  
    try {
      const db = await getDb();
      const sql = 'SELECT COUNT(*) AS count FROM users';
      const [result] = await db.execute(sql);
      
      if (!result || result.length === 0) {
        return res.status(500).json({ error: 'Could not fetch user count' });
      }
  
      const count = result[0].count;
      res.json({ userCount: count });
    } catch (error) {
      console.error('Database query error:', error);
      res.status(500).json({ error: 'Internal server error' });
    }
  });
  

//wylicza nowych userów w tym tygodniu
router.get('/this-week', async (req, res) => {
    const token = req.headers['authorization']?.split(' ')[1];
    if (!token) {
      return res.status(401).json({ error: 'Token is required' });
    }
  
    try {
      const db = await getDb();
      const sql = `
        SELECT COUNT(*) AS count
        FROM users
        WHERE created_at >= DATE_SUB(CURDATE(), INTERVAL WEEKDAY(CURDATE()) DAY)
          AND created_at < DATE_ADD(DATE_SUB(CURDATE(), INTERVAL WEEKDAY(CURDATE()) DAY), INTERVAL 1 WEEK)
      `;
  
      const [result] = await db.execute(sql);
  
      if (!result || result.length === 0) {
        return res.status(404).json({ error: 'No data found for this week' });
      }
  
      const count = result[0].count;
      res.json({ userCountThisWeek: count });
    } catch (error) {
      console.error('Database query error:', error);
      res.status(500).json({ error: 'Internal server error' });
    }
  });
  

//wylicza aktywne eventy dla admina
router.get('/active-events', async (req, res) => {
  const token = req.headers['authorization']?.split(' ')[1];
  if (!token) {
      return res.status(401).json({ error: 'Token is required' });
  }

  try {
      const db = await getDb();
      const sql = `
          SELECT COUNT(*) AS count
          FROM events
          WHERE startDate <= CURDATE() 
            AND endDate >= CURDATE() 
            AND status = 'active'
      `;
      const [result] = await db.execute(sql);

      if (!result || result.length === 0) {
          return res.status(404).json({ error: 'No active events found' });
      }

      const activeEventsCount = result[0].count;
      res.json({ activeEventsCount });
  } catch (error) {
      console.error('Database query error:', error);
      res.status(500).json({ error: 'Internal server error' });
  }
});

  

module.exports = router;
