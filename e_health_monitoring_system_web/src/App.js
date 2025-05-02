import React from "react";
import ConfirmEmail from "./screens/ConfirmEmail";
import Sidebar from "./components/Sidebar";
import EmailVerification from "./components/EmailVerification";
import { BrowserRouter as Router, Routes, Route } from "react-router-dom";
import './App.css';

function App() {
  return (
    <Router>
      <div style={{ display: "flex" }}>
        <Sidebar />
        <Routes>
          <Route path="/" element={<EmailVerification />} />
          <Route path="/confirm-email" element={<ConfirmEmail />} /> {/* new route */}
        </Routes>
      </div>
    </Router>
  );
}

export default App;
