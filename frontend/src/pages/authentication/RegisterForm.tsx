import React, { useState, useEffect } from "react";
import { TextInput } from '../../components/textInput/TextInput'
import Button from "../../components/button/Button";
import "./RegisterForm.css";
import axios from '../../middleware/api/axios';
import useAuth from '../../middleware/hooks/useAuth';
import vector from '../../assets/vector_1.svg';
import { useNavigate } from 'react-router-dom';
import GoogleButton from "../../components/iconButtons/GoogleButton";
import FacebookButton from "../../components/iconButtons/FacebookButton";

const EMAIL_REGEX = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
const PASSWORD_REGEX = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{14,}$/;

interface PostParams {
    user: {
        email: string;
        password: string;
    }
}

export const RegisterForm: React.FC = (): JSX.Element => {
    const [email, setEmail] = useState<string>('');
    const [password, setPassword] = useState<string>('');
    const [confirmPassword, setConfirmPassword] = useState<string>('');
    const [isChecked, setIsChecked] = useState(false);

    const [validEmail, setValidEmail] = useState<boolean>(false);
    const [validPassword, setValidPassword] = useState<boolean>(false);
    const [validConfirmPassword, setValidConfirmPassword] = useState<boolean>(false);

    const [errMsg, setErrMsg] = useState<string[]>([]);

    const { auth, setAuth } = useAuth();
    const navigate = useNavigate()
    
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

    useEffect(() => {
        const result = password === confirmPassword;
        setValidConfirmPassword(result);
        setErrMsg([]);
    }, [confirmPassword])

    const handleCheckboxChange = (e: React.ChangeEvent<HTMLInputElement>) => {
        setIsChecked(e.target.checked);
    };

    const handleSubmit = async (e: React.FormEvent<HTMLFormElement>) => {
        e.preventDefault();
        const params: PostParams = {
            user: {
                email: email,
                password: password
            }
        }
        axios.post("/api/v1/registration", params).then(response => {
            const user = {};
            const accessToken = response.data.access_token;
            const role = response.data.user_status;

            setAuth({ user: user, accessToken: accessToken, role: role });
            navigate("/complete-profile")
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
                                    value={email}
                                    type="text"
                                    placeholder="exemplo@email.com"
                                    stateProp="default"
                                    setValue={setEmail}
                                    required
                                />
                                <div className="password-frame">

                                    <TextInput
                                        label="Password"
                                        type="password"
                                        value={password}
                                        placeholder="••••••••••••"
                                        stateProp="default"
                                        setValue={setPassword}
                                        required
                                    />
                                    <TextInput
                                        label="Confirm Password"
                                        type="password"
                                        value={confirmPassword}
                                        placeholder="••••••••••••"
                                        stateProp="default"
                                        setValue={setConfirmPassword}
                                        required
                                    />
                                </div>
                            </div>
                            <Button type="submit" extraClass="design-component-instance-node" disabled={(!validEmail || !validPassword || !validConfirmPassword || !isChecked)}>Criar conta</Button>
                        </form>
                        <div className="terms-and-conditions">
                            <input type="checkbox" id="myCheckbox" className="terms-and-conditions-check" checked={isChecked}
                                onChange={handleCheckboxChange} />
                            <span className="text-wrapper-2">Li e compreendi os </span>
                            <button className="text-wrapper-3">Termos e Condições</button>
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
                    <span className="text-wrapper-2">Já é membro? </span>
                    <button onClick={() => navigate("/login")} className="text-wrapper-3">Iniciar sessão</button>
                </div>
            </div>
        </div>
    )
}