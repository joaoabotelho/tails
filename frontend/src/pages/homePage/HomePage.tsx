import Button from "../../components/button/Button";
import { useNavigate } from 'react-router-dom';
import whatsPoint from '../../assets/whats_the_point.svg'
import homePageVideo from '../../assets/homePage_video.mp4'
import "./homePage.css"
import { motion } from "framer-motion";

const HomePage: React.FC = () => {
    const style = { color: "#F2B429" };
    const navigate = useNavigate();

    return (
        <motion.div
            initial={{ opacity: 0 }}
            transition={{
                duration: 0.6,
            }}
            animate={{ opacity: 1 }}
            className="main-home-page"
        >
            <div className="footer">
                <img src={whatsPoint} alt="Whats the point" />
                <Button onClick={() => navigate("/login")}>Login</Button>
            </div>
            <div className="homepage-video">
                <video hidden id="myVideo" autoPlay muted loop>
                    <source src={homePageVideo} />
                </video>

                <h1 className="text-over-video">
                    Your<span style={style}> Scoreboard</span> online.
                </h1>
            </div>
        </motion.div>
    );
}

export default HomePage;