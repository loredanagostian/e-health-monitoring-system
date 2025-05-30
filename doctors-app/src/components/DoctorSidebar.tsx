import {
  Calendar,
  User,
  Stethoscope,
  Clock,
  Plus,
  Settings,
  Home,
  LogOut
} from "lucide-react";
import { Link, useNavigate, useLocation } from "react-router-dom";
import {
  Sidebar,
  SidebarContent,
  SidebarGroup,
  SidebarGroupContent,
  SidebarGroupLabel,
  SidebarMenu,
  SidebarMenuButton,
  SidebarMenuItem,
  SidebarFooter,
} from "@/components/ui/sidebar";
import { Button } from "@/components/ui/button";

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
  const navigate = useNavigate();
  const location = useLocation();

  const handleLogout = () => {
    localStorage.removeItem("isAuthenticated");
    navigate("/signin");
  };

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
              {menuItems.map((item) => {
                const isActive = location.pathname === item.url;

                return (
                  <SidebarMenuItem key={item.title}>
                    <SidebarMenuButton
                      asChild
                      className={`${
                        isActive
                          ? "bg-blue-100 text-blue-700 font-medium"
                          : "hover:bg-blue-50 hover:text-blue-700"
                      }`}
                    >
                      <Link to={item.url}>
                        <item.icon className="h-4 w-4" />
                        <span>{item.title}</span>
                      </Link>
                    </SidebarMenuButton>
                  </SidebarMenuItem>
                );
              })}
            </SidebarMenu>
          </SidebarGroupContent>
        </SidebarGroup>
      </SidebarContent>
      <SidebarFooter className="border-t border-slate-200 p-4">
        <Button
          onClick={handleLogout}
          variant="ghost"
          className="w-full justify-start text-slate-600 hover:text-red-600 hover:bg-red-50"
        >
          <LogOut className="h-4 w-4 mr-2" />
          Logout
        </Button>
      </SidebarFooter>
    </Sidebar>
  );
}
