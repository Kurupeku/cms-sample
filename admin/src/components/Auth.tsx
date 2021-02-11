import React from "react";
import { Redirect } from "react-router";

interface Props {
  children: React.ReactNode;
  currentUserId: string | null;
}

export default function Auth({ children, currentUserId }: Props) {
  return currentUserId ? <>{children}</> : <Redirect to="/admin/login" />;
}
