
import { SidebarProvider, SidebarTrigger } from "@/components/ui/sidebar";
import { DoctorSidebar } from "@/components/DoctorSidebar";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Switch } from "@/components/ui/switch";
import { Settings as SettingsIcon, Bell, Shield, Palette } from "lucide-react";

const Settings = () => {
  return (
    <SidebarProvider>
      <div className="min-h-screen flex w-full bg-slate-50">
        <DoctorSidebar />
        <main className="flex-1 p-6">
          <div className="max-w-4xl mx-auto">
            <div className="flex items-center gap-4 mb-8">
              <SidebarTrigger className="lg:hidden" />
              <div>
                <h1 className="text-3xl font-bold text-slate-800">Settings</h1>
                <p className="text-slate-600">Configure your application preferences</p>
              </div>
            </div>

            <div className="space-y-6">
              <Card>
                <CardHeader>
                  <CardTitle className="flex items-center gap-2">
                    <Bell className="h-5 w-5" />
                    Notifications
                  </CardTitle>
                </CardHeader>
                <CardContent className="space-y-4">
                  <div className="flex items-center justify-between">
                    <div>
                      <p className="font-medium">Email Notifications</p>
                      <p className="text-sm text-slate-600">Receive notifications via email</p>
                    </div>
                    <Switch defaultChecked />
                  </div>
                  <div className="flex items-center justify-between">
                    <div>
                      <p className="font-medium">Appointment Reminders</p>
                      <p className="text-sm text-slate-600">Send reminders before appointments</p>
                    </div>
                    <Switch defaultChecked />
                  </div>
                  <div className="flex items-center justify-between">
                    <div>
                      <p className="font-medium">New Patient Alerts</p>
                      <p className="text-sm text-slate-600">Get notified when new patients register</p>
                    </div>
                    <Switch />
                  </div>
                </CardContent>
              </Card>

              <Card>
                <CardHeader>
                  <CardTitle className="flex items-center gap-2">
                    <Palette className="h-5 w-5" />
                    Appearance
                  </CardTitle>
                </CardHeader>
                <CardContent className="space-y-4">
                  <div className="flex items-center justify-between">
                    <div>
                      <p className="font-medium">Dark Mode</p>
                      <p className="text-sm text-slate-600">Toggle dark mode interface</p>
                    </div>
                    <Switch />
                  </div>
                  <div className="flex items-center justify-between">
                    <div>
                      <p className="font-medium">Compact View</p>
                      <p className="text-sm text-slate-600">Show more content in less space</p>
                    </div>
                    <Switch />
                  </div>
                </CardContent>
              </Card>

              <Card>
                <CardHeader>
                  <CardTitle className="flex items-center gap-2">
                    <Shield className="h-5 w-5" />
                    Security
                  </CardTitle>
                </CardHeader>
                <CardContent className="space-y-4">
                  <div>
                    <label className="text-sm font-medium">Current Password</label>
                    <Input type="password" placeholder="Enter current password" />
                  </div>
                  <div>
                    <label className="text-sm font-medium">New Password</label>
                    <Input type="password" placeholder="Enter new password" />
                  </div>
                  <div>
                    <label className="text-sm font-medium">Confirm New Password</label>
                    <Input type="password" placeholder="Confirm new password" />
                  </div>
                  <Button>Update Password</Button>
                </CardContent>
              </Card>

              <Card>
                <CardHeader>
                  <CardTitle className="flex items-center gap-2">
                    <SettingsIcon className="h-5 w-5" />
                    General Settings
                  </CardTitle>
                </CardHeader>
                <CardContent className="space-y-4">
                  <div>
                    <label className="text-sm font-medium">Default Appointment Duration</label>
                    <select className="flex h-10 w-full rounded-md border border-input bg-background px-3 py-2 text-sm ring-offset-background">
                      <option>15 minutes</option>
                      <option selected>30 minutes</option>
                      <option>45 minutes</option>
                      <option>60 minutes</option>
                    </select>
                  </div>
                  <div>
                    <label className="text-sm font-medium">Time Zone</label>
                    <select className="flex h-10 w-full rounded-md border border-input bg-background px-3 py-2 text-sm ring-offset-background">
                      <option>Eastern Time (ET)</option>
                      <option>Central Time (CT)</option>
                      <option>Mountain Time (MT)</option>
                      <option>Pacific Time (PT)</option>
                    </select>
                  </div>
                  <Button>Save Settings</Button>
                </CardContent>
              </Card>
            </div>
          </div>
        </main>
      </div>
    </SidebarProvider>
  );
};

export default Settings;
