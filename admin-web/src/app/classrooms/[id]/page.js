'use client';
import { useEffect, useState } from 'react';
import { useRouter, useParams } from 'next/navigation';
import Link from 'next/link';
import { useAuth } from '@/lib/auth';
import {
  getClassroom, updateClassroom,
  getTeachers, getStudents,
  enrollStudent, unenrollStudent,
} from '@/lib/api';
import { School, ArrowLeft, AlertCircle, Save, Bookmark, User, Users, UserPlus, Trash2, CheckCircle } from 'lucide-react';

const inputCls =
  'w-full border border-slate-200 rounded-xl px-3 py-2.5 text-sm focus:outline-none focus:ring-2 focus:ring-emerald-500 focus:border-transparent bg-slate-50 placeholder:text-slate-400';

export default function ClassroomDetailPage() {
  useAuth();

  const router = useRouter();
  const { id } = useParams();
  const [classroom,  setClassroom]  = useState(null);
  const [teachers,   setTeachers]   = useState([]);
  const [allStudents, setAllStudents] = useState([]);
  const [form,       setForm]       = useState(null);
  const [error,      setError]      = useState('');
  const [success,    setSuccess]    = useState('');
  const [saving,     setSaving]     = useState(false);
  const [loading,    setLoading]    = useState(true);
  const [enrollId,   setEnrollId]   = useState('');

  async function load() {
    const [cls, tea, stu] = await Promise.all([
      getClassroom(id),
      getTeachers(1, 100),
      getStudents(1, 100),
    ]);
    if (cls) {
      setClassroom(cls);
      setForm({
        className: cls.className ?? cls.name ?? '',
        grade:     cls.grade ?? '',
        teacherId: cls.teacherId ?? '',
      });
    }
    setTeachers(tea?.items ?? tea ?? []);
    setAllStudents(stu?.items ?? stu ?? []);
    setLoading(false);
  }

  useEffect(() => { load(); }, [id]);

  function set(field, value) {
    setForm((prev) => ({ ...prev, [field]: value }));
  }

  async function handleSave(e) {
    e.preventDefault();
    setError('');
    setSuccess('');
    setSaving(true);
    try {
      const res = await updateClassroom(id, { ...form, teacherId: form.teacherId || null });
      if (res?.ok) {
        setError('');
        setSuccess('Classroom updated successfully!');
        setTimeout(() => setSuccess(''), 4000);
      } else {
        const data = await res.json().catch(() => ({}));
        setError(data?.message ?? 'Failed to save.');
      }
    } finally {
      setSaving(false);
    }
  }

  async function handleEnroll() {
    if (!enrollId) return;
    const res = await enrollStudent(id, enrollId);
    if (res?.ok) { 
      setEnrollId(''); 
      setSuccess('Student enrolled successfully!');
      setTimeout(() => setSuccess(''), 4000);
      load(); 
    }
    else {
      setError('Failed to enroll student.');
    }
  }

  async function handleUnenroll(studentId, name) {
    if (!confirm(`Remove ${name} from this classroom?`)) return;
    const res = await unenrollStudent(id, studentId);
    if (res?.ok) {
      setSuccess('Student removed successfully!');
      setTimeout(() => setSuccess(''), 4000);
      load();
    }
    else setError('Failed to remove student.');
  }

  if (loading) {
    return (
      <div className="max-w-2xl">
        <div className="bg-white rounded-2xl border border-slate-100 p-12 text-center">
          <div className="w-8 h-8 border-2 border-emerald-500 border-t-transparent rounded-full animate-spin mx-auto mb-3" />
          <p className="text-slate-500 text-sm">Loading classroom...</p>
        </div>
      </div>
    );
  }

  if (!classroom) {
    return (
      <div className="max-w-2xl">
        <div className="flex items-center gap-3 bg-red-50 border border-red-100 text-red-700 text-sm rounded-xl p-4">
          <AlertCircle className="w-5 h-5 shrink-0" />
          Classroom not found.
        </div>
      </div>
    );
  }

  const enrolledIds = new Set((classroom.students ?? []).map((s) => s.id));
  const available   = allStudents.filter((s) => !enrolledIds.has(s.id));

  return (
    <div className="max-w-2xl space-y-6">
      {/* Header */}
      <div className="flex items-center gap-3 mb-2">
        <Link href="/classrooms" className="p-2 text-slate-400 hover:text-slate-600 hover:bg-slate-100 rounded-lg transition-colors">
          <ArrowLeft className="w-5 h-5" />
        </Link>
        <div className="w-10 h-10 rounded-xl bg-gradient-to-br from-emerald-500 to-teal-600 flex items-center justify-center">
          <School className="w-5 h-5 text-white" />
        </div>
        <div>
          <h1 className="text-2xl font-bold text-slate-900">{classroom.className ?? classroom.name}</h1>
          <p className="text-sm text-slate-500">Manage classroom details and enrollment</p>
        </div>
      </div>

      {success && (
        <div className="flex items-center gap-3 bg-emerald-50 border border-emerald-200 text-emerald-700 text-sm rounded-xl p-4">
          <CheckCircle className="w-5 h-5 shrink-0" />
          {success}
        </div>
      )}

      {error && (
        <div className="flex items-center gap-3 bg-red-50 border border-red-100 text-red-700 text-sm rounded-xl p-4">
          <AlertCircle className="w-5 h-5 shrink-0" />
          {error}
        </div>
      )}

      {/* Edit classroom details */}
      <section className="bg-white rounded-2xl border border-slate-100 shadow-sm p-6">
        <h2 className="text-base font-semibold text-slate-900 mb-4">Classroom Details</h2>
        <form onSubmit={handleSave} className="space-y-5">
          <div>
            <label className="flex items-center gap-1.5 text-sm font-semibold text-slate-700 mb-1.5">
              <School className="w-4 h-4 text-slate-400" />
              Class Name <span className="text-red-500">*</span>
            </label>
            <input type="text" value={form.className}
              onChange={(e) => set('className', e.target.value)} className={inputCls} />
          </div>
          <div>
            <label className="flex items-center gap-1.5 text-sm font-semibold text-slate-700 mb-1.5">
              <Bookmark className="w-4 h-4 text-slate-400" />
              Grade
            </label>
            <input type="text" value={form.grade}
              onChange={(e) => set('grade', e.target.value)} placeholder="e.g. Grade 10" className={inputCls} />
          </div>
          <div>
            <label className="flex items-center gap-1.5 text-sm font-semibold text-slate-700 mb-1.5">
              <User className="w-4 h-4 text-slate-400" />
              Assign Teacher
            </label>
            <select value={form.teacherId} onChange={(e) => set('teacherId', e.target.value)} className={inputCls}>
              <option value="">— No teacher —</option>
              {teachers.map((t) => (
                <option key={t.id} value={t.id}>{t.firstName} {t.lastName}</option>
              ))}
            </select>
          </div>
          <div className="flex gap-3 pt-3">
            <button type="submit" disabled={saving}
              className="bg-gradient-to-r from-emerald-500 to-teal-600 hover:from-emerald-600 hover:to-teal-700 disabled:opacity-50 text-white text-sm font-medium px-5 py-2.5 rounded-xl shadow-lg shadow-emerald-500/20 transition-all flex items-center gap-2">
              {saving ? (
                <div className="w-4 h-4 border-2 border-white border-t-transparent rounded-full animate-spin" />
              ) : (
                <Save className="w-4 h-4" />
              )}
              {saving ? 'Saving...' : 'Save Changes'}
            </button>
            <button type="button" onClick={() => router.push('/classrooms')}
              className="text-slate-600 hover:text-slate-800 text-sm font-medium px-5 py-2.5 rounded-xl border border-slate-200 hover:bg-slate-50 transition-colors">
              Back
            </button>
          </div>
        </form>
      </section>

      {/* Enrolled students */}
      <section className="bg-white rounded-2xl border border-slate-100 shadow-sm p-6">
        <div className="flex items-center gap-2 mb-4">
          <Users className="w-5 h-5 text-slate-400" />
          <h2 className="text-base font-semibold text-slate-900">
            Enrolled Students ({(classroom.students ?? []).length})
          </h2>
        </div>

        {/* Enroll a new student */}
        {available.length > 0 && (
          <div className="flex gap-2 mb-4">
            <select value={enrollId} onChange={(e) => setEnrollId(e.target.value)}
              className="flex-1 border border-slate-200 rounded-xl px-3 py-2.5 text-sm focus:outline-none focus:ring-2 focus:ring-emerald-500 focus:border-transparent bg-slate-50">
              <option value="">— Select student to enroll —</option>
              {available.map((s) => (
                <option key={s.id} value={s.id}>{s.firstName} {s.lastName}</option>
              ))}
            </select>
            <button onClick={handleEnroll} disabled={!enrollId}
              className="bg-gradient-to-r from-emerald-500 to-teal-600 hover:from-emerald-600 hover:to-teal-700 disabled:opacity-50 text-white text-sm font-medium px-4 py-2.5 rounded-xl transition-all flex items-center gap-2 whitespace-nowrap">
              <UserPlus className="w-4 h-4" />
              Enroll
            </button>
          </div>
        )}

        {(classroom.students ?? []).length === 0 ? (
          <div className="text-center py-8">
            <Users className="w-10 h-10 text-slate-300 mx-auto mb-2" />
            <p className="text-slate-500 text-sm">No students enrolled yet.</p>
          </div>
        ) : (
          <div className="rounded-xl border border-slate-100 overflow-hidden">
            <table className="w-full text-sm">
              <thead className="bg-slate-50 border-b border-slate-100">
                <tr>
                  <th className="text-left px-4 py-3 font-semibold text-slate-600">Student</th>
                  <th className="px-4 py-3 w-20"></th>
                </tr>
              </thead>
              <tbody className="divide-y divide-slate-50">
                {(classroom.students ?? []).map((s, i) => (
                  <tr key={s.id ?? i} className="hover:bg-slate-50/50 transition-colors">
                    <td className="px-4 py-3">
                      <div className="flex items-center gap-3">
                        <div className="w-8 h-8 rounded-full bg-gradient-to-br from-amber-500 to-orange-500 flex items-center justify-center text-white font-semibold text-xs">
                          {s.firstName?.[0]}{s.lastName?.[0]}
                        </div>
                        <span className="font-medium text-slate-900">{s.firstName} {s.lastName}</span>
                      </div>
                    </td>
                    <td className="px-4 py-3 text-right">
                      <button
                        onClick={() => handleUnenroll(s.id, `${s.firstName} ${s.lastName}`)}
                        className="p-2 text-slate-400 hover:text-red-600 hover:bg-red-50 rounded-lg transition-colors"
                        title="Remove"
                      >
                        <Trash2 className="w-4 h-4" />
                      </button>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        )}
      </section>
    </div>
  );
}
