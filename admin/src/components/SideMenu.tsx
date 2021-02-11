import React, { ReactNode } from "react";
import { Link } from "react-router-dom";
import { useTranslation } from "react-i18next";
import AppBar from "@material-ui/core/AppBar";
import Drawer from "@material-ui/core/Drawer";
import Hidden from "@material-ui/core/Hidden";
import IconButton from "@material-ui/core/IconButton";
import List from "@material-ui/core/List";
import ListItem from "@material-ui/core/ListItem";
import ListItemIcon from "@material-ui/core/ListItemIcon";
import ListItemText from "@material-ui/core/ListItemText";
import MenuIcon from "@material-ui/icons/Menu";
import Toolbar from "@material-ui/core/Toolbar";
import Typography from "@material-ui/core/Typography";
import Icon from "@material-ui/core/Icon";
import { makeStyles, Theme, createStyles } from "@material-ui/core/styles";

interface MenuItemProps {
  path: string;
  label: string;
  icon: string;
}

interface MenuProps {
  onClick?: () => void;
}

interface Props {
  window?: () => Window;
  children: ReactNode;
  siteTitle: string;
}

const drawerWidth = 240;

const useStyles = makeStyles((theme: Theme) =>
  createStyles({
    root: {
      display: "flex",
    },
    drawer: {
      [theme.breakpoints.up("sm")]: {
        width: drawerWidth,
        flexShrink: 0,
      },
    },
    appBar: {
      [theme.breakpoints.up("sm")]: {
        display: "none",
      },
    },
    menuButton: {
      marginRight: theme.spacing(2),
      [theme.breakpoints.up("sm")]: {
        display: "none",
      },
    },
    toolbar: {
      ...theme.mixins.toolbar,
      [theme.breakpoints.up("sm")]: {
        display: "none",
      },
    },
    drawerPaper: {
      width: drawerWidth,
      backgroundColor: theme.palette.grey[800],
    },
    content: {
      flexGrow: 1,
      padding: theme.spacing(3),
    },
    menuIcon: {
      color: theme.palette.primary.contrastText,
    },
    menuText: {
      color: theme.palette.primary.contrastText,
      textDecoration: "none",
    },
  })
);

function Menu(props: MenuProps) {
  const { onClick } = props;
  const classes = useStyles();
  const { t } = useTranslation();
  const menu: MenuItemProps[] = [
    {
      path: "/admin/articles",
      label: t("components.sideMenu.articles"),
      icon: "article",
    },
    {
      path: "/admin/media",
      label: t("components.sideMenu.media"),
      icon: "perm_media",
    },
    {
      path: "/admin/comments",
      label: t("components.sideMenu.comments"),
      icon: "comment",
    },
    {
      path: "/admin/contacts",
      label: t("components.sideMenu.contacts"),
      icon: "mail",
    },
    {
      path: "/admin/users",
      label: t("components.sideMenu.users"),
      icon: "people_alt",
    },
    {
      path: "/admin/setting",
      label: t("components.sideMenu.setting"),
      icon: "settings",
    },
  ];

  return (
    <div>
      <List>
        {menu.map(({ path, label, icon }, i) => (
          <Link
            to={path}
            className={classes.menuText}
            key={`menu-${i}`}
            onClick={onClick}
          >
            <ListItem button>
              <ListItemIcon>
                <Icon className={classes.menuIcon}>{icon}</Icon>
              </ListItemIcon>
              <ListItemText primary={label} />
            </ListItem>
          </Link>
        ))}
      </List>
    </div>
  );
}

export default function SideMenu(props: Props) {
  const { window, children, siteTitle } = props;
  const [mobileOpen, setMobileOpen] = React.useState(false);
  const { t } = useTranslation();
  const classes = useStyles();

  const handleDrawerToggle = () => {
    setMobileOpen(!mobileOpen);
  };

  const handleDrawerClose = () => {
    setMobileOpen(false);
  };

  const container =
    window !== undefined ? () => window().document.body : undefined;

  return (
    <div className={classes.root}>
      <AppBar position="fixed" className={classes.appBar}>
        <Toolbar>
          <IconButton
            color="inherit"
            aria-label="open drawer"
            edge="start"
            onClick={handleDrawerToggle}
            className={classes.menuButton}
          >
            <MenuIcon />
          </IconButton>
          <Typography variant="h6" noWrap>
            {siteTitle === ""
              ? t("components.sideMenu.defaultTitle")
              : t("components.sideMenu.title", { siteTitle })}
          </Typography>
        </Toolbar>
      </AppBar>
      <nav className={classes.drawer} aria-label="mailbox folders">
        <Hidden smUp implementation="css">
          <Drawer
            container={container}
            variant="temporary"
            anchor="left"
            open={mobileOpen}
            onClose={handleDrawerToggle}
            classes={{
              paper: classes.drawerPaper,
            }}
            ModalProps={{
              keepMounted: true, // Better open performance on mobile.
            }}
          >
            <Menu onClick={handleDrawerClose} />
          </Drawer>
        </Hidden>
        <Hidden xsDown implementation="css">
          <Drawer
            classes={{
              paper: classes.drawerPaper,
            }}
            variant="permanent"
            open
          >
            <Menu />
          </Drawer>
        </Hidden>
      </nav>

      <main className={classes.content}>
        <div className={classes.toolbar} />
        {children}
      </main>
    </div>
  );
}
