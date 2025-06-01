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

            if (response.ok) {
                const userData = await response.json();
                setUser(userData);
                setError(null);
            } else {
                setUser(null);
            }
        } catch (err) {
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
                throw new Error(errorData.message || 'Login failed');
            }

            await fetchUser();
            navigate('/');
        } catch (err) {
            setError(err.message);
            setUser(null);
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

    // Initialize auth state
    useEffect(() => {
        const initializeAuth = async () => {
            await fetchUser();

            // Set up token refresh timer
            const refreshInterval = setInterval(async () => {
                if (user) {
                    await refreshTokens();
                }
            }, 14 * 60 * 1000); // Refresh every 14 minutes

            return () => clearInterval(refreshInterval);
        };

        initializeAuth();
    }, [fetchUser, refreshTokens, user]);

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

    // Context value
    const value = {
        user,
        isLoading,
        error,
        login,
        logout,
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