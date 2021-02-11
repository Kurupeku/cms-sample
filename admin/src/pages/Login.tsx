import React, { useState } from "react";
import { Redirect } from "react-router";
import { useTranslation } from "react-i18next";
import Api from "../utilities/Api";
import Avatar from "@material-ui/core/Avatar";
import Button from "@material-ui/core/Button";
import Paper from "@material-ui/core/Paper";
import TextField from "@material-ui/core/TextField";
import LockOutlinedIcon from "@material-ui/icons/LockOutlined";
import Typography from "@material-ui/core/Typography";
import { makeStyles } from "@material-ui/core/styles";
import Container from "@material-ui/core/Container";
import { Session } from "../types/store";

interface Props {
  currentUserId: string | null;
  handleCurrentUserId: (id: string) => void;
}

const useStyles = makeStyles((theme) => ({
  container: {
    paddingTop: theme.spacing(8),
  },
  paper: {
    display: "flex",
    flexDirection: "column",
    alignItems: "center",
    padding: theme.spacing(3),
  },
  avatar: {
    margin: theme.spacing(1),
    backgroundColor: theme.palette.secondary.main,
  },
  form: {
    width: "100%", // Fix IE 11 issue.
    marginTop: theme.spacing(1),
  },
  submit: {
    margin: theme.spacing(3, 0, 2),
  },
}));

const loginPath = "/auth/sign_in";

export default function Login(props: Props) {
  const { currentUserId, handleCurrentUserId } = props;
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const { t } = useTranslation();
  const classes = useStyles();

  const handleSubmit = () => {
    Api.post<Session>(
      loginPath,
      {
        email: email,
        password: password,
      },
      {
        success: (response) => {
          Api.setSessionInfo(response);
          handleCurrentUserId(response.data.data.id);
          
        },
      }
    ).catch((error) => console.error(error));
  };

  return currentUserId ? (
    <Redirect to="/admin" />
  ) : (
    <Container component="main" maxWidth="xs" className={classes.container}>
      <Paper className={classes.paper}>
        <Avatar className={classes.avatar}>
          <LockOutlinedIcon />
        </Avatar>
        <Typography component="h1" variant="h5">
          {t("pages.login.title")}
        </Typography>
        <form className={classes.form} noValidate>
          <TextField
            variant="outlined"
            margin="normal"
            required
            fullWidth
            id="email"
            label={t("pages.login.email")}
            name="email"
            autoComplete="email"
            value={email}
            onChange={(e) => setEmail(e.currentTarget.value)}
            autoFocus
          />
          <TextField
            variant="outlined"
            margin="normal"
            required
            fullWidth
            name="password"
            label={t("pages.login.password")}
            type="password"
            id="password"
            autoComplete="current-password"
            value={password}
            onChange={(e) => setPassword(e.currentTarget.value)}
          />
          <Button
            type="submit"
            fullWidth
            variant="contained"
            color="primary"
            className={classes.submit}
            onClick={handleSubmit}
          >
            {t("pages.login.submit")}
          </Button>
        </form>
      </Paper>
    </Container>
  );
}
