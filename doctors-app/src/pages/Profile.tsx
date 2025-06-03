import { useEffect, useState } from "react";
import { SidebarProvider, SidebarTrigger } from "@/components/ui/sidebar";
import { DoctorSidebar } from "@/components/DoctorSidebar";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Textarea } from "@/components/ui/textarea";
import { Badge } from "@/components/ui/badge";
import { User, Edit, X } from "lucide-react";
import { toast } from "@/components/ui/use-toast";

interface Specialization {
  id: string;
  name: string;
}

interface DoctorData {
  id: string;
  name: string;
  description: string;
  picture: string;
  specializations: Specialization[];
}

const Profile = () => {
  const [doctor, setDoctor] = useState<DoctorData | null>(null);
  const [fullName, setFullName] = useState("");
  const [description, setDescription] = useState("");
  const [selectedFile, setSelectedFile] = useState<File | null>(null);
  const [previewUrl, setPreviewUrl] = useState<string | null>(null);
  const [isSubmitting, setIsSubmitting] = useState(false);

  useEffect(() => {
    const fetchDoctor = async () => {
      const doctorId = localStorage.getItem("doctorId");
      if (!doctorId) return;

      try {
        const response = await fetch(`/api/Doctor/GetInfoById/${doctorId}`, {
          method: "GET",
          headers: { "Content-Type": "application/json" },
          credentials: "include",
        });

        if (!response.ok) throw new Error("Failed to fetch doctor info");

        const data = await response.json();
        setDoctor(data);
        setFullName(data.name);
        setDescription(data.description);
      } catch (error) {
        console.error("Fetch error:", error);
        toast({
          title: "Error",
          description: "Could not load profile information.",
          variant: "destructive",
        });
      }
    };

    fetchDoctor();
  }, []);

  useEffect(() => {
    if (selectedFile) {
      const url = URL.createObjectURL(selectedFile);
      setPreviewUrl(url);
      return () => URL.revokeObjectURL(url);
    } else {
      setPreviewUrl(null);
    }
  }, [selectedFile]);

  const hasChanged =
    doctor &&
    (fullName.trim() !== doctor.name.trim() ||
      description.trim() !== doctor.description.trim());

   const handleUpdate = async () => {
    if (!doctor) return;

    const formData = new FormData();
    formData.append("Id", doctor.id);
    formData.append("Name", fullName);
    formData.append("Description", description);
    if (selectedFile) {
      formData.append("picture", selectedFile);
    }

    setIsSubmitting(true);
    try {
      const response = await fetch("/api/Doctor/Update", {
        method: "PATCH",
        body: formData,
        credentials: "include",
      });

      if (!response.ok) throw new Error("Update failed");

      const updatedDoctor = await response.json();
      setDoctor(updatedDoctor);
      setSelectedFile(null);
      toast({
        title: "Success",
        description: "Profile updated successfully.",
      });
    } catch (error) {
      console.error("Update error:", error);
      toast({
        title: "Error",
        description: "Failed to update profile.",
        variant: "destructive",
      });
    } finally {
      setIsSubmitting(false);
    }
  };

  return (
    <SidebarProvider>
      <div className="min-h-screen flex w-full bg-slate-50">
        <DoctorSidebar />
        <main className="flex-1 p-6">
          <div className="max-w-4xl mx-auto">
            <div className="flex items-center gap-4 mb-8">
              <SidebarTrigger className="lg:hidden" />
              <div>
                <h1 className="text-3xl font-bold text-slate-800">Profile</h1>
                <p className="text-slate-600">Manage your professional information</p>
              </div>
            </div>

            {doctor && (
              <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
                <Card className="lg:col-span-2">
                  <CardHeader>
                    <div className="flex justify-center">
                      <img
                        src={previewUrl || doctor.picture}
                        alt="Doctor profile"
                        className="w-32 h-32 rounded-full object-cover border"
                      />
                    </div>
                    <CardTitle className="flex items-center gap-2">
                      <User className="h-5 w-5" />
                      Personal Information
                    </CardTitle>
                  </CardHeader>
                  <CardContent className="space-y-4">
                    <div className="grid grid-cols-1 gap-4">
                      <div className="md:col-span-2">
                        <label className="text-sm font-medium">Full Displayed Name</label>
                        <Input
                          value={fullName}
                          onChange={(e) => setFullName(e.target.value)}
                        />
                      </div>
                    </div>
                    <div>
                        <label className="text-sm font-medium">Change Profile Picture</label>
                        <div className="flex items-center gap-2">
                          <Input
                            type="file"
                            accept="image/*"
                            onChange={(e) => {
                              const file = e.target.files?.[0];
                              if (file) setSelectedFile(file);
                            }}
                          />
                          {selectedFile && (
                            <Button
                              type="button"
                              variant="outline"
                              size="icon"
                              onClick={() => setSelectedFile(null)}
                              title="Remove file"
                            >
                              <X className="w-4 h-4" />
                            </Button>
                          )}
                        </div>
                      </div>
                    <div>
                      <label className="text-sm font-medium">Description</label>
                      <Textarea
                        value={description}
                        onChange={(e) => setDescription(e.target.value)}
                        rows={4}
                      />
                    </div>
                    <Button
                      className="w-full"
                      onClick={handleUpdate}
                      disabled={!hasChanged && !selectedFile || isSubmitting}
                    >
                      <Edit className="h-4 w-4 mr-2" />
                      {isSubmitting ? "Updating..." : "Update Profile"}
                    </Button>
                  </CardContent>
                </Card>

                <div className="space-y-6">
                  <Card>
                    <CardHeader>
                      <CardTitle>Specializations</CardTitle>
                    </CardHeader>
                    <CardContent>
                      <div className="flex flex-wrap gap-2">
                        {doctor.specializations.map((spec) => (
                          <Badge key={spec.id}>{spec.name}</Badge>
                        ))}
                      </div>
                    </CardContent>
                  </Card>
                </div>
              </div>
            )}
          </div>
        </main>
      </div>
    </SidebarProvider>
  );
};

export default Profile;
