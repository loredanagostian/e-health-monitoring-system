import React from "react";
import Sidebar from "./components/Sidebar";
import EmailVerification from "./components/EmailVerification";
import './App.css';

function App() {
  return (
    <div style={{ display: 'flex' }}>
      <Sidebar />
      <EmailVerification />
    </div>
  );
}

export default App;
