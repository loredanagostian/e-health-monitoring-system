
import { SidebarProvider, SidebarTrigger } from "@/components/ui/sidebar";
import { DoctorSidebar } from "@/components/DoctorSidebar";
import { SpecializationManager } from "@/components/SpecializationManager";
import { AppointmentTypeManager } from "@/components/AppointmentTypeManager";
import { AppointmentManager } from "@/components/AppointmentManager";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs";

const Index = () => {
  return (
    <SidebarProvider>
      <div className="min-h-screen flex w-full bg-slate-50">
        <DoctorSidebar />
        <main className="flex-1 p-6">
          <div className="max-w-7xl mx-auto">
            <div className="flex items-center gap-4 mb-8">
              <SidebarTrigger className="lg:hidden" />
              <div>
                <h1 className="text-3xl font-bold text-slate-800">Doctor Dashboard</h1>
                <p className="text-slate-600">Manage your practice efficiently</p>
              </div>
            </div>

            <Tabs defaultValue="appointments" className="space-y-6">
              <TabsList className="grid w-full grid-cols-3">
                <TabsTrigger value="appointments">Appointments</TabsTrigger>
                <TabsTrigger value="specializations">Specializations</TabsTrigger>
                <TabsTrigger value="appointment-types">Appointment Types</TabsTrigger>
              </TabsList>

              <TabsContent value="appointments">
                <AppointmentManager />
              </TabsContent>

              <TabsContent value="specializations">
                <SpecializationManager />
              </TabsContent>

              <TabsContent value="appointment-types">
                <AppointmentTypeManager />
              </TabsContent>
            </Tabs>
          </div>
        </main>
      </div>
    </SidebarProvider>
  );
};

export default Index;
