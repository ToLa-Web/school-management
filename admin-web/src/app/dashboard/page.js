'use client';
import { useEffect, useState } from 'react';
import { useAuth, getUser } from '@/lib/auth';
import { getTeachers, getClassrooms, getStudents, getSubjects } from '@/lib/api';
import { Users, School, GraduationCap, BookOpen, TrendingUp, Activity } from 'lucide-react';

export default function DashboardPage() {
  useAuth();

  const [user, setUser] = useState(null);
  const [stats, setStats] = useState(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    setUser(getUser());
    async function load() {
      const [teachers, classrooms, students, subjects] = await Promise.all([
        getTeachers(1, 1),
        getClassrooms(1, 1),
        getStudents(1, 1),
        getSubjects(),
      ]);
      setStats({
        teachers:   teachers?.totalCount  ?? teachers?.items?.length  ?? 0,
        classrooms: classrooms?.totalCount ?? classrooms?.items?.length ?? 0,
        students:   students?.totalCount   ?? students?.items?.length   ?? 0,
        subjects:   subjects?.length ?? subjects?.items?.length ?? 0,
      });
      setLoading(false);
    }
    load();
  }, []);

  const cards = [
    { label: 'Teachers',   value: stats?.teachers,   href: '/teachers',   icon: Users,         gradient: 'from-blue-500 to-blue-600' },
    { label: 'Classrooms', value: stats?.classrooms, href: '/classrooms', icon: School,        gradient: 'from-emerald-500 to-emerald-600' },
    { label: 'Students',   value: stats?.students,   href: '/students',   icon: GraduationCap, gradient: 'from-amber-500 to-orange-500' },
    { label: 'Subjects',   value: stats?.subjects,   href: '/subjects',   icon: BookOpen,      gradient: 'from-purple-500 to-indigo-600' },
  ];

  return (
    <div>
      {/* Header */}
      <div className="mb-8">
        <h1 className="text-2xl font-bold text-slate-900">Dashboard</h1>
        <p className="text-slate-500 mt-1">
          Welcome back{user?.email ? `, ${user.email.split('@')[0]}` : ''}! Here's what's happening.
        </p>
      </div>

      {/* Stats Grid */}
      <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-5 mb-8">
        {cards.map(({ label, value, href, icon: Icon, gradient }) => (
          <a
            key={label}
            href={href}
            className="group bg-white rounded-2xl shadow-sm border border-slate-100 p-5 hover:shadow-lg hover:border-slate-200 transition-all duration-300"
          >
            <div className="flex items-start justify-between">
              <div className={`bg-gradient-to-br ${gradient} rounded-xl w-12 h-12 flex items-center justify-center shadow-lg`}>
                <Icon className="w-6 h-6 text-white" />
              </div>
              <TrendingUp className="w-4 h-4 text-emerald-500 opacity-0 group-hover:opacity-100 transition-opacity" />
            </div>
            <div className="mt-4">
              <p className="text-3xl font-bold text-slate-900">
                {loading ? '—' : value}
              </p>
              <p className="text-sm font-medium text-slate-500 mt-1">{label}</p>
            </div>
          </a>
        ))}
      </div>

      {/* Quick Actions */}
      <div className="bg-white rounded-2xl shadow-sm border border-slate-100 p-6">
        <div className="flex items-center gap-2 mb-4">
          <Activity className="w-5 h-5 text-slate-400" />
          <h2 className="font-semibold text-slate-900">Quick Actions</h2>
        </div>
        <div className="grid grid-cols-2 sm:grid-cols-4 gap-3">
          <a href="/teachers/new" className="flex items-center gap-2 px-4 py-3 bg-slate-50 hover:bg-slate-100 rounded-xl text-sm font-medium text-slate-700 transition-colors">
            <Users className="w-4 h-4" />
            Add Teacher
          </a>
          <a href="/students/new" className="flex items-center gap-2 px-4 py-3 bg-slate-50 hover:bg-slate-100 rounded-xl text-sm font-medium text-slate-700 transition-colors">
            <GraduationCap className="w-4 h-4" />
            Add Student
          </a>
          <a href="/classrooms/new" className="flex items-center gap-2 px-4 py-3 bg-slate-50 hover:bg-slate-100 rounded-xl text-sm font-medium text-slate-700 transition-colors">
            <School className="w-4 h-4" />
            Add Classroom
          </a>
          <a href="/subjects/new" className="flex items-center gap-2 px-4 py-3 bg-slate-50 hover:bg-slate-100 rounded-xl text-sm font-medium text-slate-700 transition-colors">
            <BookOpen className="w-4 h-4" />
            Add Subject
          </a>
        </div>
      </div>
    </div>
  );
}
