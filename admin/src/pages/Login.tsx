import { AxiosResponse } from "axios";
import React, { useState } from "react";
import { Redirect } from "react-router";
import Api from "../utilities/Api";

export default function Login() {
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");

  const uid = localStorage.getItem("uid");
  const [logedIn, setLogedIn] = useState(Boolean(uid));

  const handleLogin = () => {
    Api.post(
      "/auth/sign_in",
      {
        email: email,
        password: password,
      },
      {
        success: (response) => {
          Api.setSessionInfo(response);
          setLogedIn(true);
        },
      }
    ).catch((error) => console.error(error));
  };

  return logedIn ? (
    <Redirect to="/" />
  ) : (
    <>
      <div>
        <label htmlFor="email">email</label>
        <input
          name="email"
          type="text"
          value={email}
          onChange={(e) => setEmail(e.currentTarget.value)}
        />
      </div>
      <div>
        <label htmlFor="password">password</label>
        <input
          name="password"
          type="password"
          value={password}
          onChange={(e) => setPassword(e.currentTarget.value)}
        />
      </div>
      <button type="button" onClick={handleLogin}>
        Submit
      </button>
    </>
  );
}
