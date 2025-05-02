import React from "react";
import appLogo from "../assets/appLogo.png";
import sidebarProgress from "../assets/sidebarProgress.png";
import { AiOutlineMail } from "react-icons/ai";

const Sidebar = () => {
    return (
        <div style={{ width: "350px", padding: "2rem", backgroundColor: "#f2f2f2", height: "100vh" }}>
            <img src={appLogo} alt="Logo" style={{ width: "75px", marginBottom: "5rem" }}/>
            <img src={sidebarProgress} alt="Progress" style={{ width: "330px" }}/>
            <div style={{ position: "absolute", bottom: "2rem", fontSize: "14px", alignItems: "center", display:"flex", gap: "20px", color: "#475467" }}>
                <p>© The Forbidden 2025</p>
                <div style={{ alignItems: "center", display:"flex", gap: "5px" }}>
                    <AiOutlineMail style={{ fontSize: "16px" }} />
                    <p>help@the-forbidden.com</p>
                </div>
            </div>
        </div>
    );
};

export default Sidebar;