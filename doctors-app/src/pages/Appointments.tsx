
import { SidebarProvider, SidebarTrigger } from "@/components/ui/sidebar";
import { DoctorSidebar } from "@/components/DoctorSidebar";
import { AppointmentManager } from "@/components/AppointmentManager";

const Appointments = () => {
  return (
    <SidebarProvider>
      <div className="min-h-screen flex w-full bg-slate-50">
        <DoctorSidebar />
        <main className="flex-1 p-6">
          <div className="max-w-7xl mx-auto">
            <div className="flex items-center gap-4 mb-8">
              <SidebarTrigger className="lg:hidden" />
              <div>
                <h1 className="text-3xl font-bold text-slate-800">Appointments</h1>
                <p className="text-slate-600">Manage your patient appointments</p>
              </div>
            </div>
            <AppointmentManager />
          </div>
        </main>
      </div>
    </SidebarProvider>
  );
};

export default Appointments;
