'use client';
import { useEffect, useState } from 'react';
import { useRouter } from 'next/navigation';
import { useAuth } from '@/lib/auth';
import {
  getClassroom, updateClassroom,
  getTeachers, getStudents,
  enrollStudent, unenrollStudent,
} from '@/lib/api';

const inputCls =
  'w-full border border-gray-300 rounded-md px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-blue-500';

export default function ClassroomDetailPage({ params }) {
  useAuth();

  const router = useRouter();
  const [classroom,  setClassroom]  = useState(null);
  const [teachers,   setTeachers]   = useState([]);
  const [allStudents, setAllStudents] = useState([]);
  const [form,       setForm]       = useState(null);
  const [error,      setError]      = useState('');
  const [saving,     setSaving]     = useState(false);
  const [loading,    setLoading]    = useState(true);
  const [enrollId,   setEnrollId]   = useState('');

  async function load() {
    const [cls, tea, stu] = await Promise.all([
      getClassroom(params.id),
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

  useEffect(() => { load(); }, [params.id]);

  function set(field, value) {
    setForm((prev) => ({ ...prev, [field]: value }));
  }

  async function handleSave(e) {
    e.preventDefault();
    setError('');
    setSaving(true);
    try {
      const res = await updateClassroom(params.id, { ...form, teacherId: form.teacherId || null });
      if (!res?.ok) {
        const data = await res.json().catch(() => ({}));
        setError(data?.message ?? 'Failed to save.');
      }
    } finally {
      setSaving(false);
    }
  }

  async function handleEnroll() {
    if (!enrollId) return;
    const res = await enrollStudent(params.id, enrollId);
    if (res?.ok) { setEnrollId(''); load(); }
    else setError('Failed to enroll student.');
  }

  async function handleUnenroll(studentId, name) {
    if (!confirm(`Remove ${name} from this classroom?`)) return;
    const res = await unenrollStudent(params.id, studentId);
    if (res?.ok) load();
    else setError('Failed to remove student.');
  }

  if (loading) return <p className="text-gray-500 text-sm">Loading…</p>;
  if (!classroom) return <p className="text-red-500 text-sm">Classroom not found.</p>;

  const enrolledIds = new Set((classroom.students ?? []).map((s) => s.id));
  const available   = allStudents.filter((s) => !enrolledIds.has(s.id));

  return (
    <div className="max-w-2xl space-y-8">
      <h1 className="text-2xl font-bold">
        {classroom.className ?? classroom.name}
      </h1>

      {error && (
        <div className="bg-red-50 border border-red-200 text-red-700 text-sm rounded-md p-3">
          {error}
        </div>
      )}

      {/* Edit classroom details */}
      <section className="bg-white rounded-xl shadow-sm p-6">
        <h2 className="text-base font-semibold mb-4">Classroom Details</h2>
        <form onSubmit={handleSave} className="space-y-4">
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-1">Class Name</label>
            <input type="text" value={form.className}
              onChange={(e) => set('className', e.target.value)} className={inputCls} />
          </div>
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-1">Grade</label>
            <input type="text" value={form.grade}
              onChange={(e) => set('grade', e.target.value)} className={inputCls} />
          </div>
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-1">Teacher</label>
            <select value={form.teacherId} onChange={(e) => set('teacherId', e.target.value)}
              className={inputCls}>
              <option value="">— No teacher —</option>
              {teachers.map((t) => (
                <option key={t.id} value={t.id}>{t.firstName} {t.lastName}</option>
              ))}
            </select>
          </div>
          <div className="flex gap-3 pt-1">
            <button type="submit" disabled={saving}
              className="bg-blue-600 hover:bg-blue-700 disabled:bg-blue-400 text-white text-sm font-medium px-4 py-2 rounded-md transition-colors">
              {saving ? 'Saving…' : 'Save Changes'}
            </button>
            <button type="button" onClick={() => router.push('/classrooms')}
              className="text-sm text-gray-600 hover:text-gray-900 px-3 py-2">
              Back
            </button>
          </div>
        </form>
      </section>

      {/* Enrolled students */}
      <section className="bg-white rounded-xl shadow-sm p-6">
        <h2 className="text-base font-semibold mb-4">
          Enrolled Students ({(classroom.students ?? []).length})
        </h2>

        {/* Enroll a new student */}
        {available.length > 0 && (
          <div className="flex gap-2 mb-4">
            <select value={enrollId} onChange={(e) => setEnrollId(e.target.value)}
              className="flex-1 border border-gray-300 rounded-md px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-blue-500">
              <option value="">— Select student to enroll —</option>
              {available.map((s) => (
                <option key={s.id} value={s.id}>
                  {s.firstName} {s.lastName}
                </option>
              ))}
            </select>
            <button onClick={handleEnroll}
              className="bg-green-600 hover:bg-green-700 text-white text-sm font-medium px-4 py-2 rounded-md transition-colors whitespace-nowrap">
              Enroll
            </button>
          </div>
        )}

        {(classroom.students ?? []).length === 0 ? (
          <p className="text-gray-500 text-sm">No students enrolled yet.</p>
        ) : (
          <table className="w-full text-sm">
            <thead className="bg-gray-50 border-b border-gray-200">
              <tr>
                <th className="text-left px-3 py-2 font-medium text-gray-600">Name</th>
                <th className="px-3 py-2"></th>
              </tr>
            </thead>
            <tbody className="divide-y divide-gray-100">
              {(classroom.students ?? []).map((s) => (
                <tr key={s.id} className="hover:bg-gray-50">
                  <td className="px-3 py-2">{s.firstName} {s.lastName}</td>
                  <td className="px-3 py-2 text-right">
                    <button
                      onClick={() => handleUnenroll(s.id, `${s.firstName} ${s.lastName}`)}
                      className="text-red-500 hover:underline text-xs"
                    >
                      Remove
                    </button>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        )}
      </section>
    </div>
  );
}
