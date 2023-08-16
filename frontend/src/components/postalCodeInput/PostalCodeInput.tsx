import React, { useState, useEffect } from "react";
import { useReducer } from "react";
import "./PostalCodeInput.css"

interface Props {
    stateProp: "default" | "filled" | "focused" | "hover" | "error";
    setValue: React.Dispatch<React.SetStateAction<string>>;
    value: string;
}

export const PostalCodeInput: React.FC<Props> = ({
    stateProp,
    value,
    setValue
}) => {
    const [first, second] = value.split('-');
    console.log(first)

    const [firstPart, setFirstPart] = useState<string>(first || '')
    const [secondPart, setSecondPart] = useState<string>(second || '')
    const [state, dispatch] = useReducer(reducer, {
        state: stateProp || "default",
    });

    const handleFirstPartChange = (event) => {
        const numericValue = event.target.value.replace(/[^0-9]/g, ''); // Allow only numeric characters
        setFirstPart(numericValue);
      };

    const handleSecondPartChange = (event) => {
        const numericValue = event.target.value.replace(/[^0-9]/g, ''); // Allow only numeric characters
        setSecondPart(numericValue);
      };


    useEffect(() => {
        const combinedValue = `${firstPart}-${secondPart}`;
        setValue(combinedValue)
    }, [firstPart, secondPart])


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
                <span>Código Postal</span>
                <span className={`text-wrapper`}>*</span>
            </div>
            <div className={`enter-input-postal-code`}>
                <input
                    className="enter-your-input"
                    type="text"
                    required
                    placeholder="0000"
                    maxLength={4}
                    value={firstPart}
                    onChange={handleFirstPartChange}
                />
                -
                <input
                    className="enter-your-input"
                    type="text"
                    required
                    placeholder="000"
                    value={secondPart}
                    onChange={handleSecondPartChange}
                    maxLength={3}
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