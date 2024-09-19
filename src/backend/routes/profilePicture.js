const express = require('express');
const multer = require('multer');
const { Storage } = require('@google-cloud/storage');
const path = require('path');
const db = require('../config/db');

const router = express.Router();
const upload = multer({ storage: multer.memoryStorage() });

const googleConfig = {
  type: "service_account",
  project_id: process.env.GOOGLE_PROJECT_ID,
  private_key_id: process.env.GOOGLE_PRIVATE_KEY_ID,
  private_key: process.env.GOOGLE_PRIVATE_KEY.replace(/\\n/g, '\n'),
  client_email: process.env.GOOGLE_CLIENT_EMAIL,
  client_id: process.env.GOOGLE_CLIENT_ID,
  auth_uri: process.env.GOOGLE_AUTH_URI,
  token_uri: process.env.GOOGLE_TOKEN_URI,
  auth_provider_x509_cert_url: process.env.GOOGLE_AUTH_PROVIDER_X509_CERT_URL,
  client_x509_cert_url: process.env.GOOGLE_CLIENT_X509_CERT_URL,
  universe_domain: "googleapis.com",
};
const storage = new Storage({ credentials: googleConfig });

const bucket = storage.bucket('img_inzynierka');

router.post('/', upload.single('file'), async (req, res) => {
  if (!req.file) {
    return res.status(400).send('Brak pliku');
  }

  const userId = req.body.userId;

  const getUserQuery = 'SELECT profilePicture FROM users WHERE id = ?';
  db.query(getUserQuery, [userId], async (err, results) => {
    if (err) {
      console.error('Błąd podczas pobierania użytkownika:', err);
      return res.status(500).send('Błąd serwera');
    }

    const currentProfilePictureUrl = results[0]?.profilePicture;

    if (currentProfilePictureUrl) {
      const currentFileName = currentProfilePictureUrl.split('/').pop();

      const oldFile = bucket.file(currentFileName);
      try {
        await oldFile.delete();
        console.log('Stare zdjęcie profilowe zostało usunięte.');
      } catch (error) {
        console.error('Błąd podczas usuwania starego zdjęcia profilowego:', error);
        return res.status(500).send('Błąd podczas usuwania starego pliku');
      }
    }

    const blob = bucket.file(`${userId}-${Date.now()}-${req.file.originalname}`);
    const blobStream = blob.createWriteStream({
      resumable: false,
    });

    blobStream.on('finish', async () => {
      try {
        await blob.makePublic();
        const publicUrl = `https://storage.googleapis.com/${bucket.name}/${blob.name}`;

        const updateQuery = `UPDATE users SET profilePicture = ? WHERE id = ?`;
        db.query(updateQuery, [publicUrl, userId]);

        res.status(200).send({ url: publicUrl });
      } catch (error) {
        console.error('Nie udało się ustawić pliku jako publicznego:', error);
        res.status(500).send('Błąd podczas ustawiania publicznego dostępu do pliku');
      }
    });

    blobStream.end(req.file.buffer);
  });
});

router.delete('/', async (req, res) => {
  const userId = req.body.userId;

  const getUserQuery = 'SELECT profilePicture FROM users WHERE id = ?';
  db.query(getUserQuery, [userId], async (err, results) => {
    if (err) {
      console.error('Błąd podczas pobierania użytkownika:', err);
      return res.status(500).send('Błąd serwera');
    }

    const currentProfilePictureUrl = results[0]?.profilePicture;

    if (currentProfilePictureUrl) {
      const currentFileName = currentProfilePictureUrl.split('/').pop();

      const file = bucket.file(currentFileName);
      try {
        await file.delete();
        console.log('Zdjęcie profilowe zostało usunięte.');

        const updateQuery = `UPDATE users SET profilePicture = NULL WHERE id = ?`;
        db.query(updateQuery, [userId]);

        res.status(200).send('Zdjęcie profilowe zostało usunięte.');
      } catch (error) {
        console.error('Błąd podczas usuwania zdjęcia profilowego:', error);
        res.status(500).send('Błąd podczas usuwania pliku');
      }
    } else {
      res.status(400).send('Brak zdjęcia profilowego do usunięcia.');
    }
  });
});



module.exports = router;