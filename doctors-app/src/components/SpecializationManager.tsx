
import { useState } from "react";
import { Card, CardContent, CardHeader, CardTitle } from "../components/ui/card";
import { Button } from "../components/ui/button";
import { Input } from "../components/ui/input";
import { Badge } from "../components/ui/badge";
import { Plus, X, Edit2 } from "lucide-react";
import { toast } from "../hooks/use-toast";

interface Specialization {
  id: string;
  name: string;
  category: string;
}

export function SpecializationManager() {
  const [specializations, setSpecializations] = useState<Specialization[]>([
    { id: "1", name: "Cardiology", category: "Internal Medicine" },
    { id: "2", name: "Dermatology", category: "Surgical" },
    { id: "3", name: "Pediatrics", category: "Primary Care" },
  ]);

  const [newSpecialization, setNewSpecialization] = useState("");
  const [newCategory, setNewCategory] = useState("");
  const [editingId, setEditingId] = useState<string | null>(null);

  const addSpecialization = () => {
    if (!newSpecialization.trim() || !newCategory.trim()) {
      toast({
        title: "Error",
        description: "Please fill in both specialization name and category",
        variant: "destructive",
      });
      return;
    }

    const newSpec: Specialization = {
      id: Date.now().toString(),
      name: newSpecialization,
      category: newCategory,
    };

    setSpecializations([...specializations, newSpec]);
    setNewSpecialization("");
    setNewCategory("");
    toast({
      title: "Success",
      description: "Specialization added successfully",
    });
  };

  const removeSpecialization = (id: string) => {
    setSpecializations(specializations.filter(spec => spec.id !== id));
    toast({
      title: "Success",
      description: "Specialization removed successfully",
    });
  };

  const startEdit = (spec: Specialization) => {
    setEditingId(spec.id);
    setNewSpecialization(spec.name);
    setNewCategory(spec.category);
  };

  const saveEdit = () => {
    if (!newSpecialization.trim() || !newCategory.trim()) return;

    setSpecializations(specializations.map(spec => 
      spec.id === editingId 
        ? { ...spec, name: newSpecialization, category: newCategory }
        : spec
    ));

    setEditingId(null);
    setNewSpecialization("");
    setNewCategory("");
    toast({
      title: "Success",
      description: "Specialization updated successfully",
    });
  };

  const cancelEdit = () => {
    setEditingId(null);
    setNewSpecialization("");
    setNewCategory("");
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
          />
          <Input
            placeholder="Category"
            value={newCategory}
            onChange={(e) => setNewCategory(e.target.value)}
          />
          <div className="flex gap-2">
            {editingId ? (
              <>
                <Button onClick={saveEdit} className="flex-1">
                  Save
                </Button>
                <Button onClick={cancelEdit} variant="outline">
                  Cancel
                </Button>
              </>
            ) : (
              <Button onClick={addSpecialization} className="flex-1">
                <Plus className="h-4 w-4 mr-2" />
                Add
              </Button>
            )}
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
                  <Badge variant="secondary" className="text-xs">
                    {spec.category}
                  </Badge>
                </div>
              </div>
              <div className="flex gap-2">
                <Button
                  size="sm"
                  variant="outline"
                  onClick={() => startEdit(spec)}
                >
                  <Edit2 className="h-4 w-4" />
                </Button>
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
