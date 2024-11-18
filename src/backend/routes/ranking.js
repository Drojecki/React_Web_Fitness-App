const express = require('express');
const { getDb } = require('../config/db');
const router = express.Router();

//pobieranie danych rankingu Co2 Kcal i zaoszczędzonych pieniędzy
router.get('/ranking', async (req, res) => {
  const token = req.headers['authorization']?.split(' ')[1];
  
  if (!token) {
    return res.status(401).json({ error: 'Token is required' });
  }
  try {
    const sqlRanking = `
      SELECT user_id,
        SUM(CO2) AS total_CO2,
        SUM(kcal) AS total_kcal,
        SUM(money) AS total_money
      FROM user_routes
      GROUP BY user_id
      ORDER BY total_CO2 DESC, total_kcal DESC, total_money DESC
    `;
    const db = await getDb();
    
    const [results] = await db.execute(sqlRanking);

    if (results.length === 0) {
      return res.status(404).json({ message: 'No rankings found' });
    }

    res.json(results);

  } catch (error) {
    console.error('Error during ranking query:', error);
    res.status(500).json({ error: 'DB error or invalid token' });
  }
});


module.exports = router;
