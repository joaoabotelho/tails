import React, { useState, useEffect } from 'react'
import "./navBar.css"
import inbox from "../../assets/InboxFilled.svg"
import arrowDown from "../../assets/arrow_down.svg"
import useAuth from "../../middleware/hooks/useAuth";
import Avatar from '../avatar/Avatar';

interface Props {
    handleClickProfile: React.MouseEventHandler<HTMLImageElement>
}

const NavBar: React.FC<Props> = ({ handleClickProfile }) => {
    const [initials, setInitials] = useState<string>();
    const { auth } = useAuth();

    useEffect(() => {
        if (auth.user?.name) {
            let name = Array.from(auth.user.name)[0] as string
            setInitials((name).toUpperCase())
        }
    }, [auth.user]);

    return (
        <nav className='navBar'>
            <a className='navBar-link inbox'>
                <img className='navBar-link-icon' src={inbox} />
            </a>
            <div className='navBar-profile'>
                <Avatar onClick={handleClickProfile} imageUrl={auth.user.profilePicture} altText={auth.user.personalDetails.name} size="medium" />
                <img className='navBar-profile-icon' src={arrowDown} />
            </div>
        </nav>
    )
}

export default NavBar