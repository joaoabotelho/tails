export interface Address {
    address?: string;
    addressLine2?: string;
    city?: string;
    postalCode?: string;
    state?: string;
}
export interface PersonalDetails {
    address?: Address;
    age?: number;
    emergencyContact?: string;
    mobileNumber?: string;
    name?: string;
    title?: string;
}
export interface UserInfo {
    email?: string;
    name?: string;
    slug?: string;
    status?: string;
    role?: string;
    personalDetails?: PersonalDetails;
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