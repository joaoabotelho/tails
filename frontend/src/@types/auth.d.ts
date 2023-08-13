export interface UserInfo {
    email?: string;
    name?: string;
    slug?: string;
    status?: string;
  }
  
interface User {
    user?: UserInfo;
    role?: string;
    accessToken?: string,
}

export type AuthContextType = {
    auth: User;
    setAuth: (auth: User) => void | any;
};