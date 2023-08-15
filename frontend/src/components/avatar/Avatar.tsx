import React from 'react';
import './Avatar.css'; // Import your CSS for styling

interface AvatarProps {
  imageUrl?: string;
  onClick?: React.MouseEventHandler<HTMLImageElement>;
  altText: string;
  size: 'small' | 'medium' | 'large';
}

const Avatar: React.FC<AvatarProps> = ({ onClick, imageUrl, altText, size }) => {
  const getSizeClassName = () => {
    switch (size) {
      case 'small':
        return 'avatar-small';
      case 'medium':
        return 'avatar-medium';
      case 'large':
        return 'avatar-large';
      default:
        return '';
    }
  };

  const renderAvatarContent = () => {
    if (imageUrl) {
      return <img src={imageUrl} alt={altText} className="avatar-image" />;
    } else {
      const initials = altText.charAt(0).toUpperCase();
      return <div className="avatar-initials">{initials}</div>;
    }
  };

  return (
    <div onClick={onClick} className={`avatar ${getSizeClassName()}`}>
      {renderAvatarContent()}
    </div>
  );
};

export default Avatar;
