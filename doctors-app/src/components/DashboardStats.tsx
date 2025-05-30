
import { Card, CardContent, CardHeader, CardTitle } from "../components/ui/card";
import { Calendar, Users, Clock, CheckCircle } from "lucide-react";

const stats = [
  {
    title: "Today's Appointments",
    value: "8",
    icon: Calendar,
    color: "text-blue-600",
    bgColor: "bg-blue-50",
  },
  {
    title: "Total Patients",
    value: "1,234",
    icon: Users,
    color: "text-green-600",
    bgColor: "bg-green-50",
  },
  {
    title: "Pending Appointments",
    value: "15",
    icon: Clock,
    color: "text-orange-600",
    bgColor: "bg-orange-50",
  },
  {
    title: "Completed Today",
    value: "5",
    icon: CheckCircle,
    color: "text-emerald-600",
    bgColor: "bg-emerald-50",
  },
];

export function DashboardStats() {
  return (
    <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
      {stats.map((stat, index) => (
        <Card key={index} className="hover:shadow-md transition-shadow">
          <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
            <CardTitle className="text-sm font-medium text-slate-600">
              {stat.title}
            </CardTitle>
            <div className={`p-2 rounded-lg ${stat.bgColor}`}>
              <stat.icon className={`h-4 w-4 ${stat.color}`} />
            </div>
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold text-slate-800">{stat.value}</div>
          </CardContent>
        </Card>
      ))}
    </div>
  );
}
