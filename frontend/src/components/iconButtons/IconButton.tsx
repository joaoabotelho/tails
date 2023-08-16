import React from 'react';
import { motion } from 'framer-motion';

interface Props {
    className: string;
    children: string;
    icon: string;
    onClick: React.MouseEventHandler<HTMLButtonElement>;
    animateWidth?: string;
}

const IconButton: React.FC<Props> = ({ animateWidth, icon, className, onClick, children }) => {
    return (
        animateWidth ?
            <motion.button transition={{ duration: 0.1 }} animate={{ width: animateWidth }} className={className} onClick={onClick}>
                <div className="base">
                    <img className="icon-svg" alt="icon" src={icon} />
                    <div className="button">{children}</div>
                </div>
            </motion.button>
            :
            <button className={className} onClick={onClick}>
                <div className="base">
                    <img className="icon-svg" alt="icon" src={icon} />
                    <div className="button">{children}</div>
                </div>
            </button>
    )
};

export default IconButton;