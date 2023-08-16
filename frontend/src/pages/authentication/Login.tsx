import React from "react";
import { LoginForm } from "./LoginForm";
import GetStarted from "./GetStarted";

export const Login: React.FC = (): JSX.Element => {
    return (
        <GetStarted>
            <LoginForm />
        </GetStarted>
    );
};