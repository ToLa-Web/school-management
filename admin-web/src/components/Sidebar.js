'use client';
import Link from 'next/link';
import { usePathname } from 'next/navigation';
import { logout, getUser } from '@/lib/auth';

const navItems = [
  { href: '/dashboard',  label: 'Dashboard',  icon: '🏠' },
  { href: '/teachers',   label: 'Teachers',   icon: '👨‍🏫' },
  { href: '/classrooms', label: 'Classrooms', icon: '🏫' },
  { href: '/students',   label: 'Students',   icon: '🎒' },
  { href: '/users',      label: 'Users',      icon: '👥' },
  { href: '/health',     label: 'Health',     icon: '💚' },
];

export default function Sidebar() {
  const pathname = usePathname();

  // Don't render sidebar on the login page
  if (pathname === '/login') return null;

  const user = getUser();

  return (
    <aside className="w-56 bg-gray-900 text-white flex flex-col h-full shrink-0">
      {/* Brand */}
      <div className="px-6 py-5 border-b border-gray-700">
        <p className="text-lg font-bold tracking-wide">School Admin</p>
        <p className="text-xs text-gray-400 mt-0.5 truncate">
          {user?.email ?? 'Admin'}
        </p>
      </div>

      {/* Nav */}
      <nav className="flex-1 px-3 py-4 space-y-1">
        {navItems.map(({ href, label, icon }) => {
          const active = pathname === href || pathname.startsWith(href + '/');
          return (
            <Link
              key={href}
              href={href}
              className={`flex items-center gap-3 px-3 py-2 rounded-md text-sm transition-colors ${
                active
                  ? 'bg-blue-600 text-white font-medium'
                  : 'text-gray-300 hover:bg-gray-700 hover:text-white'
              }`}
            >
              <span>{icon}</span>
              {label}
            </Link>
          );
        })}
      </nav>

      {/* Logout */}
      <div className="px-3 py-4 border-t border-gray-700">
        <button
          onClick={logout}
          className="w-full flex items-center gap-3 px-3 py-2 rounded-md text-sm text-gray-300 hover:bg-gray-700 hover:text-white transition-colors"
        >
          <span>🚪</span>
          Logout
        </button>
      </div>
    </aside>
  );
}
