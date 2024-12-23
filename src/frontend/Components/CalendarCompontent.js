import React, { useEffect, useState } from 'react';
import Calendar from 'react-calendar';
import Modal from 'react-modal';
import { jwtDecode } from "jwt-decode";

const CalendarComponent = () => {

    const [selectedDate, setSelectedDate] = useState(new Date());
    const [isModalOpen, setIsModalOpen] = useState(false);
    const [dailyActivities, setDailyActivities] = useState([]);
    const [userRoutes, setUserRoutes] = useState([]);
    const [error, setError] = useState(null);
    const [loading, setLoading] = useState(true);

    useEffect(() => {
        const fetchUserData = async () => {
            const token = localStorage.getItem('authToken');
            if (token) {
                try {
                    const decodedToken = jwtDecode(token);
                    const userId = decodedToken.id;
                    const sessionKey = decodedToken.sessionKey;

                    const routesResponse = await fetch(`http://localhost:5000/api/users/${userId}/routes`, {
                        method: 'GET',
                        headers: {
                            'Authorization': `Bearer ${token}`,
                            'sessionKey': sessionKey
                        },
                    });


                    if (routesResponse.ok) {
                        const routesData = await routesResponse.json();
                        setUserRoutes(routesData);
                    } else {
                        setError('Błąd podczas pobierania tras użytkownika');
                    }
                } catch (err) {
                    setError('Wystąpił błąd podczas pobierania danych');
                }
            } else {
                setError('Brak tokena uwierzytelniającego');
            }
            setLoading(false);
        };

        fetchUserData();
    }, []);

    useEffect(() => {
        const activities = userRoutes.filter(route => {
            const routeDate = normalizeDate(new Date(route.date));
            return (
                routeDate.getDate() === selectedDate.getDate() &&
                routeDate.getMonth() === selectedDate.getMonth() &&
                routeDate.getFullYear() === selectedDate.getFullYear()
            );
        });
        setDailyActivities(activities);
    }, [selectedDate, userRoutes]);

    const handleDateChange = (date) => {
        setSelectedDate(date);
        const activities = userRoutes.filter(route => {
            const routeDate = normalizeDate(new Date(route.date));
            return (
                routeDate.getDate() === date.getDate() &&
                routeDate.getMonth() === date.getMonth() &&
                routeDate.getFullYear() === date.getFullYear()
            );
        });
        setDailyActivities(activities);
        setIsModalOpen(true);
    };

    const normalizeDate = (date) => {
        return new Date(date.getFullYear(), date.getMonth(), date.getDate());
    };

    const closeModal = () => {
        setIsModalOpen(false);
    };

    const getTransportModeName = (id) => {
        switch (id) {
            case 1:
                return 'Bieganie';
            case 2:
                return 'Rower';
            default:
                return 'Nieznany tryb';
        }
    };

    return (
        <div className='max-w-[95%] w-[600px]'>
            <div>
                <div className='justify-items-center CustomXXSM:text-[12px]'>
                    <Calendar
                        onChange={handleDateChange}
                        value={selectedDate}
                        tileClassName={({ date }) => {
                            const isActiveDay = userRoutes.some(route => {
                                const routeDate = normalizeDate(new Date(route.date));
                                return (
                                    routeDate.toDateString() === date.toDateString()
                                );
                            });
                            return isActiveDay ? 'react-calendar__tile--highlighted' : null;
                        }}
                    />
                </div>

            </div>
            <Modal
                isOpen={isModalOpen}
                onRequestClose={closeModal}
                contentLabel="Daily Activities"
                className="fixed bg-white z-50 w-[95%] max-w-[600px] h-auto p-[20px] rounded-[20px] top-[40%] left-[50%] translate-x-[-50%] translate-y-[-50%] "
                overlayClassName="fixed top-0 left-0 bg-black bg-opacity-60 w-full h-full"
            >
                <h2>Aktywności z dnia {selectedDate.toLocaleDateString()}</h2>
                {dailyActivities.length > 0 ? (
                    <ul>
                        {dailyActivities.map((activity, index) => (
                            <li key={index}>
                                {getTransportModeName(activity.transport_mode_id)} - {activity.distance_km} km - {activity.duration} - CO2: {activity.CO2} kg - kcal: {activity.kcal}
                            </li>
                        ))}
                    </ul>
                ) : (
                    <p>Brak aktywności na ten dzień.</p>
                )}
                <button className='bg-black text-white w-[150px] h-[60px] rounded-[10px] hover:scale-105' onClick={closeModal}>Zamknij</button>
            </Modal>
        </div>
    );
};

export default CalendarComponent;
