import React, { useState } from 'react';
import './ProfilePictureInput.css';

interface AvatarProps {
    setSelectedFile: React.Dispatch<React.SetStateAction<File>>
}

const ProfilePictureInput: React.FC<AvatarProps> = ({ setSelectedFile }) => {
    const [imagePreview, setImagePreview] = useState<string | null>(null);

    const handleFileChange = (event: React.ChangeEvent<HTMLInputElement>) => {
        const file = event.target.files && event.target.files[0];

        if (file && file.type.startsWith('image/')) {
            const reader = new FileReader();
            reader.onload = () => {
                setImagePreview(reader.result as string);
            };
            reader.readAsDataURL(file);
            setSelectedFile(file);
        }

    };

    return (
        <div className={`profile-picture-div`}>
            <div>
                <input
                    type='file'
                    id='profile-picture-input'
                    className='profile-picture-input'
                    accept='image/*'
                    onChange={handleFileChange}
                />
                <label htmlFor='profile-picture-input' className='profile-picture-label'>
                    <div className='profile-picture-circle'>
                        {imagePreview ? (
                            <img src={imagePreview} alt="image preview" className='profile-picture-preview' />
                        ) : (
                            <i className='fa fa-camera'></i>
                        )}
                    </div>
                </label>
            </div>
            <p className='profile-picture-text'>Adicionar fotografia</p>
        </div>
    );
};

export default ProfilePictureInput;