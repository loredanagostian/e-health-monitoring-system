import { useEffect, useState } from "react";
import { toast } from "@/components/ui/use-toast";

interface Specialization {
  id: string;
  name: string;
}

interface Props {
  value: string;
  onChange: (name: string) => void;
}

export const SpecializationDropdown = ({ value, onChange }: Props) => {
  const [specializations, setSpecializations] = useState<Specialization[]>([]);

  useEffect(() => {
    const fetchSpecializations = async () => {
      try {
        const response = await fetch("/api/Specialization/GetAll", {
          method: "GET",
          headers: {
            "Content-Type": "application/json",
          },
          credentials: "include",
        });

        if (!response.ok) throw new Error("Failed to fetch specializations");

        const data = await response.json();
        setSpecializations(data);
      } catch (error) {
        console.error("Fetch error:", error);
        toast({
          title: "Error",
          description: "Could not load specializations.",
          variant: "destructive",
        });
      }
    };

    fetchSpecializations();
  }, []);

  return (
    <select
        value={value}
        onChange={(e) => {
            const selected = specializations.find(s => s.id === e.target.value);
            if (selected) onChange(selected.name);
        }}
        className="w-full px-4 pr-10 py-2 border border-slate-300 rounded-md shadow-sm focus:outline-none focus:ring-2 focus:ring-sky-500"
    >
        <option value="">-- Select Specialization --</option>
        {specializations.map((spec) => (
            <option key={spec.id} value={spec.id}>
            {spec.name}
            </option>
        ))}
    </select>
  );
};
