const express = require('express');
const cors = require('cors');
const { getDb } = require('./config/db');
const authRoutes = require('./routes/auth');
const userRoutes = require('./routes/users'); 
const profilePictureRoutes = require('./routes/profilePicture');
const rankingRouter = require('./routes/ranking');
const notificationRouter = require('./routes/notifications');
const eventRouter = require('./routes/event');
const banRouter = require('./routes/ban');
const adminRouter = require('./routes/admin');
const swaggerUi = require('swagger-ui-express');
const swaggerSpecs = require('./swaggerConfig');
const path = require('path');
require('dotenv').config();

const app = express();
const port = 5000;

app.use(cors());
app.use(express.json());
app.use('/api-docs', swaggerUi.serve, swaggerUi.setup(swaggerSpecs));


app.use('/uploads', express.static(path.join(__dirname, 'uploads')));

app.use('/api/auth', authRoutes.router);
app.use('/api/users', userRoutes);
app.use('/api/profilePicture', profilePictureRoutes);
app.use('/api/ranking', rankingRouter);
app.use('/api/notifications', notificationRouter);
app.use('/api/event', eventRouter);
app.use('/api/ban', banRouter);
app.use('/api/admin', adminRouter);

app.listen(port, () => {
  console.log(`Serwer działa na http://localhost:${port}`);
  console.log(`Swagger dostępny na http://localhost:${port}/api-docs`);
});
