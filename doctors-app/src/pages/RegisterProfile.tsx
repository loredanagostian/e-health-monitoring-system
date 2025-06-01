import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Textarea } from "@/components/ui/textarea";
import { User, Edit } from "lucide-react";
import { useState } from "react";
import { useAuth } from "@/components/AuthProvider";
import { useNavigate } from "react-router-dom";

const RegisterProfile = () => {
    const [name, setName] = useState("");
    const [description, setDescription] = useState("");
    const [file, setFile] = useState<File | null>(null);
    const { authFetch } = useAuth();
    const navigate = useNavigate();

    const handleSubmit = async (e: React.FormEvent) => {
        e.preventDefault();

        const formData = new FormData();
        formData.append("Name", name);
        formData.append("Description", description);
        if (file != null) {
            formData.append("file", file);
        }

        const response = await authFetch("/api/Doctor/Add", {
            method: "POST",
            body: formData,
        });

        if (response.ok) {
            navigate("/");
        }

        console.log("big error");
    };

    return (
  <div className="w-full px-4 py-10 flex justify-center">
    <div className="w-full max-w-xl">
      <Card className="w-full">
        <CardHeader>
          <CardTitle className="flex items-center gap-2">
            <User className="h-5 w-5" />
            Profile Setup
          </CardTitle>
        </CardHeader>
        <CardContent className="space-y-6">
          <form onSubmit={handleSubmit} className="space-y-6">
            <div>
              <label htmlFor="fullName" className="text-sm font-medium">Full Name</label>
              <Input
                id="fullName"
                value={name}
                onChange={(e) => setName(e.target.value)}
                required
              />
            </div>

            <div>
              <label htmlFor="photo" className="text-sm font-medium">Profile Photo</label>
              <Input
                type="file"
                id="photo"
                onChange={(e) => setFile(e.target.files?.[0] || null)}
                required
              />
            </div>

            <div>
              <label htmlFor="bio" className="text-sm font-medium">Short Bio</label>
              <Textarea
                id="bio"
                rows={4}
                value={description}
                onChange={(e) => setDescription(e.target.value)}
              />
            </div>

            <Button type="submit" className="w-full">
              <Edit className="h-4 w-4 mr-2" />
              Save Profile
            </Button>
          </form>
        </CardContent>
      </Card>
    </div>
  </div>
);

};

export default RegisterProfile;
