import { axiosMultipartPrivate } from "../api/axios";
import { useEffect } from "react";
import useRefreshToken from "./useRefreshToken";
import useAuth from "./useAuth";

const useAxiosMultiPrivate = () => {
    const refresh = useRefreshToken();
    const { auth } = useAuth();

    useEffect(() => {

        const requestIntercept = axiosMultipartPrivate.interceptors.request.use(
            config => {
                if (!config.headers['Authorization']) {
                    config.headers['Authorization'] = auth?.accessToken;
                }
                return config;
            }, (error) => Promise.reject(error)
        );

        const responseIntercept = axiosMultipartPrivate.interceptors.response.use(
            response => response,
            async (error) => {
                const prevRequest = error?.config;
                if (error?.response?.status === 403 && !prevRequest?.sent) {
                    prevRequest.sent = true;
                    const newAccessToken = await refresh();
                    prevRequest.headers['Authorization'] = newAccessToken;
                    return axiosMultipartPrivate(prevRequest);
                }
                return Promise.reject(error);
            }
        );

        return () => {
            axiosMultipartPrivate.interceptors.request.eject(requestIntercept);
            axiosMultipartPrivate.interceptors.response.eject(responseIntercept);
        }
    }, [auth, refresh])

    return axiosMultipartPrivate;
}

export default useAxiosMultiPrivate;