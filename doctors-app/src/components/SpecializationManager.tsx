import { useState, useEffect } from "react";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Plus, X } from "lucide-react";
import { toast } from "@/components/ui/use-toast";
import { SpecializationDropdown } from "./SpecializationDropdown";

interface Specialization {
  id: string;
  name: string;
  category?: string;
}

export function SpecializationManager() {
  const [specializations, setSpecializations] = useState<Specialization[]>([]);
  const [selectedName, setSelectedName] = useState("");
  const [isLoading, setIsLoading] = useState(false);

  const doctorId = localStorage.getItem("doctorId");

  // ✅ Reusable fetch function
  const fetchSpecializations = async () => {
    if (!doctorId) return;

    try {
      const response = await fetch(`/api/Specialization/GetSpecializationsByDoctor/${doctorId}`, {
        method: "GET",
        headers: { "Content-Type": "application/json" },
        credentials: "include",
      });

      if (!response.ok) throw new Error("Failed to fetch specializations");

      const data = await response.json();

      const seen = new Set<string>();
      const filtered = data.filter((spec: any) => {
        if (seen.has(spec.name)) return false;
        seen.add(spec.name);
        return true;
      });

      const formatted: Specialization[] = filtered.map((spec: any) => ({
        id: spec.id,
        name: spec.name,
        category: "", // No category from backend
      }));

      setSpecializations(formatted);
    } catch (err) {
      console.error("Fetch error:", err);
      toast({
        title: "Error",
        description: "Failed to load specializations from server",
        variant: "destructive",
      });
    }
  };

  useEffect(() => {
    fetchSpecializations();
  }, []);

  const removeSpecialization = async (id: string) => {
    const doctorId = localStorage.getItem("doctorId");
    if (!doctorId) return;

    try {
      const response = await fetch(`/api/Specialization/DeleteFromDoctor/${doctorId}/${id}`, {
        method: "DELETE",
        credentials: "include",
      });

      if (!response.ok) throw new Error("Failed to delete specialization");

      setSpecializations(prev => prev.filter(spec => spec.id !== id));

      toast({
        title: "Success",
        description: "Specialization removed from doctor",
      });
    } catch (error) {
      console.error("Delete error:", error);
      toast({
        title: "Error",
        description: "Could not remove specialization. Please try again.",
        variant: "destructive",
      });
    }
  };

  const handleAddToDoctor = async () => {
    if (!doctorId || !selectedName) {
      toast({
        title: "Error",
        description: "Please select a specialization from the dropdown",
        variant: "destructive",
      });
      return;
    }

    setIsLoading(true);
    try {
      const response = await fetch(`http://ehealth.edicz.com/api/Specialization/AddToDoctor`, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        credentials: "include",
        body: JSON.stringify({
          doctorId,
          specializationName: selectedName,
        }),
      });

      if (!response.ok) throw new Error("Failed to add specialization");

      toast({
        title: "Success",
        description: "Specialization added to doctor",
      });

      setSelectedName("");

      // ✅ Re-fetch updated list
      await fetchSpecializations();
    } catch (error) {
      console.error("Error:", error);
      toast({
        title: "Error",
        description: "Could not add specialization. Please try again.",
        variant: "destructive",
      });
    } finally {
      setIsLoading(false);
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
        {/* 🔹 Backend dropdown add */}
        <div className="flex items-center gap-4">
          <div className="flex-1">
            <SpecializationDropdown value={selectedName} onChange={setSelectedName} />
          </div>
          <Button disabled={!selectedName || isLoading} onClick={handleAddToDoctor}>
            <Plus className="h-4 w-4 mr-2" />
            {isLoading ? "Adding..." : "Add to Doctor"}
          </Button>
        </div>

        {/* 🔹 Existing list */}
        <div className="space-y-3">
          {specializations.map((spec) => (
            <div
              key={spec.id}
              className="flex items-center justify-between p-3 border rounded-lg hover:bg-slate-50"
            >
              <div className="flex items-center gap-3">
                <div>
                  <p className="font-medium text-slate-800">{spec.name}</p>
                  {spec.category && (
                    <p className="text-xs text-slate-500">{spec.category}</p>
                  )}
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
