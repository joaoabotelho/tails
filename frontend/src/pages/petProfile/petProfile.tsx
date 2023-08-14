import React, { useEffect, useState } from 'react'
import { useNavigate, useParams } from 'react-router-dom';
import Button from '../../components/button/Button';
import { motion } from 'framer-motion';
import "./petProfile.css"
import useAxiosPrivate from '../../middleware/hooks/useAxiosPrivate';
import { PetInfo } from '../../@types/pets';
import Loading from '../../components/loading/Loading';

const PetProfile: React.FC = () => {
    const { petSlug } = useParams();
    const [pet, setPet] = useState<PetInfo>()
    const [isLoading, setIsLoading] = useState<boolean>(true)
    const [isSuccess, setisSuccess] = useState<boolean>(false)
    const [isUninitialized, setisUninitialized] = useState<boolean>(true)
    const navigate = useNavigate()
    const axiosPrivate = useAxiosPrivate();

    useEffect(() => {
        axiosPrivate.get("/api/v1/pets/" + petSlug).then(response => {
            setPet(response.data)
            setIsLoading(false)
            setisSuccess(true)
        }).catch(error => {
            setIsLoading(false)
            setisSuccess(false)
            console.log(error);
        })
    }, [])

    return (
        <>
            {isLoading
                ? <Loading />
                :
                <motion.div
                    initial={{ opacity: 0 }}
                    transition={{
                        duration: 0.6,
                    }}
                    animate={{ opacity: 1 }}
                    className="profile-div"
                >
                    <h3>{pet.name}</h3>
                    <p>raca: {pet.breed}</p>
                    <p>idade: {pet.age}</p>
                    <p>castrado: {pet.castrated ? "Yes" : "No"}</p>
                    <p>trained: {pet.trained ? "Yes" : "No"}</p>
                    <p>vaccination: {pet.vaccination ? "Yes" : "No"}</p>
                    <p>sex: {pet.sex}</p>
                    <p>relationship_with_animals: {pet.relationship_with_animals}</p>
                    <p>special_cares: {pet.special_cares}</p>
                    <p>vet_contact: {pet.vet_contact}</p>
                    <p>vet_name: {pet.vet_name}</p>
                    <p>more_about: {pet.more_about}</p>
                    <p>microship_id: {pet.microship_id}</p>
                    <p>type: {pet.type}</p>
                    <p>slug: {pet.slug}</p>

                </motion.div>
            }
        </>
    )
}

export default PetProfile
