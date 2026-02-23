'use client';
import { useEffect, useState } from 'react';
import { useRouter } from 'next/navigation';
import { useAuth } from '@/lib/auth';
import { createClassroom, getTeachers } from '@/lib/api';

const inputCls =
  'w-full border border-gray-300 rounded-md px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-blue-500';

export default function NewClassroomPage() {
  useAuth();

  const router  = useRouter();
  const [form,    setForm]    = useState({ className: '', grade: '', teacherId: '' });
  const [teachers, setTeachers] = useState([]);
  const [error,   setError]   = useState('');
  const [saving,  setSaving]  = useState(false);

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
      <h1 className="text-2xl font-bold mb-6">New Classroom</h1>

      {error && (
        <div className="bg-red-50 border border-red-200 text-red-700 text-sm rounded-md p-3 mb-4">
          {error}
        </div>
      )}

      <form onSubmit={handleSubmit} className="bg-white rounded-xl shadow-sm p-6 space-y-4">
        <div>
          <label className="block text-sm font-medium text-gray-700 mb-1">
            Class Name <span className="text-red-500">*</span>
          </label>
          <input type="text" required value={form.className}
            onChange={(e) => set('className', e.target.value)}
            placeholder="e.g. Class A" className={inputCls} />
        </div>

        <div>
          <label className="block text-sm font-medium text-gray-700 mb-1">Grade</label>
          <input type="text" value={form.grade}
            onChange={(e) => set('grade', e.target.value)}
            placeholder="e.g. Grade 10" className={inputCls} />
        </div>

        <div>
          <label className="block text-sm font-medium text-gray-700 mb-1">Assign Teacher</label>
          <select
            value={form.teacherId}
            onChange={(e) => set('teacherId', e.target.value)}
            className={inputCls}
          >
            <option value="">— No teacher yet —</option>
            {teachers.map((t) => (
              <option key={t.id} value={t.id}>
                {t.firstName} {t.lastName}
              </option>
            ))}
          </select>
        </div>

        <div className="flex gap-3 pt-2">
          <button type="submit" disabled={saving}
            className="bg-blue-600 hover:bg-blue-700 disabled:bg-blue-400 text-white text-sm font-medium px-5 py-2 rounded-md transition-colors">
            {saving ? 'Saving…' : 'Create Classroom'}
          </button>
          <button type="button" onClick={() => router.push('/classrooms')}
            className="text-sm text-gray-600 hover:text-gray-900 px-3 py-2">
            Cancel
          </button>
        </div>
      </form>
    </div>
  );
}
