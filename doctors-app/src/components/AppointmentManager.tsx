import { useEffect, useState } from "react";
import { Card, CardContent, CardHeader, CardTitle } from "../components/ui/card";
import { Button } from "../components/ui/button";
import { Badge } from "../components/ui/badge";
import { Calendar, Clock, User, FileText, Edit2, Plus } from "lucide-react";
import { toast } from "../hooks/use-toast";
import { AppointmentDialog } from "./AppointmentDialog";
import { useAuth } from "./AuthProvider";

interface Appointment {
  id: string;
  patientName: string;
  type: string;
  date: string;
  time: string;
  status: "upcoming" | "completed" | "cancelled";
  reasonToVisit?: string;
  medicalHistory?: string;
  diagnostic?: string;
  recommendations?: string;
}

export function AppointmentManager() {
  const doctorId = localStorage.getItem("doctorId");
  const token = localStorage.getItem("token");

  console.log("token = ", token);

  const [appointments, setAppointments] = useState<Appointment[]>([]);
  const [selectedAppointment, setSelectedAppointment] = useState<Appointment | null>(null);
  const [isDialogOpen, setIsDialogOpen] = useState(false)
  const { authFetch } = useAuth();


  useEffect(() => {
    if (!doctorId || !token) return; // Wait for both to be available

    const fetchAppointments = async () => {
      try {
        const [futureRes, pastRes] = await Promise.all([
          authFetch(`/api/Appointment/GetDoctorAppointments/${doctorId}?time=future`),
          authFetch(`/api/Appointment/GetDoctorAppointments/${doctorId}?time=past`),
        ]);

        if (!futureRes.ok || !pastRes.ok) {
          throw new Error("Unauthorized or failed to fetch");
        }

        const futureData = await futureRes.json();
        const pastData = await pastRes.json();

        const format = (data: any[], status: "upcoming" | "completed"): Appointment[] =>
          data.map((item) => {
            const dateObj = new Date(item.date);
            const formattedDate = dateObj.toLocaleDateString("en-CA");
            const formattedTime = dateObj.toLocaleTimeString("en-GB", {
                  hour: "2-digit",
                  minute: "2-digit",
                  hour12: false,
                });

            return {
              id: item.id,
              patientName: item.userName,
              type: item.appointmentType,
              date: formattedDate,
              time: formattedTime,
              status,
              medicalHistory: item.medicalHistory || "",
            };
          });

        setAppointments([...format(futureData, "upcoming"), ...format(pastData, "completed")]);
      } catch (error) {
        toast({
          title: "Error",
          description: "Failed to load appointments.",
          variant: "destructive",
        });
        console.error("Failed to fetch appointments:", error);
      }
    };

    fetchAppointments();
  }, [doctorId, token]);

  const handleAppointmentClick = (appointment: Appointment) => {
    setSelectedAppointment(appointment);
    setIsDialogOpen(true);
  };

  const updateAppointment = (id: string, updates: Partial<Appointment>) => {
    setAppointments(appointments.map(apt =>
      apt.id === id ? { ...apt, ...updates } : apt
    ));
    toast({
      title: "Success",
      description: "Appointment updated successfully",
    });
  };

  const getStatusColor = (status: string) => {
    switch (status) {
      case "upcoming":
        return "bg-blue-100 text-blue-800";
      case "completed":
        return "bg-green-100 text-green-800";
      case "cancelled":
        return "bg-red-100 text-red-800";
      default:
        return "bg-gray-100 text-gray-800";
    }
  };

  const upcomingAppointments = appointments.filter(apt => apt.status === "upcoming");
  const pastAppointments = appointments.filter(apt => apt.status === "completed");

  return (
    <div className="space-y-6">
      {/* Upcoming Appointments */}
      <Card>
        <CardHeader>
          <CardTitle className="flex items-center gap-2">
            <Calendar className="h-5 w-5" />
            Upcoming Appointments
          </CardTitle>
        </CardHeader>
        <CardContent>
          <div className="space-y-3">
            {upcomingAppointments.map((appointment) => (
              <div
                key={appointment.id}
                className="flex items-center justify-between p-4 border rounded-lg"
              >
                <div className="flex-1">
                  <div className="flex items-center gap-3 mb-2">
                    <h4 className="font-medium text-slate-800">{appointment.patientName}</h4>
                    <Badge className={getStatusColor(appointment.status)}>
                      {appointment.status}
                    </Badge>
                  </div>
                  <div className="flex items-center gap-4 text-sm text-slate-600">
                    <span className="flex items-center gap-1">
                      <User className="h-4 w-4" />
                      {appointment.type}
                    </span>
                    <span className="flex items-center gap-1">
                      <Calendar className="h-4 w-4" />
                      {appointment.date}
                    </span>
                    <span className="flex items-center gap-1">
                      <Clock className="h-4 w-4" />
                      {appointment.time}
                    </span>
                  </div>
                </div>
                <div className="flex gap-2" onClick={(e) => e.stopPropagation()}>
                  <Button
                    size="sm"
                    variant="outline"
                    onClick={() => handleAppointmentClick(appointment)}
                  >
                    View Details
                  </Button>
                </div>
              </div>
            ))}
          </div>
        </CardContent>
      </Card>

      {/* Past Appointments */}
      <Card>
        <CardHeader>
          <CardTitle className="flex items-center gap-2">
            <FileText className="h-5 w-5" />
            Past Appointments
          </CardTitle>
        </CardHeader>
        <CardContent>
          <div className="space-y-3">
            {pastAppointments.map((appointment) => (
              <div
                key={appointment.id}
                className="p-4 border rounded-lg"
              >
                <div className="flex items-center justify-between mb-3">
                  <div className="flex items-center gap-3">
                    <h4 className="font-medium text-slate-800">{appointment.patientName}</h4>
                    <Badge className={getStatusColor(appointment.status)}>
                      {appointment.status}
                    </Badge>
                  </div>
                  <div className="flex gap-2" onClick={(e) => e.stopPropagation()}>
                    <Button
                      size="sm"
                      variant="outline"
                      onClick={() => handleAppointmentClick(appointment)}
                    >
                      View Details
                    </Button>
                  </div>
                </div>

                <div className="flex items-center gap-4 text-sm text-slate-600 mb-3">
                  <span className="flex items-center gap-1">
                    <User className="h-4 w-4" />
                    {appointment.type}
                  </span>
                  <span className="flex items-center gap-1">
                    <Calendar className="h-4 w-4" />
                    {appointment.date}
                  </span>
                  <span className="flex items-center gap-1">
                    <Clock className="h-4 w-4" />
                    {appointment.time}
                  </span>
                </div>
              </div>
            ))}
          </div>
        </CardContent>
      </Card>

      <AppointmentDialog
        appointment={selectedAppointment}
        isOpen={isDialogOpen}
        onClose={() => {
          setIsDialogOpen(false);
          setSelectedAppointment(null);
        }}
        onUpdateAppointment={updateAppointment}
      />
    </div>
  );
}
