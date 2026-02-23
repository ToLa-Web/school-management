'use client';
import { useEffect, useState } from 'react';
import { useAuth, getUser } from '@/lib/auth';
import { getTeachers, getClassrooms, getStudents } from '@/lib/api';

export default function DashboardPage() {
  useAuth();

  const user = getUser();
  const [stats, setStats]   = useState(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    async function load() {
      const [teachers, classrooms, students] = await Promise.all([
        getTeachers(1, 1),
        getClassrooms(1, 1),
        getStudents(1, 1),
      ]);
      setStats({
        teachers:   teachers?.totalCount  ?? teachers?.items?.length  ?? '—',
        classrooms: classrooms?.totalCount ?? classrooms?.items?.length ?? '—',
        students:   students?.totalCount   ?? students?.items?.length   ?? '—',
      });
      setLoading(false);
    }
    load();
  }, []);

  const cards = [
    { label: 'Teachers',   value: stats?.teachers,   href: '/teachers',   color: 'bg-blue-500'  },
    { label: 'Classrooms', value: stats?.classrooms, href: '/classrooms', color: 'bg-green-500' },
    { label: 'Students',   value: stats?.students,   href: '/students',   color: 'bg-yellow-500'},
  ];

  return (
    <div>
      <h1 className="text-2xl font-bold mb-1">Dashboard</h1>
      <p className="text-gray-500 text-sm mb-8">
        Welcome back{user?.email ? `, ${user.email}` : ''}
      </p>

      <div className="grid grid-cols-1 sm:grid-cols-3 gap-6">
        {cards.map(({ label, value, href, color }) => (
          <a
            key={label}
            href={href}
            className="bg-white rounded-xl shadow-sm p-6 flex items-center gap-4 hover:shadow-md transition-shadow"
          >
            <div className={`${color} rounded-lg w-12 h-12 flex items-center justify-center text-white text-xl shrink-0`}>
              {label === 'Teachers'   && '👨‍🏫'}
              {label === 'Classrooms' && '🏫'}
              {label === 'Students'   && '🎒'}
            </div>
            <div>
              <p className="text-2xl font-bold">
                {loading ? '…' : value}
              </p>
              <p className="text-sm text-gray-500">{label}</p>
            </div>
          </a>
        ))}
      </div>
    </div>
  );
}
