'use client';
import { useEffect, useState } from 'react';
import Link from 'next/link';
import { useAuth } from '@/lib/auth';
import { getClassrooms } from '@/lib/api';
import { School, AlertCircle, Search, Users, Eye } from 'lucide-react';

export default function TeacherClassroomsPage() {
  useAuth([1]);

  const [classrooms, setClassrooms] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');
  const [search, setSearch] = useState('');

  useEffect(() => {
    getClassrooms(1, 100).then((data) => {
      setClassrooms(data?.items ?? data ?? []);
      setLoading(false);
    }).catch(() => {
      setError('Failed to fetch classrooms.');
      setLoading(false);
    });
  }, []);

  const filtered = classrooms.filter(c =>
    (c.className ?? c.name ?? '').toLowerCase().includes(search.toLowerCase())
  );

  return (
    <div className="p-8 max-w-7xl mx-auto relative min-h-full">
      {/* Decorative background blobs */}
      <div className="absolute top-0 left-0 w-full h-full overflow-hidden -z-10 pointer-events-none" />

      {/* Header */}
      <div className="flex items-center justify-between mb-6">
        <div className="flex items-center gap-3">
          <div className="w-10 h-10 rounded-xl bg-[#526d82] flex items-center justify-center">
            <School className="w-5 h-5 text-white" />
          </div>
          <div>
            <h1 className="text-2xl font-bold text-slate-900">My Classrooms</h1>
            <p className="text-sm text-slate-500">View your assigned classes and students</p>
          </div>
        </div>
      </div>

      {error && (
        <div className="flex items-center gap-3 bg-red-50 border border-red-100 text-red-700 text-sm rounded-xl p-4 mb-4">
          <AlertCircle className="w-5 h-5 shrink-0" />
          {error}
        </div>
      )}

      {/* Search */}
      <div className="relative mb-4">
        <Search className="absolute left-3 top-1/2 -translate-y-1/2 w-5 h-5 text-slate-400" />
        <input
          type="text"
          placeholder="Search classes..."
          value={search}
          onChange={(e) => setSearch(e.target.value)}
          className="w-full max-w-sm pl-10 pr-4 py-2.5 bg-white/80 backdrop-blur-xl border border-white/60 rounded-xl text-sm shadow-xl shadow-slate-200/50 focus:outline-none focus:ring-2 focus:ring-purple-500 focus:border-transparent transition-all"
        />
      </div>

      {loading ? (
        <div className="bg-white/60 backdrop-blur-md rounded-3xl border border-white/50 p-16 text-center shadow-xl shadow-slate-200/30">
          <div className="w-10 h-10 border-4 border-purple-500 border-t-transparent rounded-full animate-spin mx-auto mb-4 shadow-sm" />
          <p className="text-slate-600 font-medium tracking-wide">Loading your classrooms...</p>
        </div>
      ) : filtered.length === 0 ? (
        <div className="bg-white/60 backdrop-blur-md rounded-3xl border border-white/50 p-16 text-center shadow-xl shadow-slate-200/30">
          <div className="w-20 h-20 bg-purple-50 rounded-full flex items-center justify-center mx-auto mb-4 border border-purple-100 shadow-inner">
             <School className="w-10 h-10 text-purple-400" />
          </div>
          <h3 className="text-lg font-bold text-slate-800 mb-1">No Classrooms Found</h3>
          <p className="text-slate-500 text-sm max-w-sm mx-auto">
            {search ? 'No classes match your search.' : 'You have not been assigned to any classes yet.'}
          </p>
        </div>
      ) : (
        <div className="bg-white/80 backdrop-blur-xl rounded-3xl border border-white/60 shadow-xl shadow-slate-200/50 overflow-hidden">
          <table className="w-full text-sm">
            <thead className="bg-slate-50 border-b border-slate-100">
              <tr>
                <th className="text-left px-5 py-4 font-semibold text-slate-600">Class Name</th>
                <th className="text-left px-5 py-4 font-semibold text-slate-600">Grade</th>
                <th className="text-left px-5 py-4 font-semibold text-slate-600">Students</th>
                <th className="px-5 py-4 w-24"></th>
              </tr>
            </thead>
            <tbody className="divide-y divide-slate-50">
              {filtered.map((c) => (
                <tr key={c.id} className="hover:bg-slate-50/50 transition-colors">
                  <td className="px-5 py-4">
                    <div className="flex items-center gap-3">
                      <div className="w-9 h-9 rounded-lg bg-[#526d82] flex items-center justify-center">
                        <School className="w-4 h-4 text-white" />
                      </div>
                      <span className="font-medium text-slate-900">{c.className ?? c.name}</span>
                    </div>
                  </td>
                  <td className="px-5 py-4">
                    <span className="px-2.5 py-1 rounded-full text-xs font-medium bg-slate-100 text-slate-600">
                      {c.grade ?? '—'}
                    </span>
                  </td>
                  <td className="px-5 py-4">
                    <div className="flex items-center gap-1.5 text-slate-600">
                      <Users className="w-4 h-4 text-slate-400" />
                      {c.studentCount ?? c.students?.length ?? 0}
                    </div>
                  </td>
                  <td className="px-5 py-4 text-right">
                    <Link href={`/teacher/classrooms/${c.id}`} className="inline-flex items-center gap-1.5 text-sm font-bold text-white transition-all bg-[#526d82] hover:bg-[#27374d] shadow-lg shadow-slate-500/20 hover:-translate-y-0.5 px-4 py-2 rounded-xl">
                      <Eye className="w-4 h-4" /> View
                    </Link>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      )}
    </div>
  );
}
