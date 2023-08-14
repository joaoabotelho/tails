import React, { useEffect, useState } from 'react'
import { useNavigate } from 'react-router-dom';
import Button from '../../components/button/Button';
import { motion } from 'framer-motion';
import "./profile.css"
import useAuth from "../../middleware/hooks/useAuth";
import useAxiosPrivate from '../../middleware/hooks/useAxiosPrivate';
import { UserInfo } from '../../@types/auth';
import { PetInfo } from '../../@types/pets';

const Profile: React.FC = () => {
    const { auth, setAuth } = useAuth();
    const [user, setUser] = useState<UserInfo>(auth.user)
    const [pets, setPets] = useState<PetInfo[]>([])
    const [isLoading, setIsLoading] = useState<boolean>(true)
    const [isSuccess, setisSuccess] = useState<boolean>(false)
    const [isUninitialized, setisUninitialized] = useState<boolean>(true)
    const navigate = useNavigate()
    const axiosPrivate = useAxiosPrivate();

    useEffect(() => {
        axiosPrivate.get("/api/v1/pets").then(response => {
            setPets(response.data)
            setIsLoading(false)
            setisSuccess(true)
        }).catch(error => {
            setIsLoading(false)
            setisSuccess(false)
            console.log(error);
        })
    }, [])

    useEffect(() => {
        setUser(auth.user)
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
            <h3>{user.personalDetails.title}. {user.personalDetails.name}</h3>
            <p>Email: {user.email}</p>
            <p>ID: {user.slug}</p>
            <p>Morada: {user.personalDetails.address.address} {user.personalDetails.address.addressLine2} {user.personalDetails.address.postalCode} {user.personalDetails.address.city}, {user.personalDetails.address.state}</p>
            <p>Idade: {user.personalDetails.age}</p>
            <p>Telemovel: {user.personalDetails.mobileNumber}</p>
            <p>Contacto de Emergencia: {user.personalDetails.emergencyContact}</p>


            <Button onClick={logoutHandle}>Logout</Button>

            <div>
                <h2>List of Pets</h2>
                <ul>
                    {pets.map((pet, index) => (
                        <li key={index}>
                            <p>Name: {pet.name}</p>
                            <p>Breed: {pet.breed}</p>
                            <p>Age: {pet.age}</p>
                            <p>Type: {pet.type}</p>
                            {/* Add more pet information here */}
                        </li>
                    ))}
                </ul>
            </div>
        </motion.div>
    )
}

export default Profile
