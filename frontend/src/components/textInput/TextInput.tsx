import React from "react";
import { useReducer } from "react";
import "./textInput.css";

interface Props {
    stateProp: "default" | "filled" | "focused" | "hover" | "error";
    label: string;
    type: string
    placeholder: string;
    maxLength?: number
    required?: boolean;
    value: string;
    setValue: React.Dispatch<React.SetStateAction<string>>;
}

export const TextInput: React.FC<Props> = ({
    stateProp,
    label,
    placeholder = "Enter your email",
    required = false,
    maxLength,
    type,
    value,
    setValue
}) => {
    const [state, dispatch] = useReducer(reducer, {
        state: stateProp || "default",
    });


    return (
        <div
            className={`text-fields ${state.state}`}
            onMouseLeave={() => {
                dispatch("mouse_leave");
            }}
            onMouseEnter={() => {
                dispatch("mouse_enter");
            }}
        >
            <div className={`label`}>
                <span>{label}</span>
                {required ?
                    <span className={`text-wrapper`}>*</span> : <></>
                }
            </div>
            <div className={`enter-input`}>
                <input
                    className="enter-your-input"
                    type={type}
                    required={required}
                    placeholder={placeholder}
                    onChange={(e) => setValue(e.target.value)}
                    maxLength={maxLength}
                    value={value}
                />
            </div>
        </div>
    );
};

function reducer(state: any, action: any) {
    switch (action) {
        case "mouse_enter":
            return {
                ...state,
                state: "hover",
            };

        case "mouse_leave":
            return {
                ...state,
                state: "default",
            };
    }

    return state;
}