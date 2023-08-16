import React from 'react';
import google_icon from '../../assets/Google_icon.svg';
import "./googleButton.css";
import IconButton from './IconButton';
import axios from '../../middleware/api/axios';


const GoogleButton: React.FC = () => {
    const loginWithGoogle = (e: React.MouseEvent<HTMLButtonElement>) => {
        axios.get("/api/v1/auth/google/new").then((response) => {
            window.location.replace(response.data.url);
        })
    }

    return (
        <>
            <IconButton onClick={loginWithGoogle} className={'google-button'} icon={google_icon}>
                Entrar com o Google
            </IconButton>
        </>
    );
};

export default GoogleButton;