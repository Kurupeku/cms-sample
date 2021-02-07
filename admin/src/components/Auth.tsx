import React from "react";
import { Redirect } from "react-router";

interface Props {
  children: React.ReactNode;
}

export default function Auth({ children }: Props) {
  const uid = localStorage.getItem("uid");

  return uid ? <>{children}</> : <Redirect to="/login" />;
}
