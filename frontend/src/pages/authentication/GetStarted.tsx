import "./getStarted.css";
import React from "react";
import logo from '../../assets/logo.svg';
import { useNavigate } from "react-router-dom";

interface Props {
    children: JSX.Element;
}
const GetStarted: React.FC<Props> = ({children}): JSX.Element => {
    const navigate = useNavigate()

    return (
        <div className="get-started">
            <div className="frame-wrapper">
                <div className="box-1">
                    <div className="symbol">
                        <div onClick={() => navigate("/")}className="clip-path-group">
                            <img className="clip-path" alt="Clip path" src={logo} />
                            <p className="company-name">tails</p>
                        </div>
                        <div className="frame">
                            <h3 className="why-our-service">Porquê o nosso serviço?</h3>
                            <div className="were-animal-lovers">
                                <p className="p">Lorem ipsum dolor sit amet consectetur. Nunc gravida in.</p>
                                <p className="p">Lorem ipsum dolor sit amet consectetur. Nunc gravida in.</p>
                                <p className="p">Lorem ipsum dolor sit amet consectetur. Nunc gravida in.</p>
                            </div>
                        </div>
                    </div>
                </div>
                <div className="box-2">
                    <>
                        {children}
                    </>
                </div>
            </div>
        </div >
    );
};

export default GetStarted;