import './getStarted.css';
import Button from "../../components/button/Button";
import GoogleButton from '../../components/iconButtons/GoogleButton';
import axios from '../../middleware/api/axios';
import useAuth from '../../middleware/hooks/useAuth';
import whats_the_point from '../../assets/whats_the_point.svg';
import { motion } from 'framer-motion';
import { useNavigate } from 'react-router-dom';
import { useState, useEffect, useRef } from 'react';

const EMAIL_REGEX = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
const PASSWORD_REGEX = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{14,}$/;


interface PostParams {
    user: {
        email: string;
        password: string;
    }
}

const GetStarted: React.FC = () => {
    const userRef = useRef<HTMLInputElement>(null);
    const errRef = useRef<HTMLParagraphElement>(null);

    const navigate = useNavigate()
    const [persist, setPersist] = useState<boolean>(false)

    const [email, setEmail] = useState<string>('');
    const [password, setPassword] = useState<string>('');
    const [userFocus, setUserFocus] = useState<boolean>(false);

    const [validEmail, setValidEmail] = useState<boolean>(false);
    const [validPassword, setValidPassword] = useState<boolean>(false);
    const [errMsg, setErrMsg] = useState<string[]>([]);
    const [success, setSuccess] = useState<boolean>(false);
    const [isLoading, setIsLoading] = useState<boolean>(false);

    const { auth, setAuth } = useAuth();

    useEffect(() => {
        userRef.current.focus();
    }, [])

    useEffect(() => {
        const result = EMAIL_REGEX.test(email);
        setValidEmail(result);
        setErrMsg([]);
    }, [email])

    useEffect(() => {
        const result = PASSWORD_REGEX.test(password);
        setValidPassword(result);
        setErrMsg([]);
    }, [password])

    const loginwithGoogle = (event: React.MouseEvent<HTMLDivElement>) => {
        axios.get("/api/v1/auth/google/new").then((response) => {
            window.location.replace(response.data.url);
        });
    }

    const goBack = (e: React.MouseEvent<HTMLAnchorElement>) => {
        navigate("/");
    }

    const togglePersist = () => {
        setPersist(prev => !prev);
    }

    useEffect(() => {
        localStorage.setItem("persist", persist.toString());
    }, [persist])

    const handleSubmit = async (e: React.FormEvent<HTMLFormElement>) => {
        e.preventDefault();
        const params: PostParams = {
            user: {
                email: email,
                password: password
            }
        }
        setIsLoading(true);

        axios.post("/api/v1/session", params).then(response => {
            const user = {};
            const accessToken = response.data.access_token;
            const role = response.data.user_status;

            setAuth({ user: user, accessToken: accessToken, role: role });
            setIsLoading(false);
            setSuccess(true);
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
            className='main-section'
        >
            <div className='content-section'>
                <img src={whats_the_point} alt="Whats Tails" />
                <div className='content-section-text'>
                    <h2 className='content-section-text-h2'>Hey, there</h2>
                    <p>Welcome to your personal scoreboard online. Invite your friends and keep track of your scores.</p>
                    <p ref={errRef} className={errMsg ? "errmsg" : "offscreen"}>{errMsg}</p>
                    {isLoading ? <p>Loading...</p> : ""}
                    <form onSubmit={handleSubmit}>
                    <label htmlFor="email">Email</label>
                    <input
                        type="text"
                        ref={userRef}
                        autoComplete="off"
                        onChange={(e) => setEmail(e.target.value)}
                        required
                        onFocus={() => setUserFocus(true)}
                        onBlur={() => setUserFocus(false)}
                    />
                    <label htmlFor="password">Password</label>
                    <input
                        type="password"
                        autoComplete="off"
                        onChange={(e) => setPassword(e.target.value)}
                        required
                        onFocus={() => setUserFocus(true)}
                        onBlur={() => setUserFocus(false)}
                    />
                    <Button type="submit" disabled={!validEmail || !validPassword}>Login</Button>
                    </form>
                    <GoogleButton onClick={loginwithGoogle} />
                    <div className="persistCheck">
                        <input
                            type="checkbox"
                            id="persist"
                            onChange={togglePersist}
                            checked={persist}
                        />
                        <label htmlFor="persist">Trust This Device</label>
                    </div>
                </div>
                <a className="go-back" onClick={goBack}>Go back</a>
            </div>
        </motion.div>
    );
}

export default GetStarted;