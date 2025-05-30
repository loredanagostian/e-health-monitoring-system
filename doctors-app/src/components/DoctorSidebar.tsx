
import { 
  Calendar, 
  User, 
  Stethoscope, 
  Clock, 
  Plus,
  Settings,
  Home
} from "lucide-react";
import {
  Sidebar,
  SidebarContent,
  SidebarGroup,
  SidebarGroupContent,
  SidebarGroupLabel,
  SidebarMenu,
  SidebarMenuButton,
  SidebarMenuItem,
} from "../components/ui/sidebar";

const menuItems = [
  {
    title: "Dashboard",
    url: "/",
    icon: Home,
  },
  {
    title: "Appointments",
    url: "/appointments",
    icon: Calendar,
  },
  {
    title: "Specializations",
    url: "/specializations",
    icon: Stethoscope,
  },
  {
    title: "Appointment Types",
    url: "/appointment-types",
    icon: Clock,
  },
  {
    title: "Schedule",
    url: "/schedule",
    icon: Plus,
  },
  {
    title: "Profile",
    url: "/profile",
    icon: User,
  },
  {
    title: "Settings",
    url: "/settings",
    icon: Settings,
  },
];

export function DoctorSidebar() {
  return (
    <Sidebar className="border-r border-slate-200">
      <SidebarContent>
        <div className="p-6 border-b border-slate-200">
          <h2 className="text-xl font-bold text-slate-800">e-Health Monitoring System</h2>
          <p className="text-sm text-slate-600">Doctor Dashboard</p>
        </div>
        <SidebarGroup>
          <SidebarGroupLabel className="text-slate-700 font-medium">
            Practice Management
          </SidebarGroupLabel>
          <SidebarGroupContent>
            <SidebarMenu>
              {menuItems.map((item) => (
                <SidebarMenuItem key={item.title}>
                  <SidebarMenuButton asChild className="hover:bg-blue-50 hover:text-blue-700">
                    <a href={item.url}>
                      <item.icon className="h-4 w-4" />
                      <span>{item.title}</span>
                    </a>
                  </SidebarMenuButton>
                </SidebarMenuItem>
              ))}
            </SidebarMenu>
          </SidebarGroupContent>
        </SidebarGroup>
      </SidebarContent>
    </Sidebar>
  );
}
