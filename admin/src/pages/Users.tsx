import React, { useState } from "react";
import Api from "../utilities/Api";
import { User } from "../types/store";

const usersPath = "/users";

export default function Users() {
  const [data, setData] = useState<User[]>([]);
  const [page, setPage] = useState(1);
  const [per, setPer] = useState(10);

  const getRequest = () => {
    Api.get<User[]>(
      usersPath,
      { page: page, per: per },
      {
        success: (result) => {
          if (result) setData(result.data.data);
        },
      }
    );
  };

  return (
    <>
      <ul>
        {data.map((datum) => (
          <li key={datum.id}>{datum.id}</li>
        ))}
      </ul>
      <button onClick={getRequest}>get</button>
    </>
  );
}
