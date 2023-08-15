import React, { useEffect, useRef, useState } from 'react'
import { useNavigate } from 'react-router-dom';
import Button from '../../components/button/Button';
import { motion } from 'framer-motion';
import "./profile.css"
import useAuth from "../../middleware/hooks/useAuth";
import useAxiosPrivate from '../../middleware/hooks/useAxiosPrivate';
import useAxiosMultiPrivate from '../../middleware/hooks/useAxiosMultiPrivate';
import { UserInfo } from '../../@types/auth';

interface PostParams {
    name: string,
    age: number,
    mobile_number: string,
    emergency_contact: string,
    title: string,
    address: string,
    address_line_2: string,
    city: string,
    postal_code: string,
    state: string
}

const EditProfile: React.FC = () => {
    const errRef = useRef<HTMLParagraphElement>(null);
    const userRef = useRef<HTMLInputElement>(null);
    const { auth, setAuth } = useAuth();
    const [user, setUser] = useState<UserInfo>(auth.user)
    const [selectedFile, setSelectedFile] = useState<File | null>(null);
    const [isLoading, setIsLoading] = useState<boolean>(false)
    const [isSuccess, setIsSuccess] = useState<boolean>(false)
    const [errMsg, setErrMsg] = useState<string[]>([]);
    const navigate = useNavigate()
    const axiosMultiPrivate = useAxiosMultiPrivate();
    const [formData, setFormData] = useState({
        name: auth.user.personalDetails.name,
        age: auth.user.personalDetails.age,
        mobileNumber: auth.user.personalDetails.mobileNumber,
        emergencyContact: auth.user.personalDetails.emergencyContact,
        title: auth.user.personalDetails.title,
        address: auth.user.personalDetails.address.address,
        addressLine2: auth.user.personalDetails.address.addressLine2,
        city: auth.user.personalDetails.address.city,
        postalCode: auth.user.personalDetails.address.postalCode,
        state: auth.user.personalDetails.address.state
    });

    useEffect(() => {
        setUser(auth.user)
    }, [auth.user]);

    const handleChange = (e: React.ChangeEvent<HTMLInputElement>) => {
        const { name, value } = e.target;
        setFormData((prevData) => ({
            ...prevData,
            [name]: value
        }));
    };

    const handleSelectChange = (e: React.ChangeEvent<HTMLSelectElement>) => {
        const { name, value } = e.target;
        setFormData((prevData) => ({
            ...prevData,
            [name]: value
        }));
    };


    const handleFileChange = (e: React.ChangeEvent<HTMLInputElement>) => {
        if (e.target.files && e.target.files.length > 0) {
            setSelectedFile(e.target.files[0]);
        }
    };

    const handleSubmit = async (e: React.FormEvent<HTMLFormElement>) => {
        e.preventDefault();
        const profilePictureObjectURL = URL.createObjectURL(selectedFile);

        const params: PostParams =
        {
            name: formData.name,
            age: Number(formData.age),
            mobile_number: formData.mobileNumber,
            emergency_contact: formData.emergencyContact,
            title: formData.title,
            address: formData.address,
            address_line_2: formData.addressLine2,
            city: formData.city,
            postal_code: formData.postalCode,
            state: formData.state
        }

        const data = new FormData();

        for (const key in params) {
            if (params.hasOwnProperty(key)) {
                const value = params[key];
                data.append(key, value);
            }
        }

        // Now append the profile picture
        if (selectedFile) {
            data.append('profile_picture', selectedFile);
        }

        setIsLoading(true);

        axiosMultiPrivate.patch("/api/v1/user", data).then(response => {
            const userInfo:UserInfo = {
                email: auth.user.email,
                slug: auth.user.slug,
                status: auth.user.status,
                role: auth.user.role,
                profilePicture: profilePictureObjectURL,
                personalDetails: {
                    address: {
                        address: params.address,
                        addressLine2: params.address_line_2,
                        city: params.city,
                        postalCode: params.postal_code,
                        state: params.state
                    },
                    age: params.age,
                    emergencyContact: params.emergency_contact,
                    mobileNumber: params.mobile_number,
                    name: params.name,
                    title: params.title
                }
            };

            setAuth({
                user: userInfo,
                accessToken: auth.accessToken,
                role: auth.role
            })
            setIsLoading(false);
            setIsSuccess(true);
            setErrMsg([]);
            navigate("/profile");
        }).catch(error => {
            setIsLoading(false);
            setIsSuccess(false);
            const data = error.response.data
            setErrMsg([...errMsg, data.error?.message, JSON.stringify(data.errors), data.message])
            errRef.current.focus()
        });
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
            <h3>Edit Profile</h3>
            <p ref={errRef} className={errMsg ? "errmsg" : "offscreen"}>{errMsg}</p>
            {isLoading ? <p>Loading...</p> : ""}
            <form onSubmit={handleSubmit}>
                <input type="file" onChange={handleFileChange} />
                <input
                    type="text"
                    name="name"
                    value={formData.name}
                    onChange={handleChange}
                />
                <input
                    type="number"
                    name="age"
                    value={formData.age}
                    onChange={handleChange}
                />
                <input
                    type="text"
                    name="mobileNumber"
                    value={formData.mobileNumber}
                    onChange={handleChange}
                />
                <input
                    type="text"
                    name="emergencyContact"
                    value={formData.emergencyContact}
                    onChange={handleChange}
                />
                <select
                    name="title"
                    value={formData.title}
                    onChange={handleSelectChange}
                >
                    <option value="">Select Title</option>
                    <option value="mr">Mr.</option>
                    <option value="mrs">Mrs.</option>
                    <option value="miss">Miss.</option>
                    <option value="ms">Ms.</option>
                    <option value="mx">Mx.</option>
                </select>
                <input
                    type="text"
                    name="address"
                    value={formData.address}
                    onChange={handleChange}
                />
                <input
                    type="text"
                    name="addressLine2"
                    value={formData.addressLine2 || ""}
                    onChange={handleChange}
                />
                <input
                    type="text"
                    name="city"
                    value={formData.city}
                    onChange={handleChange}
                />
                <input
                    type="text"
                    name="postalCode"
                    value={formData.postalCode}
                    onChange={handleChange}
                />
                <input
                    type="text"
                    name="state"
                    value={formData.state}
                    onChange={handleChange}
                />
                <Button type="submit">Update</Button>
            </form>

        </motion.div>
    )
}

export default EditProfile