import axios, { AxiosAdapter, AxiosError, AxiosResponse } from "axios";
import qs from "qs";
import { Record } from "../types/store";

interface SesionData {
  "access-token": string | null;
  client: string | null;
  uid: string | null;
}

interface RequestParams {
  [key: string]: any;
}

interface RequestData {
  [key: string]: any;
}

interface Pagenation {
  current: string;
  previous: string;
  next: string;
  per: string;
  pages: string;
  count: string;
}

interface ResponseData<T> {
  data: T;
  included?: Record[];
  pagination?: Pagenation;
}

interface Callback<T = any> {
  success?: (response: AxiosResponse<ResponseData<T>>) => void;
  error?: (err: AxiosError) => void;
}

const serializeParams = (params: RequestParams = {}) => qs.stringify(params);

const authKeys = ["access-token", "client", "uid"];

const getAuthHeaders = (): SesionData => {
  return {
    "access-token": localStorage.getItem("access-token"),
    client: localStorage.getItem("client"),
    uid: localStorage.getItem("uid"),
  };
};

const setSessionInfo = (response: AxiosResponse) => {
  if (response.status === 200) {
    const headers = response.headers;
    authKeys.forEach((key) => {
      const value = headers[key];
      console.log(key, value);
      if (value) localStorage.setItem(key, value);
    });
  }
};

const clearSessionInfo = () => {
  authKeys.forEach((key) => localStorage.removeItem(key));
};

const generateConfig = () => {
  return {
    baseURL: process.env.REACT_APP_API_BASE_URL,
    timeout: 3000,
    headers: {
      "Content-Type": "application/json",
      ...getAuthHeaders(),
    },
  };
};

const errorCallback = (
  err: AxiosError,
  errorFunc?: (err: AxiosError) => void
) => {
  err.response?.status === 401 && clearSessionInfo();
  errorFunc && errorFunc(err);
};

const get = <T>(
  path: string,
  params?: RequestData,
  callback?: Callback<T>
): Promise<void | AxiosResponse<ResponseData<T>>> => {
  const url = path + (params ? "?" + serializeParams(params) : "");
  return axios({
    ...generateConfig(),
    url: url,
  })
    .then((res) => {
      if (callback && callback.success) callback.success(res);
    })
    .catch((err: AxiosError) => errorCallback(err, callback && callback.error));
};

const post = <T>(
  path: string,
  data?: RequestData,
  callback?: Callback<T>
): Promise<void | AxiosResponse<ResponseData<T>>> => {
  return axios({
    ...generateConfig(),
    url: path,
    method: "POST",
    data: data,
  })
    .then((res) => {
      if (callback && callback.success) callback.success(res);
    })
    .catch((err: AxiosError) => errorCallback(err, callback && callback.error));
};

const put = (path: string, data?: RequestData, callback?: Callback) => {
  return axios({
    ...generateConfig(),
    url: path,
    method: "PUT",
    data: data,
  })
    .then((res) => {
      if (callback && callback.success) callback.success(res);
    })
    .catch((err: AxiosError) => errorCallback(err, callback && callback.error));
};

const patch = (path: string, data?: RequestData, callback?: Callback) => {
  return axios({
    ...generateConfig(),
    url: path,
    method: "PATCH",
    data: data,
  })
    .then((res) => {
      if (callback && callback.success) callback.success(res);
    })
    .catch((err: AxiosError) => errorCallback(err, callback && callback.error));
};

const destroy = (path: string, callback?: Callback) => {
  return axios({
    ...generateConfig(),
    url: path,
    method: "DELETE",
  })
    .then((res) => {
      if (callback && callback.success) callback.success(res);
    })
    .catch((err: AxiosError) => errorCallback(err, callback && callback.error));
};

const downloadFile = (url: string, fileName: string): void => {
  const link = document.createElement("a");
  link.download = `${fileName}.csv`;
  link.href = url;
  document.body.appendChild(link);
  link.click();
  document.body.removeChild(link);
};

const download = (path: string, fileName?: string, callback?: Callback) => {
  const name = fileName || Date.now().toString();
  return axios({
    url: path,
    baseURL: process.env.REACT_APP_API_BASE_URL,
    timeout: 3000,
    headers: {
      "Content-Type": "application/json",
      ...getAuthHeaders(),
    },
    responseType: "blob",
  })
    .then((res) => {
      const bom = new Uint8Array([0xef, 0xbb, 0xbf]);
      const url = (window.URL || window.webkitURL).createObjectURL(
        new Blob([bom, res.data], { type: "text/csv" })
      );
      downloadFile(url, name);
      if (callback && callback.success) callback.success(res);
    })
    .catch((err: AxiosError) => errorCallback(err, callback && callback.error));
};

export default {
  get,
  post,
  put,
  patch,
  destroy,
  download,
  setSessionInfo,
  clearSessionInfo,
};
