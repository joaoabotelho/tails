import axios from 'axios';

export default axios.create();

export const axiosPrivate = axios.create({
    headers: { 'Content-Type': 'application/json' },
    withCredentials: true
});

export const axiosMultipartPrivate = axios.create({
    headers: { 'Content-Type': 'multipart/form-data' },
    withCredentials: true
});