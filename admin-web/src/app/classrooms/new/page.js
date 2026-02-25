'use client';
import { useEffect, useState } from 'react';
import { useRouter } from 'next/navigation';
import Link from 'next/link';
import { useAuth } from '@/lib/auth';
import { createClassroom, getTeachers } from '@/lib/api';
import { School, ArrowLeft, AlertCircle, Save, Bookmark, User } from 'lucide-react';

export default function NewClassroomPage() {
  useAuth();

  const router = useRouter();
  const [form, setForm] = useState({ className: '', grade: '', teacherId: '' });
  const [teachers, setTeachers] = useState([]);
  const [error, setError] = useState('');
  const [saving, setSaving] = useState(false);

  useEffect(() => {
    getTeachers(1, 100).then((data) => setTeachers(data?.items ?? data ?? []));
  }, []);

  function set(field, value) {
    setForm((prev) => ({ ...prev, [field]: value }));
  }

  async function handleSubmit(e) {
    e.preventDefault();
    setError('');
    setSaving(true);
    try {
      const payload = {
        ...form,
        teacherId: form.teacherId || null,
      };
      const res = await createClassroom(payload);
      if (res?.ok) {
        router.push('/classrooms');
      } else {
        const data = await res.json().catch(() => ({}));
        setError(data?.message ?? data?.error ?? 'Failed to create classroom.');
      }
    } finally {
      setSaving(false);
    }
  }

  return (
    <div className="max-w-lg">
      {/* Header */}
      <div className="flex items-center gap-3 mb-6">
        <Link
          href="/classrooms"
          className="p-2 text-slate-400 hover:text-slate-600 hover:bg-slate-100 rounded-lg transition-colors"
        >
          <ArrowLeft className="w-5 h-5" />
        </Link>
        <div className="w-10 h-10 rounded-xl bg-gradient-to-br from-emerald-500 to-teal-600 flex items-center justify-center">
          <School className="w-5 h-5 text-white" />
        </div>
        <div>
          <h1 className="text-2xl font-bold text-slate-900">New Classroom</h1>
          <p className="text-sm text-slate-500">Create a new classroom</p>
        </div>
      </div>

      {error && (
        <div className="flex items-center gap-3 bg-red-50 border border-red-100 text-red-700 text-sm rounded-xl p-4 mb-4">
          <AlertCircle className="w-5 h-5 shrink-0" />
          {error}
        </div>
      )}

      <form onSubmit={handleSubmit} className="bg-white rounded-2xl border border-slate-100 shadow-sm p-6 space-y-5">
        <div>
          <label className="flex items-center gap-1.5 text-sm font-semibold text-slate-700 mb-1.5">
            <School className="w-4 h-4 text-slate-400" />
            Class Name <span className="text-red-500">*</span>
          </label>
          <input
            type="text" required
            value={form.className}
            onChange={(e) => set('className', e.target.value)}
            placeholder="e.g. Class A"
            className="w-full border border-slate-200 rounded-xl px-3 py-2.5 text-sm focus:outline-none focus:ring-2 focus:ring-emerald-500 focus:border-transparent bg-slate-50 placeholder:text-slate-400"
          />
        </div>

        <div>
          <label className="flex items-center gap-1.5 text-sm font-semibold text-slate-700 mb-1.5">
            <Bookmark className="w-4 h-4 text-slate-400" />
            Grade
          </label>
          <input
            type="text"
            value={form.grade}
            onChange={(e) => set('grade', e.target.value)}
            placeholder="e.g. Grade 10"
            className="w-full border border-slate-200 rounded-xl px-3 py-2.5 text-sm focus:outline-none focus:ring-2 focus:ring-emerald-500 focus:border-transparent bg-slate-50 placeholder:text-slate-400"
          />
        </div>

        <div>
          <label className="flex items-center gap-1.5 text-sm font-semibold text-slate-700 mb-1.5">
            <User className="w-4 h-4 text-slate-400" />
            Assign Teacher
          </label>
          <select
            value={form.teacherId}
            onChange={(e) => set('teacherId', e.target.value)}
            className="w-full border border-slate-200 rounded-xl px-3 py-2.5 text-sm focus:outline-none focus:ring-2 focus:ring-emerald-500 focus:border-transparent bg-slate-50"
          >
            <option value="">— No teacher yet —</option>
            {teachers.map((t) => (
              <option key={t.id} value={t.id}>
                {t.firstName} {t.lastName}
              </option>
            ))}
          </select>
        </div>

        <div className="flex gap-3 pt-3">
          <button
            type="submit"
            disabled={saving}
            className="bg-gradient-to-r from-emerald-500 to-teal-600 hover:from-emerald-600 hover:to-teal-700 disabled:opacity-50 text-white text-sm font-medium px-5 py-2.5 rounded-xl shadow-lg shadow-emerald-500/20 transition-all flex items-center gap-2"
          >
            {saving ? (
              <div className="w-4 h-4 border-2 border-white border-t-transparent rounded-full animate-spin" />
            ) : (
              <Save className="w-4 h-4" />
            )}
            {saving ? 'Saving...' : 'Create Classroom'}
          </button>
          <button
            type="button"
            onClick={() => router.push('/classrooms')}
            className="text-slate-600 hover:text-slate-800 text-sm font-medium px-5 py-2.5 rounded-xl border border-slate-200 hover:bg-slate-50 transition-colors"
          >
            Cancel
          </button>
        </div>
      </form>
    </div>
  );
}
