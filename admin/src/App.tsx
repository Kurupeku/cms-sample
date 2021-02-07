import React from "react";
import { BrowserRouter as Router, Switch, Route, Link } from "react-router-dom";
import Auth from "./components/Auth";
import Users from "./pages/Users";
import Login from "./pages/Login";

function App() {
  return (
    <Router>
      <div className="app-root">
        <nav>
          <ul>
            <li>
              <Link to="/">Home</Link>
            </li>
            <li>
              <Link to="/about">About</Link>
            </li>
            <li>
              <Link to="/users">Users</Link>
            </li>
          </ul>
        </nav>

        <Switch>
          <Route path="/login">
            <Login />
          </Route>
          <Auth>
            <Route path="/">
              <Users />
              <button onClick={() => localStorage.clear()}>Logout</button>
            </Route>
          </Auth>
        </Switch>
      </div>
    </Router>
  );
}

export default App;
