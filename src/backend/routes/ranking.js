const express = require('express');
const { getDb } = require('../config/db');
const router = express.Router();

/**
 * @swagger
 * /api/ranking/ranking:
 *   get:
 *     summary: Get CO2, kcal, and money savings ranking
 *     parameters:
 *       - name: Authorization
 *         in: header
 *         required: true
 *         description: AuthToken
 *         schema:
 *           type: string
 *     responses:
 *       200:
 *         description: Ranking data retrieved successfully
 *         content:
 *           application/json:
 *             schema:
 *               type: array
 *               items:
 *                 type: object
 *                 properties:
 *                   user_id:
 *                     type: integer
 *                     description: ID of the user
 *                   total_CO2:
 *                     type: number
 *                     format: float
 *                     description: Total CO2 saved by the user
 *                   total_kcal:
 *                     type: number
 *                     format: float
 *                     description: Total calories burned by the user
 *                   total_money:
 *                     type: number
 *                     format: float
 *                     description: Total money saved by the user
 *       401:
 *         description: Token is required
 *       500:
 *         description: Database error
 */

//pobieranie danych rankingu Co2 Kcal i zaoszczędzonych pieniędzy
router.get('/ranking', async (req, res) => {
  const token = req.headers['authorization']?.split(' ')[1];

  if (!token) {
    return res.status(401).json({ error: 'Token is required' });
  }
  try {
    const sqlRanking = `
      SELECT ur.user_id,
       u.username,
       u.profilePicture,
       SUM(ur.CO2) AS total_CO2,
       SUM(ur.kcal) AS total_kcal,
       SUM(ur.money) AS total_money
FROM user_routes ur
JOIN users u ON ur.user_id = u.id 
GROUP BY ur.user_id, u.username  
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
