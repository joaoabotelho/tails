import React from 'react'
import { Routes, Route } from "react-router-dom";
import { AnimatePresence } from 'framer-motion';
import Layout from '../components/layouts/Layout';
import Missing from '../pages/Missing';
import RequireNoAuth from '../components/RequireNoAuth';
import CallbackGoogle from '../pages/authentication/CallbackGoogle';
import HomePage from '../pages/homePage/HomePage';
import Unauthorized from '../pages/Unauthorized';
import ActiveLayout from '../components/layouts/ActiveLayout'
import PersistLogin from '../components/PersistLogin'
import RequireAuth from '../components/RequireAuth'
import CompleteProfile from '../pages/authentication/CompleteProfile'
import Dashboard from '../pages/dashboard/Dashboard'
import Profile from '../pages/profile/Profile'
import PetProfile from '../pages/petProfile/petProfile';
import EditProfile from '../pages/profile/editProfile';
import { Login } from '../pages/authentication/Login';
import { Register } from '../pages/authentication/Register';

const IndexRoutes: React.FC = () => {
    return (
        <AnimatePresence>
            <Routes>
                {/* Public Routes */}
                <Route path="/" element={<Layout />}>
                    <Route path="/unauthorized" element={<Unauthorized />} />

                    <Route element={<RequireNoAuth />}>
                        <Route path="/" element={<HomePage />} />
                        <Route path="/login" element={<Login />} />
                        <Route path="/register" element={<Register />} />
                        <Route path="/login/callback" element={<CallbackGoogle />} />
                    </Route>
                </Route>

                {/* Protected Routes */}
                <Route element={<PersistLogin />}> */
                    <Route element={<RequireAuth allowedRoles={["initiated"]} />}>
                        <Route path="/complete-profile" element={<CompleteProfile />} />
                    </Route>

                    <Route element={<RequireAuth allowedRoles={["active"]} />}>
                        <Route element={<ActiveLayout />}>
                            <Route path="/profile" element={<Profile />} />
                            <Route path="/edit-profile" element={<EditProfile/>} />
                            <Route path="/pet/:petSlug" element={<PetProfile />} />
                            <Route path="/dashboard" element={<Dashboard />} /> {/* to be remove */}
                        </Route>
                    </Route>
                </Route>

                {/* catch all */}
                <Route path="*" element={<Missing />} />
            </Routes>
        </AnimatePresence>
    )
}

export default IndexRoutes