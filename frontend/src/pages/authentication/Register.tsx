import React from "react";
import GetStarted from "./GetStarted";
import { RegisterForm } from "./RegisterForm"

export const Register: React.FC = (): JSX.Element => {
    return (
        <GetStarted>
            <RegisterForm />
        </GetStarted>
    );
};