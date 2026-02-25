'use client';
import { useEffect, useState } from 'react';
import Link from 'next/link';
import { useAuth } from '@/lib/auth';
import { getStudents, deleteStudent } from '@/lib/api';
import { GraduationCap, Plus, Pencil, Trash2, AlertCircle, Search } from 'lucide-react';

export default function StudentsPage() {
  useAuth();

  const [students, setStudents] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');
  const [search, setSearch] = useState('');

  async function load() {
    setLoading(true);
    const data = await getStudents(1, 100);
    setStudents(data?.items ?? data ?? []);
    setLoading(false);
  }

  useEffect(() => { load(); }, []);

  async function handleDelete(id, name) {
    if (!confirm(`Delete ${name}? This cannot be undone.`)) return;
    const res = await deleteStudent(id);
    if (res?.ok) {
      setStudents((prev) => prev.filter((s) => s.id !== id));
    } else {
      setError('Failed to delete student.');
    }
  }

  const filtered = students.filter(s =>
    `${s.firstName} ${s.lastName}`.toLowerCase().includes(search.toLowerCase())
  );

  return (
    <div>
      {/* Header */}
      <div className="flex items-center justify-between mb-6">
        <div className="flex items-center gap-3">
          <div className="w-10 h-10 rounded-xl bg-gradient-to-br from-amber-500 to-orange-500 flex items-center justify-center">
            <GraduationCap className="w-5 h-5 text-white" />
          </div>
          <div>
            <h1 className="text-2xl font-bold text-slate-900">Students</h1>
            <p className="text-sm text-slate-500">{students.length} total</p>
          </div>
        </div>
        <Link
          href="/students/new"
          className="bg-gradient-to-r from-amber-500 to-orange-500 hover:from-amber-600 hover:to-orange-600 text-white text-sm font-medium px-4 py-2.5 rounded-xl shadow-lg shadow-amber-500/20 hover:shadow-amber-500/30 transition-all flex items-center gap-2"
        >
          <Plus className="w-4 h-4" />
          Add Student
        </Link>
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
          placeholder="Search students..."
          value={search}
          onChange={(e) => setSearch(e.target.value)}
          className="w-full max-w-sm pl-10 pr-4 py-2.5 bg-white border border-slate-200 rounded-xl text-sm focus:outline-none focus:ring-2 focus:ring-amber-500 focus:border-transparent"
        />
      </div>

      {loading ? (
        <div className="bg-white rounded-2xl border border-slate-100 p-12 text-center">
          <div className="w-8 h-8 border-2 border-amber-500 border-t-transparent rounded-full animate-spin mx-auto mb-3" />
          <p className="text-slate-500 text-sm">Loading students...</p>
        </div>
      ) : filtered.length === 0 ? (
        <div className="bg-white rounded-2xl border border-slate-100 p-12 text-center">
          <GraduationCap className="w-12 h-12 text-slate-300 mx-auto mb-3" />
          <p className="text-slate-500 text-sm">
            {search ? 'No students match your search.' : 'No students yet. Create the first one.'}
          </p>
        </div>
      ) : (
        <div className="bg-white rounded-2xl border border-slate-100 shadow-sm overflow-hidden">
          <table className="w-full text-sm">
            <thead className="bg-slate-50 border-b border-slate-100">
              <tr>
                <th className="text-left px-5 py-4 font-semibold text-slate-600">Name</th>
                <th className="text-left px-5 py-4 font-semibold text-slate-600">Gender</th>
                <th className="text-left px-5 py-4 font-semibold text-slate-600">Phone</th>
                <th className="text-left px-5 py-4 font-semibold text-slate-600">Date of Birth</th>
                <th className="text-left px-5 py-4 font-semibold text-slate-600">Address</th>
                <th className="px-5 py-4 w-24"></th>
              </tr>
            </thead>
            <tbody className="divide-y divide-slate-50">
              {filtered.map((s) => (
                <tr key={s.id} className="hover:bg-slate-50/50 transition-colors">
                  <td className="px-5 py-4">
                    <div className="flex items-center gap-3">
                      <div className="w-9 h-9 rounded-full bg-gradient-to-br from-amber-500 to-orange-500 flex items-center justify-center text-white font-semibold text-sm">
                        {s.firstName?.[0]}{s.lastName?.[0]}
                      </div>
                      <span className="font-medium text-slate-900">{s.firstName} {s.lastName}</span>
                    </div>
                  </td>
                  <td className="px-5 py-4 text-slate-600">{s.gender ?? '—'}</td>
                  <td className="px-5 py-4 text-slate-600">{s.phone ?? '—'}</td>
                  <td className="px-5 py-4 text-slate-500">
                    {s.dateOfBirth ? new Date(s.dateOfBirth).toLocaleDateString() : '—'}
                  </td>
                  <td className="px-5 py-4 text-slate-500 max-w-xs truncate">{s.address ?? '—'}</td>
                  <td className="px-5 py-4">
                    <div className="flex items-center justify-end gap-1">
                      <Link
                        href={`/students/${s.id}`}
                        className="p-2 text-slate-400 hover:text-blue-600 hover:bg-blue-50 rounded-lg transition-colors"
                        title="Edit"
                      >
                        <Pencil className="w-4 h-4" />
                      </Link>
                      <button
                        onClick={() => handleDelete(s.id, `${s.firstName} ${s.lastName}`)}
                        className="p-2 text-slate-400 hover:text-red-600 hover:bg-red-50 rounded-lg transition-colors"
                        title="Delete"
                      >
                        <Trash2 className="w-4 h-4" />
                      </button>
                    </div>
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
