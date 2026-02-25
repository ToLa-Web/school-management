'use client';
import Link from 'next/link';
import { usePathname } from 'next/navigation';
import { useEffect, useState } from 'react';
import { logout, getUser } from '@/lib/auth';
import {
  LayoutDashboard,
  Users,
  School,
  GraduationCap,
  BookOpen,
  BarChart3,
  ClipboardCheck,
  CalendarDays,
  UserCog,
  Activity,
  LogOut,
  ChevronRight,
} from 'lucide-react';

const navItems = [
  { href: '/dashboard',  label: 'Dashboard',  icon: LayoutDashboard },
  { href: '/teachers',   label: 'Teachers',   icon: Users },
  { href: '/classrooms', label: 'Classrooms', icon: School },
  { href: '/students',   label: 'Students',   icon: GraduationCap },
  { href: '/subjects',   label: 'Subjects',   icon: BookOpen },
  { href: '/grades',     label: 'Grades',     icon: BarChart3 },
  { href: '/attendance', label: 'Attendance', icon: ClipboardCheck },
  { href: '/schedules',  label: 'Schedules',  icon: CalendarDays },
  { href: '/users',      label: 'Users',      icon: UserCog },
  { href: '/health',     label: 'Health',     icon: Activity },
];

export default function Sidebar() {
  const pathname = usePathname();
  const [user, setUser] = useState(null);

  useEffect(() => {
    setUser(getUser());
  }, []);

  // Don't render sidebar on the login page
  if (pathname === '/login') return null;

  return (
    <aside className="w-64 bg-gradient-to-b from-slate-900 to-slate-800 text-white flex flex-col h-full shrink-0 shadow-xl">
      {/* Brand */}
      <div className="px-6 py-6 border-b border-slate-700/50">
        <div className="flex items-center gap-3">
          <div className="w-10 h-10 rounded-xl bg-gradient-to-br from-blue-500 to-indigo-600 flex items-center justify-center shadow-lg">
            <School className="w-5 h-5 text-white" />
          </div>
          <div>
            <p className="text-base font-semibold tracking-wide">School Admin</p>
            <p className="text-xs text-slate-400 truncate">
              {user?.email ?? 'Administrator'}
            </p>
          </div>
        </div>
      </div>

      {/* Nav */}
      <nav className="flex-1 px-3 py-4 space-y-1 overflow-y-auto">
        {navItems.map(({ href, label, icon: Icon }) => {
          const active = pathname === href || pathname.startsWith(href + '/');
          return (
            <Link
              key={href}
              href={href}
              className={`group flex items-center gap-3 px-3 py-2.5 rounded-lg text-sm font-medium transition-all duration-200 ${
                active
                  ? 'bg-gradient-to-r from-blue-600 to-indigo-600 text-white shadow-md shadow-blue-500/20'
                  : 'text-slate-300 hover:bg-slate-700/50 hover:text-white'
              }`}
            >
              <Icon className={`w-5 h-5 ${active ? 'text-white' : 'text-slate-400 group-hover:text-white'}`} />
              <span className="flex-1">{label}</span>
              {active && <ChevronRight className="w-4 h-4 opacity-70" />}
            </Link>
          );
        })}
      </nav>

      {/* Logout */}
      <div className="px-3 py-4 border-t border-slate-700/50">
        <button
          onClick={logout}
          className="w-full flex items-center gap-3 px-3 py-2.5 rounded-lg text-sm font-medium text-slate-300 hover:bg-red-500/10 hover:text-red-400 transition-all duration-200"
        >
          <LogOut className="w-5 h-5" />
          <span>Logout</span>
        </button>
      </div>
    </aside>
  );
}
