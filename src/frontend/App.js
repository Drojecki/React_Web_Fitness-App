import React from 'react';
import Login from './Login';
import { BrowserRouter as Router, Route, Routes } from 'react-router-dom';
import Register from './Register';
import UserAcc from './UserAcc';
import '../css/index.css';
import Trophies from './Trophies';
import Profile from './Profile';
import Settings from './Settings';
import Rankings from './Rankings';
import Statistics from './Statistics';
import AdminPanel from './AdminPanel';
import Banned from './Banned';
import Modal from 'react-modal';

Modal.setAppElement('#root');

function App() {
  return (
    <Router>
        <Routes>
          <Route path="/" element={<Login />} />
          <Route path="/register" element={<Register />} />
          <Route path="/UserAcc" element={<UserAcc />} />
          <Route path="/Trophies" element={<Trophies />}/>
          <Route path="/Profile"  element={<Profile />} />
          <Route path="/Settings"  element={<Settings />} />
          <Route path="/Rankings"  element={<Rankings />} />
          <Route path="/Statistics"  element={<Statistics />} />
          <Route path="/AdminPanel"  element={<AdminPanel />} />
          <Route path="/Banned"  element={<Banned />}  />
        </Routes>
    </Router>
  );
}

export default App;