import React, { useEffect, useState } from "react";
import { BrowserRouter as Router, Switch, Route } from "react-router-dom";
import {
  createMuiTheme,
  ThemeProvider,
  responsiveFontSizes,
} from "@material-ui/core/styles";
import Backdrop from "@material-ui/core/Backdrop";
import CircularProgress from "@material-ui/core/CircularProgress";
import teal from "@material-ui/core/colors/teal";
import pink from "@material-ui/core/colors/pink";
import Auth from "./components/Auth";
import SideMenu from "./components/SideMenu";
import Users from "./pages/Users";
import Login from "./pages/Login";
import Api from "./utilities/Api";
import { User, Profile, Setting } from "./types/store";
import { makeStyles, createStyles, Theme } from "@material-ui/core/styles";

const settingPath = "/setting";

let theme = createMuiTheme({
  palette: {
    primary: teal,
    secondary: pink,
  },
});

theme = responsiveFontSizes(theme);

const useStyles = makeStyles((theme: Theme) =>
  createStyles({
    appContainer: {
      height: "100vh",
      backgroundColor: theme.palette.grey[300],
    },
    backdrop: {
      zIndex: theme.zIndex.drawer + 1,
      color: "#fff",
    },
  })
);

function App() {
  const [currentUserId, setCurrentUserId] = useState(
    localStorage.getItem("user_id")
  );
  const [currentUser, setCurrentUser] = useState<User | null>();
  const [currentProfile, setCurrentProfile] = useState<Profile | null>();
  const [loading, setLoading] = useState(false);
  const [siteTitle, setSiteTitle] = useState("");
  const classes = useStyles();

  const handleCurrentUserId = (id: string | null) => {
    if (id) {
      localStorage.setItem("user_id", id);
    } else {
      localStorage.removeItem("user_id");
    }
    setCurrentUserId(id);
  };

  useEffect(() => {
    if (currentUserId) {
      Api.get<User>(
        `/users/${currentUserId}`,
        { include: ["profile"] },
        {
          success: (response) => {
            const { data: user, included } = response.data;
            setCurrentUser(user);
            const profile =
              included &&
              (included.find(
                (datum) =>
                  String(datum.attributes["user_id"]) === String(user.id)
              ) as Profile | null);
            if (profile) setCurrentProfile(profile);
          },
        }
      );
    } else {
      setCurrentUser(null);
      setCurrentProfile(null);
    }
  }, [currentUserId]);

  useEffect(() => {
    if (currentUserId)
      Api.get<Setting>(
        settingPath,
        {},
        {
          success: (response) => {
            setSiteTitle(response.data.data.attributes.site_title);
          },
        }
      );
  }, []);

  return (
    <ThemeProvider theme={theme}>
      <Router>
        <div className={classes.appContainer}>
          <Switch>
            <Route path="/admin/login">
              <Login
                currentUserId={currentUserId}
                handleCurrentUserId={handleCurrentUserId}
              />
            </Route>
            <Auth currentUserId={currentUserId}>
              <SideMenu siteTitle={siteTitle}>
                <Route path="/">
                  <Users />
                  <button onClick={() => localStorage.clear()}>Logout</button>
                </Route>
              </SideMenu>
            </Auth>
          </Switch>
          <Backdrop className={classes.backdrop} open={loading}>
            <CircularProgress color="inherit" />
          </Backdrop>
        </div>
      </Router>
    </ThemeProvider>
  );
}

export default App;
