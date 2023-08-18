import "./completeProfile.css";
import React, { useState } from "react";
import logo from '../../assets/logo.svg';
import { useNavigate } from "react-router-dom";
import dot from '../../assets/dot.svg';
import connector from '../../assets/Connector.svg';
import { CompleteProfileForm } from "./CompleteProfileForm";

const CompleteProfile: React.FC = (): JSX.Element => {
    const [step, setStep] = useState<number>(1);
    const navigate = useNavigate()

    return (
        <div className="complete-profile">
            <div className="frame-wrapper">
                <div className="box-1">
                    <div className="symbol">
                        <div onClick={() => navigate("/")} className="clip-path-group">
                            <img className="clip-path" alt="Clip path" src={logo} />
                            <p className="company-name">tails</p>
                        </div>
                        <div className="steps-frame">
                            <img className="connector" src={connector} />
                            <div className="step-1">
                                <img className="dot" alt="dot" src={dot} />
                                <div className="pet-basics">Perfil do Dono</div>
                            </div>
                            <div className="step-2">
                                <div className={`text-wrapper ${step === 1 ? `` : `disable`}`}>Detalhes Pessoais</div>
                                <div className={`pet-basics-2 ${step === 2 ? `` : `disable`}`}>Contactos de Emergência</div>
                            </div>
                            <div className="step-3 disable">
                                <img className="dot disable" alt="dot" src={dot} />
                                <div className="pet-basics-3">Perfil do Animal</div>
                            </div>
                        </div>
                    </div>
                </div>
                <div className="box-2">
                    <CompleteProfileForm
                        step={step}
                        setStep={setStep}
                    />
                </div>
            </div>
        </div >
    );
};

export default CompleteProfile;