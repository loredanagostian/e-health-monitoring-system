import { useEffect, useState } from "react";
import { Card, CardContent, CardHeader, CardTitle } from "../components/ui/card";
import { Button } from "../components/ui/button";
import { Input } from "../components/ui/input";
import { Textarea } from "../components/ui/textarea";
import { Badge } from "../components/ui/badge";
import { Calendar, Clock, User, FileText, Edit2, Plus } from "lucide-react";
import { toast } from "../hooks/use-toast";

interface Appointment {
  id: string;
  patientName: string;
  type: string;
  date: string;
  time: string;
  status: "upcoming" | "completed" | "cancelled";
  notes?: string;
}

export function AppointmentManager() {
  const doctorId = localStorage.getItem("doctorId");
  const token = localStorage.getItem("token");
  const [appointments, setAppointments] = useState<Appointment[]>([]);
  const [editingId, setEditingId] = useState<string | null>(null);
  const [editNotes, setEditNotes] = useState("");
  const [newAppointment, setNewAppointment] = useState({
    patientName: "",
    type: "General Consultation",
    date: "",
    time: "",
  });

  const baseUrl = "http://localhost:5200/api"; // Replace with your API base URL

  useEffect(() => {
    const fetchAppointments = async () => {
      try {
        const [futureRes, pastRes] = await Promise.all([
          fetch(`${baseUrl}/Appointment/GetDoctorAppointments/${doctorId}?time=future`, {
            method: "GET",
            headers: {
              "Content-Type": "application/json",
              "Authorization": `Bearer ${token}`,
            },
            credentials: "include",
          }),
          fetch(`${baseUrl}/Appointment/GetDoctorAppointments/${doctorId}?time=past`, {
            method: "GET",
            headers: {
              "Content-Type": "application/json",
              "Authorization": `Bearer ${token}`,
            },
            credentials: "include",
          }),
        ]);

        const futureData = await futureRes.json();
        console.log("Future appointments data:", futureData);
      
        const pastData = await pastRes.json();
        console.log("Past appointments data:", pastData);

        const format = (data: any[], status: "upcoming" | "completed"): Appointment[] =>
          data.map((item) => {
            const dateObj = new Date(item.date);
            return {
              id: item.id,
              patientName: item.userName,
              type: item.appointmentType,
              date: dateObj.toISOString().split("T")[0],
              time: dateObj.toISOString().split("T")[1].slice(0, 5),
              status,
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
  }, []);

  const updateAppointment = (id: string, updates: Partial<Appointment>) => {
    setAppointments(appointments.map(apt => 
      apt.id === id ? { ...apt, ...updates } : apt
    ));
    toast({
      title: "Success",
      description: "Appointment updated successfully",
    });
  };

  const addAppointment = () => {
    if (!newAppointment.patientName || !newAppointment.date || !newAppointment.time) {
      toast({
        title: "Error",
        description: "Please fill in all required fields",
        variant: "destructive",
      });
      return;
    }

    const appointment: Appointment = {
      id: Date.now().toString(),
      ...newAppointment,
      status: "upcoming",
    };

    setAppointments([...appointments, appointment]);
    setNewAppointment({ patientName: "", type: "General Consultation", date: "", time: "" });
    toast({
      title: "Success",
      description: "Appointment scheduled successfully",
    });
  };

  const saveNotes = (id: string) => {
    updateAppointment(id, { notes: editNotes });
    setEditingId(null);
    setEditNotes("");
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
                className="flex items-center justify-between p-4 border rounded-lg hover:bg-slate-50"
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
                <div className="flex gap-2">
                  <Button
                    size="sm"
                    onClick={() => updateAppointment(appointment.id, { status: "completed" })}
                  >
                    Mark Complete
                  </Button>
                  <Button
                    size="sm"
                    variant="outline"
                    onClick={() => updateAppointment(appointment.id, { status: "cancelled" })}
                  >
                    Cancel
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
                  <Button
                    size="sm"
                    variant="outline"
                    onClick={() => {
                      setEditingId(appointment.id);
                      setEditNotes(appointment.notes || "");
                    }}
                  >
                    <Edit2 className="h-4 w-4 mr-2" />
                    Add/Edit Notes
                  </Button>
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

                {editingId === appointment.id ? (
                  <div className="space-y-3">
                    <Textarea
                      placeholder="Add notes about this appointment..."
                      value={editNotes}
                      onChange={(e) => setEditNotes(e.target.value)}
                    />
                    <div className="flex gap-2">
                      <Button onClick={() => saveNotes(appointment.id)}>
                        Save Notes
                      </Button>
                      <Button variant="outline" onClick={() => setEditingId(null)}>
                        Cancel
                      </Button>
                    </div>
                  </div>
                ) : (
                  appointment.notes && (
                    <div className="bg-slate-50 p-3 rounded-md">
                      <p className="text-sm text-slate-700">{appointment.notes}</p>
                    </div>
                  )
                )}
              </div>
            ))}
          </div>
        </CardContent>
      </Card>
    </div>
  );
}
