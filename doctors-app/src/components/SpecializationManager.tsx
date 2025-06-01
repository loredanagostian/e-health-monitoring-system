import { useEffect, useState } from "react";
import { Card, CardContent, CardHeader, CardTitle } from "../components/ui/card";
import { Button } from "../components/ui/button";
import { Input } from "../components/ui/input";
import { Badge } from "../components/ui/badge";
import { Plus, X, Edit2 } from "lucide-react";
import { toast } from "../hooks/use-toast";

interface Specialization {
  id: string;
  name: string;
}

export function SpecializationManager() {
  const [specializations, setSpecializations] = useState<Specialization[]>([]);

  const [newSpecialization, setNewSpecialization] = useState("");

  const doctorId = localStorage.getItem("doctorId");
  const token = localStorage.getItem("token");

  const baseUrl = "http://localhost:5200/api";

  useEffect(() => {
    if (!doctorId || !token) return; // Wait for both to be available

    const fetchSpecializations = async () => {
      try {
        const response = await fetch(`${baseUrl}/Specialization/GetSpecializationsByDoctor/${doctorId}`, {
          headers: {
            "Content-Type": "application/json",
            "Authorization": `Bearer ${token}`,
          },
        })
        const data = await response.json();

        // assuming the API returns [{ id, name, icon }]
        const formatted = data.map((spec: any) => ({
          id: spec.id,
          name: spec.name,
        }));

        setSpecializations(formatted);
      } catch (error) {
        toast({
          title: "Error",
          description: "Failed to load specializations",
          variant: "destructive",
        });
      }
    };

    if (doctorId) {
      fetchSpecializations();
    }
  }, [doctorId]);

  const addSpecialization = async () => {
    if (!newSpecialization.trim()) {
      toast({
        title: "Error",
        description: "Please provide a specialization name",
        variant: "destructive",
      });
      return;
    }

    try {
      const response = await fetch(`${baseUrl}/Specialization/AddToDoctor`, {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          "Authorization": `Bearer ${token}`,
        },
        body: JSON.stringify({
          doctorId: doctorId,
          specializationName: newSpecialization,
        }),
      });

      if (!response.ok) {
        throw new Error("Failed to add specialization");
      }

      const data = await response.json();

      const newSpec: Specialization = {
        id: Date.now().toString(), // You might want to use `data.specializationId` if returned
        name: newSpecialization,
      };

      setSpecializations([...specializations, newSpec]);
      setNewSpecialization("");
      toast({
        title: "Success",
        description: "Specialization added successfully",
      });
    } catch (error) {
      toast({
        title: "Error",
        description: "Failed to add specialization",
        variant: "destructive",
      });
      console.error(error);
    }
  };

  const removeSpecialization = async (specializationId: string) => {
    if (!doctorId || !token) return;

    try {
      const response = await fetch(
        `${baseUrl}/Specialization/DeleteFromDoctor/${doctorId}/${specializationId}`,
        {
          method: "DELETE",
          headers: {
            "Authorization": `Bearer ${token}`,
          },
        }
      );

      if (!response.ok) {
        throw new Error("Failed to delete specialization");
      }

      setSpecializations(prev =>
        prev.filter(spec => spec.id !== specializationId)
      );

      toast({
        title: "Success",
        description: "Specialization removed successfully",
      });
    } catch (error) {
      toast({
        title: "Error",
        description: (error as Error).message,
        variant: "destructive",
      });
    }
  };

  return (
    <Card>
      <CardHeader>
        <CardTitle className="flex items-center gap-2">
          <Plus className="h-5 w-5" />
          Manage Specializations
        </CardTitle>
      </CardHeader>
      <CardContent className="space-y-6">
        <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
          <Input
            placeholder="Specialization name"
            value={newSpecialization}
            onChange={(e) => setNewSpecialization(e.target.value)}
            className="md:col-span-2"
          />
          <div className="flex gap-2 md:col-span-1">
            <Button onClick={addSpecialization} className="flex-1">
              <Plus className="h-4 w-4 mr-2" />
              Add
            </Button>
          </div>
        </div>

        <div className="space-y-3">
          {specializations.map((spec) => (
            <div
              key={spec.id}
              className="flex items-center justify-between p-3 border rounded-lg hover:bg-slate-50"
            >
              <div className="flex items-center gap-3">
                <div>
                  <p className="font-medium text-slate-800">{spec.name}</p>
                </div>
              </div>
              <div className="flex gap-2">
                <Button
                  size="sm"
                  variant="destructive"
                  onClick={() => removeSpecialization(spec.id)}
                >
                  <X className="h-4 w-4" />
                </Button>
              </div>
            </div>
          ))}
        </div>
      </CardContent>
    </Card>
  );
}
