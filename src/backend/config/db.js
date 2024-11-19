const mysql = require('mysql2/promise');
require('dotenv').config();

let db;

async function connectToDatabase() {
  try {
    await new Promise(resolve => setTimeout(resolve, 6000));

    db = await mysql.createConnection({
      host: 'db',
      user: 'root',
      password: 'password',
      database: 'inzynierka'
    });

    console.log('Połączono z bazą danych MySQL');
  } catch (err) {
    console.error('Błąd połączenia z bazą danych:', err);
    throw err;
  }
}

connectToDatabase();

module.exports = {
  getDb: () => db,
};
