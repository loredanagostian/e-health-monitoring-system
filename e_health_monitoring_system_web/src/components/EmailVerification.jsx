import React, { useState, useEffect } from "react";
import Lottie from "lottie-react";
import spinnerAnimation from "../assets/lotties/loading_spinner.json";
import checkIcon from "../assets/checkIcon.png";
import errorIcon from "../assets/errorIcon.png";

const EmailVerification = () => {
    const [status, setStatus] = useState("loading");
  
    useEffect(() => {
      setTimeout(() => {
        const result = Math.random() > 0.5 ? "success" : "error";
        setStatus(result);
      }, 3000);
    }, []);
  
    return (
      <div style={{ flex: 1, display: "flex", alignItems: "center", justifyContent: "center", flexDirection: "column", width: "100%", maxWidth: "400px", margin: "0 auto" }}>
        {status === "loading" && (
          <>
            <Lottie
                animationData={spinnerAnimation}
                loop={true}
                style={{ width: 100, height: 100, marginBottom: "1rem" }}
            />
            <h2 style={{ marginBottom: "0rem" }}>Verifying email...</h2>
            <p style={{ textAlign: "center", fontSize: "14px", color: "#475467", marginBottom: "7rem" }}>We are verifying user@example.com. The process may take a while.</p>
            <p style={{ textAlign: "center", fontSize: "14px", color: "#475467" }}>Didn't receive the email? <a href="#">Click to re-send</a></p>
          </>
        )}
        {status === "success" && (
          <>
            <img src={checkIcon} alt="CheckIcon" style={{ width: "100px", marginBottom: "1rem" }}/>
            <h2 style={{ marginBottom: "0rem" }}>Email verified</h2>
            <p style={{ textAlign: "center", fontSize: "14px", color: "#475467" }}>Your email has been successfully verified. Return to mobile app to complete your profile.</p>
          </>
        )}
        {status === "error" && (
          <>
            <img src={errorIcon} alt="ErrorIcon" style={{ width: "100px", marginBottom: "1rem" }}/>
            <h2 style={{ marginBottom: "0rem" }}>Email couldn't be verified</h2>
            <p style={{ textAlign: "center", fontSize: "14px", color: "#475467" }}>Please re-try the process. <a href="#">Click to re-send</a></p>
          </>
        )}
      </div>
    );
  };
  
  export default EmailVerification;