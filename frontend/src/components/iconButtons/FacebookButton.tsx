import React from 'react';
import "./googleButton.css";
import IconButton from './IconButton';
import facebookIcon from '../../assets/Facebook_icon.svg';

const FacebookButton: React.FC = () => {
    const loginWithFacebook = (e: React.MouseEvent<HTMLButtonElement>) => {
        console.log("try login with facebook")
    }

    return (
        <>
            <IconButton onClick={loginWithFacebook} className={'google-button'} icon={facebookIcon}>
                Entrar com o Facebook
            </IconButton>
        </>
    );
};

export default FacebookButton;