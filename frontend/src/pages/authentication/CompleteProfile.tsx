import './completeProfile.css'
import Button from "../../components/button/Button";
import useAuth from '../../middleware/hooks/useAuth';
import useAxiosPrivate from '../../middleware/hooks/useAxiosPrivate';
import { motion } from 'framer-motion';
import { useEffect, useRef, useState } from "react";
import { useNavigate } from 'react-router-dom';

const USERNAME_REGEX = /^[a-zA-Z0-9]+([._]?[a-zA-Z0-9]+)*$/;
interface PostParams {
    name: string;
}

const CompleteProfile: React.FC = () => {
    const userRef = useRef<HTMLInputElement>(null);
    const errRef = useRef<HTMLParagraphElement>(null);

    const [name, setName] = useState<string>('');
    const [userFocus, setUserFocus] = useState<boolean>(false);

    const [validName, setValidName] = useState<boolean>(false);
    const [errMsg, setErrMsg] = useState<string[]>([]);
    const [success, setSuccess] = useState<boolean>(false);
    const [isLoading, setIsLoading] = useState<boolean>(false);

    const axiosPrivate = useAxiosPrivate();
    const { auth, setAuth } = useAuth();
    const navigate = useNavigate()

    useEffect(() => {
        userRef.current.focus();
    }, [])

    useEffect(() => {
        if (name === "") {
            setValidName(false)
        } else {
            setValidName(true);
        }
    }, [name])

    const handleSubmit = async (e: React.FormEvent<HTMLFormElement>) => {
        e.preventDefault();
        const params: PostParams = {
            name: name
        }
        setIsLoading(true);

        axiosPrivate.post("/api/v1/user/complete-profile", params).then(response => {
            setIsLoading(false);
            setSuccess(true);
            setAuth({
                user: auth.user,
                accessToken: auth.accessToken,
                role: "active"
            });
            navigate("/profile")
        }).catch(error => {
            setIsLoading(false);
            setSuccess(false);
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
        >
            <h3>Welcome to Tails! Please complete your profile.</h3>
            <p ref={errRef} className={errMsg ? "errmsg" : "offscreen"}>{errMsg}</p>
            {isLoading ? <p>Loading...</p> : ""}
            <form onSubmit={handleSubmit}>
                <label htmlFor="name">Name</label>
                <input
                    type="text"
                    autoComplete="off"
                    onChange={(e) => setName(e.target.value)}
                    required
                    onFocus={() => setUserFocus(true)}
                    onBlur={() => setUserFocus(false)}
                />
                <Button type="submit" disabled={!validName}>Save</Button>
            </form>
        </motion.div>
    );
}

export default CompleteProfile;