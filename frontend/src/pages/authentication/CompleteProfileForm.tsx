import React, { useState, useEffect } from "react";
import { TextInput } from '../../components/textInput/TextInput'
import { useNavigate } from 'react-router-dom';
import Button from "../../components/button/Button";
import "./CompleteProfileForm.css";
import useAxiosMultiPrivate from '../../middleware/hooks/useAxiosMultiPrivate';
import vector from '../../assets/vector_2.svg';
import { PostalCodeInput } from "../../components/postalCodeInput/PostalCodeInput";
import useAuth from "../../middleware/hooks/useAuth";
import ProfilePictureInput from "../../components/profilePictureInput/ProfilePictureInput";

interface Props {
    step: number;
    setStep: React.Dispatch<React.SetStateAction<number>>
}

interface PostParams {
    name: string;
    address: string;
    address_line_2: string;
    postal_code: string;
    state: string;
    city: string;
    emergency_contact: string;
    mobile_number: string;
}

export const CompleteProfileForm: React.FC<Props> = ({ step, setStep }): JSX.Element => {
    const [name, setName] = useState<string>('')
    const [address, setAddress] = useState<string>('')
    const [addressLine2, setAddressLine2] = useState<string>('')
    const [postalCode, setPostalCode] = useState<string>('')
    const [state, setState] = useState<string>('')
    const [city, setCity] = useState<string>('')
    const [emergencyContactName, setEmergencyContactName] = useState<string>('')
    const [emergencyContact, setEmergencyContact] = useState<string>('')
    const [personalContact, setPersonalContact] = useState<string>('')
    const [selectedFile, setSelectedFile] = useState<File>(null);

    const [isFirstPartValid, setIsFirstPartValid] = useState<boolean>(false);
    const [isSecondPartValid, setIsSecondPartValid] = useState<boolean>(false);

    const axiosMultiPrivate = useAxiosMultiPrivate();
    const { auth, setAuth } = useAuth();
    const navigate = useNavigate();

    const handlePersonalContactChange = (value: string) => {
        const numericValue = value.replace(/[^0-9]/g, ''); // Allow only numeric characters
        setPersonalContact(numericValue);
    };

    const handleEmergencyContactChange = (value: string) => {
        const numericValue = value.replace(/[^0-9]/g, ''); // Allow only numeric characters
        setEmergencyContact(numericValue);
    };


    const handleSubmit = async (e: React.FormEvent<HTMLFormElement>) => {
        e.preventDefault();

        const params: PostParams = {
            name: name,
            address: address,
            address_line_2: addressLine2,
            postal_code: postalCode,
            state: state,
            city: city,
            emergency_contact: emergencyContact,
            mobile_number: personalContact
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

        // setIsLoading(true);

        axiosMultiPrivate.post("/api/v1/user/complete-profile", data).then(response => {
            // setIsLoading(false);
            // setSuccess(true);
            setAuth({
                user: auth.user,
                accessToken: auth.accessToken,
                role: "active"
            });
            navigate("/profile")
        }).catch(error => {
            // setIsLoading(false);
            // setSuccess(false);
            const data = error.response.data
            // setErrMsg([...errMsg, data.error?.message, JSON.stringify(data.errors), data.message])
            // errRef.current.focus()
        });
    }

    useEffect(() => {
        const isValid = !(
            name.length === 0 ||
            address.length === 0 ||
            postalCode.length === 0 ||
            state.length === 0 ||
            city.length === 0
        );

        setIsFirstPartValid(isValid)
    }, [name, address, postalCode, state, city])

    useEffect(() => {
        const isValid = !(
            personalContact.length === 0 ||
            emergencyContact.length === 0 ||
            emergencyContactName.length === 0
        );

        setIsSecondPartValid(isValid)
    }, [emergencyContact, emergencyContactName, personalContact])



    return (
        <form onSubmit={handleSubmit} className="frame">
            <div className="frame-2">
                <div className="frame-3">
                    <h2>Perfil do Dono</h2>
                    <div>
                        <p>Por favor introduza alguns dados para que possamos completar o seu perfil.</p>
                        <p>Haverá possibilidade de editar todos os dados mais tarde no seu perfil.</p>
                    </div>
                </div>
                {step === 1 && (
                    <div className="frame-4">
                        <div className="first-inputs">
                            <TextInput
                                label="Nome"
                                type="text"
                                placeholder="Primeiro e último nome"
                                stateProp="default"
                                value={name}
                                setValue={setName}
                                required
                            />
                            <ProfilePictureInput setSelectedFile={setSelectedFile} />
                        </div>
                        <img className="vector" alt="Vector" src={vector} />
                        <div className="second-inputs">
                            <TextInput
                                label="Morada linha 1"
                                type="text"
                                placeholder="ex. Rua José do Carmo"
                                stateProp="default"
                                value={address}
                                setValue={setAddress}
                                required
                            />
                            <TextInput
                                label="Morada linha 2"
                                type="text"
                                placeholder="ex. RC Direito"
                                stateProp="default"
                                value={addressLine2}
                                setValue={setAddressLine2}
                            />
                        </div>
                        <div className="third-inputs">
                            <PostalCodeInput
                                stateProp="default"
                                value={postalCode}
                                setValue={setPostalCode}
                            />
                            <TextInput
                                label="Distrito"
                                type="text"
                                placeholder="ex. Coimbra"
                                stateProp="default"
                                value={state}
                                setValue={setState}
                                required
                            />
                            <TextInput
                                label="Cidade"
                                type="text"
                                placeholder="ex. Figueira da Foz"
                                stateProp="default"
                                value={city}
                                setValue={setCity}
                                required
                            />
                        </div>
                    </div>)}

                {step === 2 && (
                    <div className="frame-4">
                        <div className="first-inputs">
                            <TextInput
                                label="Nome do Contacto"
                                type="text"
                                placeholder="Primeiro e último nome"
                                stateProp="default"
                                value={emergencyContactName}
                                setValue={setEmergencyContactName}
                                required
                            />
                            <TextInput
                                label="Número de telemóvel ou telefone"
                                type="text"
                                value={emergencyContact}
                                placeholder="000000000"
                                stateProp="default"
                                setValue={handleEmergencyContactChange}
                                required
                                maxLength={9}
                            />
                        </div>
                        <div className="second-inputs">
                            <TextInput
                                label="Número de telemóvel pessoal"
                                type="text"
                                value={personalContact}
                                placeholder="000000000"
                                stateProp="default"
                                setValue={handlePersonalContactChange}
                                required
                                maxLength={9}
                            />
                        </div>
                    </div>)}
            </div>
            <div className="form-step-buttons">
                {step === 1 && (
                    <Button onClick={() => setStep(2)} type="button" disabled={!isFirstPartValid}>Continuar</Button>
                )}
                {step === 2 && (
                    <>
                        <Button onClick={() => setStep(1)} type="button" secondary disabled={false}>Voltar</Button>
                        <Button type="submit" disabled={!isFirstPartValid || !isSecondPartValid}>Próximo Passo</Button>
                    </>
                )}
            </div>
        </form>
    )
}
