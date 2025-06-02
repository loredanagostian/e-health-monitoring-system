import React, { createContext, useContext, useState, useEffect, useCallback } from 'react';
import { useNavigate } from 'react-router-dom';

const AuthContext = createContext();

export function AuthProvider({ children }) {
    const [user, setUser] = useState(null);
    const [isLoading, setIsLoading] = useState(true);
    const [error, setError] = useState(null);
    const navigate = useNavigate();

    // Fetch current user
    const fetchUser = useCallback(async () => {
        try {
            const response = await fetch('/api/DoctorRegister/Temp', {
                credentials: 'include',
            });

            console.log("Response status:", response.status);

            const contentType = response.headers.get('content-type');
            console.log("Content-Type:", contentType);

            if (response.ok) {
                const userData = await response.json();
                console.log("Received userData:", userData);
                localStorage.setItem("doctorId", parseJwt(userData.token).unique_name);
                localStorage.setItem("token", userData.token);
                setUser(userData);
                setError(null);
            } else {
                const text = await response.text();
                console.warn("Failed to fetch user. Response:", text);
                setUser(null);
            }
        } catch (err) {
            console.error("Error while fetching user:", err);
            setUser(null);
        } finally {
            setIsLoading(false);
        }
    }, []);

    // Login handler
    const login = async (email, password) => {
        setIsLoading(true);
        setError(null);

        try {
            const response = await fetch('/api/DoctorRegister/SignInDoctor', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ "email": email, "passwd": password }),
                credentials: 'include',
            });

            if (!response.ok) {
                const errorData = await response.json();
                throw new Error(errorData.msg || 'Login failed');
            }

            const data = await response.json();
            console.log('Token from response:', data.token);

            await fetchUser();
            localStorage.setItem("isAuthenticated", "true");
            navigate('/');
        } catch (err) {
            setError(err.message);
            setUser(null);
            localStorage.setItem("isAuthenticated", "false");
        } finally {
            setIsLoading(false);
        }
    };

    // Logout handler
    const logout = async () => {
        try {
            await fetch('/api/DoctorRegister/Temp', {
                // method: 'POST',
                credentials: 'include',
            });
        } finally {
            setUser(null);
            navigate('/signin');
        }
    };

    // Silent token refresh
    const refreshTokens = useCallback(async () => {
        try {
            const response = await fetch('/api/DoctorRegister/RefreshToken', {
                method: 'POST',
                credentials: 'include',
            });

            if (!response.ok) {
                throw new Error('Token refresh failed');
            }

            return true;
        } catch (err) {
            await logout();
            return false;
        }
    }, [logout]);

    useEffect(() => {
        fetchUser();
    }, []);

    useEffect(() => {
        if (!user) return;

        const refreshInterval = setInterval(async () => {
            await refreshTokens();
        }, 14 * 60 * 1000); // every 14 minutes

        return () => clearInterval(refreshInterval);
    }, [user]);

    // Wrapper for authenticated fetch
    const authFetch = async (url, options = {}) => {
        let response = await fetch(url, {
            ...options,
            credentials: 'include',
        });

        // If token expired, try to refresh
        if (response.status === 401) {
            const refreshSuccess = await refreshTokens();
            if (refreshSuccess) {
                response = await fetch(url, {
                    ...options,
                    credentials: 'include',
                });
            } else {
                await logout();
                return null;
            }
        }

        return response;
    };

    const register = async (email, password) => {
        setIsLoading(true);
        setError(null);

        try {
            const response = await fetch('/api/DoctorRegister/SignUpDoctor', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ email: email, passwd: password }),
                credentials: 'include',
            });

            if (!response.ok) {
                const result = await response.json();
                throw new Error(result.message || 'Registration failed');
            }

            await fetchUser();
            localStorage.setItem("isAuthenticated", "true");
            navigate("/register-profile");
        } catch (err) {
            setError(err.message);
            localStorage.setItem("isAuthenticated", "false");
        } finally {
            setIsLoading(false);
        }
    };


    // Context value
    const value = {
        user,
        isLoading,
        error,
        login,
        logout,
        register,
        authFetch,
    };

    return (
        <AuthContext.Provider value={value}>
            {children}
        </AuthContext.Provider>
    );
}

export function useAuth() {
    const context = useContext(AuthContext);
    if (!context) {
        throw new Error('useAuth must be used within an AuthProvider');
    }
    return context;
}

export function parseJwt(token) {
    if (!token) return null;
    try {
        const base64Url = token.split('.')[1];
        const base64 = base64Url.replace(/-/g, '+').replace(/_/g, '/');
        const jsonPayload = decodeURIComponent(
            atob(base64)
                .split('')
                .map((c) => '%' + c.charCodeAt(0).toString(16).padStart(2, '0'))
                .join('')
        );

        return JSON.parse(jsonPayload);
    } catch {
        return null;
    }
}