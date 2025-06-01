

import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Textarea } from "@/components/ui/textarea";
import { User, Mail, Phone, MapPin, Edit } from "lucide-react";
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
        formData.append('Name', name);
        formData.append('Description', description);
        if (file != null) {
            formData.append('file', file);
        }
        const response = await authFetch("/api/Doctor/Add", {
            method: 'POST',
            body: formData
        })

        if (response.ok) {
            navigate("/");
        }
        console.log("big error");

    };

    return (
        <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
            <Card className="lg:col-span-2">
                <CardHeader>
                    <CardTitle className="flex items-center gap-2">
                        <User className="h-5 w-5" />
                        Personal Information
                    </CardTitle>
                </CardHeader>
                <CardContent className="space-y-4">
                    <form onSubmit={handleSubmit} className="space-y-4">
                        <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                            <div>
                                <label className="text-sm font-medium">First Name</label>
                                <Input id="firsName" onChange={(e) => setName(e.target.value)} required />
                            </div>
                            <div>
                                <label className="text-sm font-medium">Last Name</label>
                                <Input id="lastName" />
                            </div>
                        </div>
                        <div>
                            <label className="text-sm font-medium">Email</label>
                            <Input type="email" />
                        </div>
                        <div>
                            <label className="text-sm font-medium">Phone</label>
                            <Input type="tel" />
                        </div>
                        <div>
                            <label className="text-sm font-medium">Photo</label>
                            <Input type="file" onChange={(e) => setFile(e.target.files![0])} required />
                        </div>
                        <div>
                            <label className="text-sm font-medium">Address</label>
                            <Textarea />
                        </div>
                        <div>
                            <label className="text-sm font-medium">Bio</label>
                            <Textarea
                                rows={4}
                                onChange={(e) => setDescription(e.target.value)}
                            />
                        </div>
                        <Button className="w-full">
                            <Edit className="h-4 w-4 mr-2" />
                            Update Profile
                        </Button>
                    </form>
                </CardContent>
            </Card>
        </div>
    );
};

export default RegisterProfile;
