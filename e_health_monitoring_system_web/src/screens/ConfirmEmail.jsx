import React, { useEffect, useState } from "react";
import { useSearchParams } from "react-router-dom";
import EmailVerification from "../components/EmailVerification"; // importa corect

const ConfirmEmail = () => {
  const [searchParams] = useSearchParams();
  const [status, setStatus] = useState("loading"); // "loading" | "success" | "error"

  const userId = searchParams.get("userId");
  const code = searchParams.get("code");

  console.log("ConfirmEmail Params:", { userId, code });

  useEffect(() => {
    const confirmEmail = async () => {
      try {
        const response = await fetch(`http://localhost:5200/api/Register/ConfirmEmail?userId=${userId}&code=${code}`, {
          method: "GET",
          headers: {
            "Content-Type": "application/json"
          },
        });
        if (response.ok) {
          setStatus("success");
        } else {
          setStatus("error");
        }
      } catch (error) {
        setStatus("error");
      }
    };

    if (userId && code) {
      confirmEmail();
    } else {
      setStatus("error");
    }
  }, [userId, code]);

  return (
    <EmailVerification status={status} />
  );
};

export default ConfirmEmail;