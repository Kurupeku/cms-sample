import React from "react";
import ReactDOM from "react-dom";
import "./index.scss";
import "./i18n";
import App from "./App";
import reportWebVitals from "./reportWebVitals";
import CssBaseline from "@material-ui/core/CssBaseline";

ReactDOM.render(
  <React.StrictMode>
    <CssBaseline />
    <App />
  </React.StrictMode>,
  document.getElementById("root")
);

reportWebVitals();
