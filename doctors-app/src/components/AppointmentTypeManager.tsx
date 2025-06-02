
import { useState, useEffect } from "react";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Badge } from "@/components/ui/badge";
import { Plus, X, Clock, DollarSign } from "lucide-react";
import { toast } from "@/hooks/use-toast";

interface AppointmentType {
  id: string;
  name: string;
  price: number;
  color: string;
}

export function AppointmentTypeManager() {
  const doctorId = localStorage.getItem("doctorId");
  const baseUrl = "https://ehealth.edicz.com/api/";

  const [appointmentTypes, setAppointmentTypes] = useState<AppointmentType[]>([]);
  const [formData, setFormData] = useState({ name: "", price: "", description: "" });

  const colors = [
    "bg-blue-100 text-blue-800",
    "bg-green-100 text-green-800",
    "bg-purple-100 text-purple-800",
    "bg-orange-100 text-orange-800",
    "bg-pink-100 text-pink-800",
  ];

  useEffect(() => {
    const fetchAppointmentTypes = async () => {
      try {
        const response = await fetch(`${baseUrl}AppointmentType/GetAppointmentsTypesByDoctor/${doctorId}`, {
          method: "GET",
          headers: {
            "Content-Type": "application/json",
          },
          credentials: "include",
        });
        if (!response.ok) throw new Error("Failed to fetch appointment types");
        const data = await response.json();

        const typed: AppointmentType[] = data.map((item: any, idx: number) => ({
          id: item.id,
          name: item.name,
          price: item.price,
          color: colors[idx % colors.length],
        }));

        setAppointmentTypes(typed);
      } catch (error) {
        console.error("Error fetching appointment types:", error);
        toast({
          title: "Error",
          description: "Could not load appointment types.",
          variant: "destructive",
        });
      }
    };

    fetchAppointmentTypes();
  }, [doctorId]);

  const addAppointmentType = async () => {
    if (!formData.name.trim() || !formData.price) {
      toast({
        title: "Error",
        description: "Please fill in all required fields",
        variant: "destructive",
      });
      return;
    }

    const payload = {
      name: formData.name.trim(),
      price: parseFloat(formData.price),
      doctorId: doctorId
    };

    try {
      const response = await fetch(`${baseUrl}AppointmentType/Add`, {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        credentials: "include",
        body: JSON.stringify(payload),
      });

      if (!response.ok) {
        throw new Error("Failed to create appointment type");
      }

      const saved = await response.json();

      console.log(saved);

      const newType: AppointmentType = {
        id: Date.now().toString(),
        name: formData.name,
        price: parseFloat(formData.price),
        color: colors[appointmentTypes.length % colors.length],
      };

      setAppointmentTypes([...appointmentTypes, newType]);
      setFormData({ name: "", price: "", description: "" });
      toast({
        title: "Success",
        description: "Appointment type added successfully",
      });
    } catch (error) {
      console.error("Error adding appointment type:", error);
      toast({
        title: "Error",
        description: "Failed to add appointment type. Please try again.",
        variant: "destructive",
      });
    }
  };

  const removeAppointmentType = async (id: string) => {
    try {
      const response = await fetch(`${baseUrl}AppointmentType/Delete/${id}`, {
        method: "DELETE",
        headers: {
          "Content-Type": "application/json",
        },
        credentials: "include",
      });

      if (!response.ok) {
        throw new Error("Failed to delete appointment type");
      }

      setAppointmentTypes((prev) => prev.filter((type) => type.id !== id));

      toast({
        title: "Success",
        description: "Appointment type removed successfully",
      });
    } catch (error) {
      console.error("Error deleting appointment type:", error);
      toast({
        title: "Error",
        description: "Failed to delete appointment type. Please try again.",
        variant: "destructive",
      });
    }
  };

  return (
    <Card>
      <CardHeader>
        <CardTitle className="flex items-center gap-2">
          <Clock className="h-5 w-5" />
          Appointment Types
        </CardTitle>
      </CardHeader>
      <CardContent className="space-y-6">
        <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
          <Input
            placeholder="Appointment type name"
            value={formData.name}
            onChange={(e) => setFormData({ ...formData, name: e.target.value })}
          />
          <Input
            type="number"
            step="1"
            placeholder="Price (RON)"
            value={formData.price}
            onChange={(e) => setFormData({ ...formData, price: e.target.value })}
          />
          <div className="flex gap-2">
            <Button onClick={addAppointmentType} className="w-full">
              <Plus className="h-4 w-4 mr-2" />
              Add
            </Button>
          </div>
        </div>

        <div className="space-y-3">
          {appointmentTypes.map((type) => (
            <div
              key={type.id}
              className="flex items-center justify-between p-4 border rounded-lg hover:bg-slate-50"
            >
              <div className="flex-1">
                <div className="flex items-center gap-3">
                  <Badge className={type.color}>{type.name}</Badge>
                  <div className="flex items-center gap-4 text-sm text-slate-600">
                    <span className="flex items-center gap-1">
                      {type.price} LEI
                    </span>
                  </div>
                </div>
              </div>
              <Button
                size="sm"
                variant="destructive"
                onClick={() => removeAppointmentType(type.id)}
              >
                <X className="h-4 w-4" />
              </Button>
            </div>
          ))}
        </div>
      </CardContent>
    </Card>
  );
}
