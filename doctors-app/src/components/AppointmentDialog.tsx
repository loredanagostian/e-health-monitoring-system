import { useState } from "react";
import {
  Dialog,
  DialogContent,
  DialogHeader,
  DialogTitle,
} from "@/components/ui/dialog";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Textarea } from "@/components/ui/textarea";
import { Label } from "@/components/ui/label";
import { Calendar, User, FileText, Stethoscope } from "lucide-react";

interface Appointment {
  id: string;
  patientName: string;
  type: string;
  date: string;
  time: string;
  status: "upcoming" | "completed" | "cancelled";
  notes?: string;
  reasonToVisit?: string;
  medicalHistory?: string;
  diagnostic?: string;
  recommendations?: string;
}

interface AppointmentDialogProps {
  appointment: Appointment | null;
  isOpen: boolean;
  onClose: () => void;
  onUpdateAppointment: (id: string, updates: Partial<Appointment>) => void;
}

export function AppointmentDialog({
  appointment,
  isOpen,
  onClose,
  onUpdateAppointment,
}: AppointmentDialogProps) {
  const [diagnostic, setDiagnostic] = useState("");
  const [recommendations, setRecommendations] = useState("");

  if (!appointment) return null;

  const isUpcoming = appointment.status === "upcoming";
  const isPast = appointment.status === "completed";

  const handleSave = async () => {
    const formData = new FormData();
    formData.append("Id", appointment.id);
    formData.append("MedicalHistory", appointment.medicalHistory || "");
    formData.append("Diagnostic", diagnostic);
    formData.append("Recommendation", recommendations);

    try {
      const response = await fetch("/api/Appointment/Update", {
        method: "PATCH",
        body: formData,
      });

      if (!response.ok) {
        throw new Error("Failed to update appointment");
      }

      onUpdateAppointment(appointment.id, {
        diagnostic,
        recommendations,
      });
      onClose();
    } catch (error) {
      console.error("Update error:", error);
    }
  };

  const handleDelete = async () => {
    try {
      const response = await fetch(`/api/Appointment/Delete/${appointment.id}`, {
        method: "DELETE",
      });

      if (!response.ok) {
        throw new Error("Failed to delete appointment");
      }

      onUpdateAppointment(appointment.id, { status: "cancelled" }); // Or remove it from state
      onClose();
    } catch (error) {
      console.error("Delete error:", error);
    }
  };

  return (
    <Dialog open={isOpen} onOpenChange={onClose}>
      <DialogContent className="max-w-2xl max-h-[80vh] overflow-y-auto">
        <DialogHeader>
          <DialogTitle className="flex items-center gap-2">
            <User className="h-5 w-5" />
            Appointment Details - {appointment.patientName}
          </DialogTitle>
        </DialogHeader>

        <div className="space-y-6">
          {/* Basic Information */}
          <div className="grid grid-cols-2 gap-4">
            <div>
              <Label className="text-sm font-medium text-slate-700">Patient Name</Label>
              <Input value={appointment.patientName} readOnly className="bg-slate-50" />
            </div>
            <div>
              <Label className="text-sm font-medium text-slate-700">Reason to Visit</Label>
              <Input
                value={appointment.reasonToVisit || appointment.type}
                readOnly
                className="bg-slate-50"
              />
            </div>
          </div>

          <div className="grid grid-cols-2 gap-4">
            <div>
              <Label className="flex items-center gap-2 text-sm font-medium text-slate-700">
                <Calendar className="h-4 w-4" />
                Date
              </Label>
              <Input value={appointment.date} readOnly className="bg-slate-50" />
            </div>
            <div>
              <Label className="text-sm font-medium text-slate-700">Time</Label>
              <Input value={appointment.time} readOnly className="bg-slate-50" />
            </div>
          </div>

          {/* Medical History */}
          <div>
            <Label className="flex items-center gap-2 text-sm font-medium text-slate-700">
              <FileText className="h-4 w-4" />
              Medical History (Completed by Patient)
            </Label>
            <Textarea
              value={appointment.medicalHistory || "No medical history provided by patient."}
              readOnly
              className="bg-slate-50 min-h-[100px]"
            />
          </div>

          {/* Diagnostic (only for completed appointments) */}
          {isPast && (
            <div>
              <Label className="flex items-center gap-2 text-sm font-medium text-slate-700">
                <Stethoscope className="h-4 w-4" />
                Diagnostic (Doctor's Assessment)
              </Label>
              <Textarea
                placeholder="Enter your diagnostic assessment..."
                value={diagnostic}
                onChange={(e) => setDiagnostic(e.target.value)}
                className="min-h-[100px]"
              />
            </div>
          )}

          {/* Recommendations (only for completed appointments) */}
          {isPast && (
            <div>
              <Label className="text-sm font-medium text-slate-700">
                Recommendations (Doctor's Notes)
              </Label>
              <Textarea
                placeholder="Enter your recommendations and treatment plan..."
                value={recommendations}
                onChange={(e) => setRecommendations(e.target.value)}
                className="min-h-[100px]"
              />
            </div>
          )}

          {/* Action Buttons */}
          <div className="flex justify-end gap-3 pt-4 border-t">
            {isPast && (
              <Button onClick={handleSave} className="bg-green-600 hover:bg-green-700">
                Save
              </Button>
            )}
            {isUpcoming && (
              <Button variant="destructive" onClick={handleDelete}>
                Cancel Appointment
              </Button>
            )}
            <Button variant="outline" onClick={onClose}>
              Close
            </Button>
          </div>
        </div>
      </DialogContent>
    </Dialog>
  );
}
