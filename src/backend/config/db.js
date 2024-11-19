const mysql = require('mysql2/promise');
require('dotenv').config();

let db;

async function connectToDatabase() {
  const maxRetries = 5;
  let retries = 0;

  while (retries < maxRetries) {
    try {
      db = await mysql.createConnection({
        host: 'db',
        user: 'root',
        password: 'password',
        database: 'inzynierka'
      });

      console.log('Połączono z bazą danych MySQL');
      return;
    } catch (err) {
      retries++;
      console.error(`Nieudana próba połączenia ${retries}/${maxRetries}`, err);
      if (retries === maxRetries) throw err;
      await new Promise(resolve => setTimeout(resolve, 3000));
    }
  }
}

connectToDatabase();

module.exports = {
  getDb: () => db,
};
