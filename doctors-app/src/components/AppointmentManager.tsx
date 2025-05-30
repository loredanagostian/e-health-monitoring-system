
import { useState } from "react";
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
  const [appointments, setAppointments] = useState<Appointment[]>([
    {
      id: "1",
      patientName: "John Smith",
      type: "General Consultation",
      date: "2024-05-31",
      time: "09:00",
      status: "upcoming",
    },
    {
      id: "2",
      patientName: "Sarah Johnson",
      type: "Follow-up",
      date: "2024-05-30",
      time: "14:30",
      status: "completed",
      notes: "Patient showed improvement. Continue current medication.",
    },
    {
      id: "3",
      patientName: "Mike Davis",
      type: "Specialist Consultation",
      date: "2024-05-31",
      time: "11:00",
      status: "upcoming",
    },
  ]);

  const [editingId, setEditingId] = useState<string | null>(null);
  const [editNotes, setEditNotes] = useState("");
  const [newAppointment, setNewAppointment] = useState({
    patientName: "",
    type: "General Consultation",
    date: "",
    time: "",
  });

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
      {/* Add New Appointment */}
      <Card>
        <CardHeader>
          <CardTitle className="flex items-center gap-2">
            <Plus className="h-5 w-5" />
            Schedule New Appointment
          </CardTitle>
        </CardHeader>
        <CardContent>
          <div className="grid grid-cols-1 md:grid-cols-4 gap-4">
            <Input
              placeholder="Patient name"
              value={newAppointment.patientName}
              onChange={(e) => setNewAppointment({ ...newAppointment, patientName: e.target.value })}
            />
            <select
              className="flex h-10 w-full rounded-md border border-input bg-background px-3 py-2 text-sm ring-offset-background"
              value={newAppointment.type}
              onChange={(e) => setNewAppointment({ ...newAppointment, type: e.target.value })}
            >
              <option>General Consultation</option>
              <option>Follow-up</option>
              <option>Specialist Consultation</option>
            </select>
            <Input
              type="date"
              value={newAppointment.date}
              onChange={(e) => setNewAppointment({ ...newAppointment, date: e.target.value })}
            />
            <div className="flex gap-2">
              <Input
                type="time"
                value={newAppointment.time}
                onChange={(e) => setNewAppointment({ ...newAppointment, time: e.target.value })}
              />
              <Button onClick={addAppointment}>
                Add
              </Button>
            </div>
          </div>
        </CardContent>
      </Card>

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
