
import { useState } from "react";
import { Card, CardContent, CardHeader, CardTitle } from "../components/ui/card";
import { Button } from "../components/ui/button";
import { Input } from "../components/ui/input";
import { Textarea } from "../components/ui/textarea";
import { Badge } from "../components/ui/badge";
import { Plus, X, Clock, DollarSign } from "lucide-react";
import { toast } from "../hooks/use-toast";

interface AppointmentType {
  id: string;
  name: string;
  duration: number;
  price: number;
  description: string;
  color: string;
}

export function AppointmentTypeManager() {
  const [appointmentTypes, setAppointmentTypes] = useState<AppointmentType[]>([
    {
      id: "1",
      name: "General Consultation",
      duration: 30,
      price: 150,
      description: "Standard medical consultation",
      color: "bg-blue-100 text-blue-800",
    },
    {
      id: "2",
      name: "Follow-up",
      duration: 15,
      price: 75,
      description: "Follow-up appointment for existing patients",
      color: "bg-green-100 text-green-800",
    },
    {
      id: "3",
      name: "Specialist Consultation",
      duration: 45,
      price: 250,
      description: "Specialized medical consultation",
      color: "bg-purple-100 text-purple-800",
    },
  ]);

  const [formData, setFormData] = useState({
    name: "",
    duration: "",
    price: "",
    description: "",
  });

  const colors = [
    "bg-blue-100 text-blue-800",
    "bg-green-100 text-green-800",
    "bg-purple-100 text-purple-800",
    "bg-orange-100 text-orange-800",
    "bg-pink-100 text-pink-800",
  ];

  const addAppointmentType = () => {
    if (!formData.name.trim() || !formData.duration || !formData.price) {
      toast({
        title: "Error",
        description: "Please fill in all required fields",
        variant: "destructive",
      });
      return;
    }

    const newType: AppointmentType = {
      id: Date.now().toString(),
      name: formData.name,
      duration: parseInt(formData.duration),
      price: parseFloat(formData.price),
      description: formData.description,
      color: colors[appointmentTypes.length % colors.length],
    };

    setAppointmentTypes([...appointmentTypes, newType]);
    setFormData({ name: "", duration: "", price: "", description: "" });
    toast({
      title: "Success",
      description: "Appointment type added successfully",
    });
  };

  const removeAppointmentType = (id: string) => {
    setAppointmentTypes(appointmentTypes.filter(type => type.id !== id));
    toast({
      title: "Success",
      description: "Appointment type removed successfully",
    });
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
        <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
          <Input
            placeholder="Appointment type name"
            value={formData.name}
            onChange={(e) => setFormData({ ...formData, name: e.target.value })}
          />
          <div className="grid grid-cols-2 gap-2">
            <Input
              type="number"
              placeholder="Duration (min)"
              value={formData.duration}
              onChange={(e) => setFormData({ ...formData, duration: e.target.value })}
            />
            <Input
              type="number"
              step="0.01"
              placeholder="Price ($)"
              value={formData.price}
              onChange={(e) => setFormData({ ...formData, price: e.target.value })}
            />
          </div>
          <Textarea
            placeholder="Description (optional)"
            value={formData.description}
            onChange={(e) => setFormData({ ...formData, description: e.target.value })}
          />
          <Button onClick={addAppointmentType} className="h-fit">
            <Plus className="h-4 w-4 mr-2" />
            Add Type
          </Button>
        </div>

        <div className="space-y-3">
          {appointmentTypes.map((type) => (
            <div
              key={type.id}
              className="flex items-center justify-between p-4 border rounded-lg hover:bg-slate-50"
            >
              <div className="flex-1">
                <div className="flex items-center gap-3 mb-2">
                  <Badge className={type.color}>{type.name}</Badge>
                  <div className="flex items-center gap-4 text-sm text-slate-600">
                    <span className="flex items-center gap-1">
                      <Clock className="h-4 w-4" />
                      {type.duration} min
                    </span>
                    <span className="flex items-center gap-1">
                      <DollarSign className="h-4 w-4" />
                      ${type.price}
                    </span>
                  </div>
                </div>
                {type.description && (
                  <p className="text-sm text-slate-600">{type.description}</p>
                )}
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
