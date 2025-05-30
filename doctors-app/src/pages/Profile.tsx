
import { SidebarProvider, SidebarTrigger } from "@/components/ui/sidebar";
import { DoctorSidebar } from "@/components/DoctorSidebar";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Textarea } from "@/components/ui/textarea";
import { Badge } from "@/components/ui/badge";
import { User, Mail, Phone, MapPin, Edit } from "lucide-react";

const Profile = () => {
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

            <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
              <Card className="lg:col-span-2">
                <CardHeader>
                  <CardTitle className="flex items-center gap-2">
                    <User className="h-5 w-5" />
                    Personal Information
                  </CardTitle>
                </CardHeader>
                <CardContent className="space-y-4">
                  <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                    <div>
                      <label className="text-sm font-medium">First Name</label>
                      <Input defaultValue="Dr. John" />
                    </div>
                    <div>
                      <label className="text-sm font-medium">Last Name</label>
                      <Input defaultValue="Smith" />
                    </div>
                  </div>
                  <div>
                    <label className="text-sm font-medium">Email</label>
                    <Input type="email" defaultValue="dr.john.smith@e-health-system.com" />
                  </div>
                  <div>
                    <label className="text-sm font-medium">Phone</label>
                    <Input type="tel" defaultValue="+1 (555) 123-4567" />
                  </div>
                  <div>
                    <label className="text-sm font-medium">Address</label>
                    <Textarea defaultValue="123 Medical Center Drive, Healthcare City, HC 12345" />
                  </div>
                  <div>
                    <label className="text-sm font-medium">Bio</label>
                    <Textarea 
                      defaultValue="Experienced physician with over 15 years in internal medicine. Specialized in cardiology and preventive care."
                      rows={4}
                    />
                  </div>
                  <Button className="w-full">
                    <Edit className="h-4 w-4 mr-2" />
                    Update Profile
                  </Button>
                </CardContent>
              </Card>

              <div className="space-y-6">
                <Card>
                  <CardHeader>
                    <CardTitle>Quick Info</CardTitle>
                  </CardHeader>
                  <CardContent className="space-y-3">
                    <div className="flex items-center gap-2 text-sm">
                      <Mail className="h-4 w-4 text-slate-500" />
                      <span>dr.john.smith@e-health-system.com</span>
                    </div>
                    <div className="flex items-center gap-2 text-sm">
                      <Phone className="h-4 w-4 text-slate-500" />
                      <span>+1 (555) 123-4567</span>
                    </div>
                    <div className="flex items-center gap-2 text-sm">
                      <MapPin className="h-4 w-4 text-slate-500" />
                      <span>Healthcare City, HC</span>
                    </div>
                  </CardContent>
                </Card>

                <Card>
                  <CardHeader>
                    <CardTitle>Specializations</CardTitle>
                  </CardHeader>
                  <CardContent>
                    <div className="flex flex-wrap gap-2">
                      <Badge>Cardiology</Badge>
                      <Badge>Internal Medicine</Badge>
                      <Badge>Preventive Care</Badge>
                    </div>
                  </CardContent>
                </Card>
              </div>
            </div>
          </div>
        </main>
      </div>
    </SidebarProvider>
  );
};

export default Profile;
