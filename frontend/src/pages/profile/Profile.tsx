import React, { useEffect, useState } from 'react'
import { useNavigate } from 'react-router-dom';
import Button from '../../components/button/Button';
import { motion } from 'framer-motion';
import "./profile.css"
import useAuth from "../../middleware/hooks/useAuth";
import useAxiosPrivate from '../../middleware/hooks/useAxiosPrivate';

const Profile: React.FC = () => {
    const { auth, setAuth } = useAuth();
    const [name, setName] = useState<string>(auth.user?.name);
    const [email, setEmail] = useState<string>(auth.user?.email);
    const [slug, setSlug] = useState<string>(auth.user?.slug);
    const navigate = useNavigate()
    const axiosPrivate = useAxiosPrivate();

    useEffect(() => {
        setName(auth.user?.name)
        setEmail(auth.user?.email)
        setSlug(auth.user?.slug)
    }, [auth.user]);

    const logoutHandle = (e: React.MouseEvent<HTMLButtonElement>) => {
        e.preventDefault();
        axiosPrivate.delete("/api/v1/session").then(response => {
            localStorage.clear()
            setAuth({});
        }).catch(error => {
            console.log(error)
        })
    }

    return (
        <motion.div
            initial={{ opacity: 0 }}
            transition={{
                duration: 0.6,
            }}
            animate={{ opacity: 1 }}
            className="profile-div"
        >
            <h3>Hello {name}!</h3>
            <p>Email: {email}</p>
            <p>ID: {slug}</p>
            <Button onClick={logoutHandle}>Logout</Button>
        </motion.div>
    )
}

export default Profile
