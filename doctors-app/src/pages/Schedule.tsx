
import { SidebarProvider, SidebarTrigger } from "@/components/ui/sidebar";
import { DoctorSidebar } from "@/components/DoctorSidebar";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Calendar, Clock, Plus } from "lucide-react";

const Schedule = () => {
  return (
    <SidebarProvider>
      <div className="min-h-screen flex w-full bg-slate-50">
        <DoctorSidebar />
        <main className="flex-1 p-6">
          <div className="max-w-7xl mx-auto">
            <div className="flex items-center gap-4 mb-8">
              <SidebarTrigger className="lg:hidden" />
              <div>
                <h1 className="text-3xl font-bold text-slate-800">Schedule</h1>
                <p className="text-slate-600">Manage your working hours and availability</p>
              </div>
            </div>

            <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
              <Card>
                <CardHeader>
                  <CardTitle className="flex items-center gap-2">
                    <Calendar className="h-5 w-5" />
                    Weekly Schedule
                  </CardTitle>
                </CardHeader>
                <CardContent>
                  <div className="space-y-4">
                    {['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'].map((day) => (
                      <div key={day} className="flex items-center justify-between p-3 border rounded-lg">
                        <span className="font-medium">{day}</span>
                        <div className="flex items-center gap-2 text-sm text-slate-600">
                          <Clock className="h-4 w-4" />
                          <span>9:00 AM - 5:00 PM</span>
                        </div>
                      </div>
                    ))}
                  </div>
                  <Button className="w-full mt-4">
                    <Plus className="h-4 w-4 mr-2" />
                    Add Working Hours
                  </Button>
                </CardContent>
              </Card>

              <Card>
                <CardHeader>
                  <CardTitle className="flex items-center gap-2">
                    <Clock className="h-5 w-5" />
                    Time Slots
                  </CardTitle>
                </CardHeader>
                <CardContent>
                  <div className="space-y-3">
                    <div className="p-3 border rounded-lg">
                      <p className="font-medium">30-minute slots</p>
                      <p className="text-sm text-slate-600">Standard consultation duration</p>
                    </div>
                    <div className="p-3 border rounded-lg">
                      <p className="font-medium">15-minute buffer</p>
                      <p className="text-sm text-slate-600">Time between appointments</p>
                    </div>
                    <div className="p-3 border rounded-lg">
                      <p className="font-medium">1-hour lunch break</p>
                      <p className="text-sm text-slate-600">12:00 PM - 1:00 PM</p>
                    </div>
                  </div>
                  <Button className="w-full mt-4" variant="outline">
                    Customize Time Slots
                  </Button>
                </CardContent>
              </Card>
            </div>
          </div>
        </main>
      </div>
    </SidebarProvider>
  );
};

export default Schedule;
