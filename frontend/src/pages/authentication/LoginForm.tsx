import React, { useState, useEffect } from "react";
import { TextInput } from '../../components/textInput/TextInput'
import "./LoginForm.css";
import axios from '../../middleware/api/axios';
import useAuth from '../../middleware/hooks/useAuth';
import vector from '../../assets/vector_1.svg';
import { useNavigate } from 'react-router-dom';
import Button from "../../components/button/Button";
import FacebookButton from "../../components/iconButtons/FacebookButton";
import GoogleButton from "../../components/iconButtons/GoogleButton";

const EMAIL_REGEX = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
const PASSWORD_REGEX = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{14,}$/;

interface PostParams {
    user: {
        email: string;
        password: string;
    }
}

export const LoginForm: React.FC = (): JSX.Element => {
    const [email, setEmail] = useState<string>('');
    const [password, setPassword] = useState<string>('');

    const [validEmail, setValidEmail] = useState<boolean>(false);
    const [validPassword, setValidPassword] = useState<boolean>(false);

    const [errMsg, setErrMsg] = useState<string[]>([]);
    const [persist, setPersist] = useState<boolean>(false);

    const { auth, setAuth } = useAuth();
    const navigate = useNavigate()


    const togglePersist = () => {
        setPersist(prev => !prev);
    }

    useEffect(() => {
        localStorage.setItem("persist", persist.toString());
    }, [persist])


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

    const handleSubmit = async (e: React.FormEvent<HTMLFormElement>) => {
        e.preventDefault();
        const params: PostParams = {
            user: {
                email: email,
                password: password
            }
        }
        axios.post("/api/v1/session", params).then(response => {
            const user = {};
            const accessToken = response.data.access_token;
            const role = response.data.user_status;

            setAuth({ user: user, accessToken: accessToken, role: role });
            if (role == "initiated") {
                navigate("/complete-profile")
            } else {
                navigate("/profile")
            }
        }).catch(error => {
            const data = error.response.data
            setErrMsg([...errMsg, data.error?.message, JSON.stringify(data.errors), data.message])
        });
    }

    return (
        <div className="frame">
            <div className="div">
                <h2>Bem-vindo(a) Lorem ipsum dolor sit amet</h2>
                <div className="frame-2">
                    <div className="frame-3">
                        <form className="frame-2" onSubmit={handleSubmit}>
                            <div className="frame-4">
                                <TextInput
                                    label="Email"
                                    type="text"
                                    placeholder="exemplo@email.com"
                                    stateProp="default"
                                    setValue={setEmail}
                                    value={email}
                                    required
                                />
                                <TextInput
                                    label="Password"
                                    type="password"
                                    placeholder="••••••••••••"
                                    stateProp="default"
                                    value={password}
                                    setValue={setPassword}
                                    required
                                />
                            </div>
                            <Button type="submit" extraClass="design-component-instance-node" disabled={(!validEmail || !validPassword)}>Iniciar sessão</Button>
                        </form>
                        <div className="terms-and-conditions">
                            <input type="checkbox" id="myCheckbox" className="terms-and-conditions-check" checked={persist}
                                onChange={togglePersist} />
                            <span className="text-wrapper-2">Gravar a minha conta</span>
                        </div>

                        <div className="already-a-member-log">
                            <span className="text-wrapper-2">Esqueceu-se da password? </span>
                            <button className="text-wrapper-3">Recuperar</button>
                        </div>
                    </div>
                    <div className="frame-5">
                        <img className="vector" alt="Vector" src={vector} />
                        <div className="i-have-read-the">ou</div>
                        <img className="vector" alt="Vector" src={vector} />
                    </div>
                    <div className="frame-6">
                        <GoogleButton />
                        <FacebookButton />
                    </div>
                </div>
                <div className="already-a-member-log">
                    <span className="text-wrapper-2">Ainda não tem conta? </span>
                    <button onClick={() => navigate("/register")} className="text-wrapper-3">Registe-se aqui</button>
                </div>
            </div>
        </div>
    )
}
