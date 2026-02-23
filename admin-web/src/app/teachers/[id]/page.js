'use client';
import { useEffect, useState } from 'react';
import { useRouter } from 'next/navigation';
import { useAuth } from '@/lib/auth';
import { getTeacher, updateTeacher } from '@/lib/api';

const inputCls =
  'w-full border border-gray-300 rounded-md px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-blue-500';

function Field({ label, required, children }) {
  return (
    <div>
      <label className="block text-sm font-medium text-gray-700 mb-1">
        {label}{required && <span className="text-red-500 ml-0.5">*</span>}
      </label>
      {children}
    </div>
  );
}

export default function EditTeacherPage({ params }) {
  useAuth();

  const router = useRouter();
  const [form,    setForm]    = useState(null);
  const [error,   setError]   = useState('');
  const [saving,  setSaving]  = useState(false);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    getTeacher(params.id).then((data) => {
      if (data) {
        setForm({
          firstName:   data.firstName   ?? '',
          lastName:    data.lastName    ?? '',
          subject:     data.subject     ?? '',
          phoneNumber: data.phoneNumber ?? '',
          dateOfBirth: data.dateOfBirth ? data.dateOfBirth.substring(0, 10) : '',
        });
      } else {
        setError('Teacher not found.');
      }
      setLoading(false);
    });
  }, [params.id]);

  function set(field, value) {
    setForm((prev) => ({ ...prev, [field]: value }));
  }

  async function handleSubmit(e) {
    e.preventDefault();
    setError('');
    setSaving(true);
    try {
      const res = await updateTeacher(params.id, form);
      if (res?.ok) {
        router.push('/teachers');
      } else {
        const data = await res.json().catch(() => ({}));
        setError(data?.message ?? data?.error ?? 'Failed to update teacher.');
      }
    } finally {
      setSaving(false);
    }
  }

  if (loading) return <p className="text-gray-500 text-sm">Loading…</p>;
  if (!form)   return <p className="text-red-500 text-sm">{error}</p>;

  return (
    <div className="max-w-lg">
      <h1 className="text-2xl font-bold mb-6">Edit Teacher</h1>

      {error && (
        <div className="bg-red-50 border border-red-200 text-red-700 text-sm rounded-md p-3 mb-4">
          {error}
        </div>
      )}

      <form onSubmit={handleSubmit} className="bg-white rounded-xl shadow-sm p-6 space-y-4">
        <Field label="First Name" required>
          <input type="text" required value={form.firstName}
            onChange={(e) => set('firstName', e.target.value)} className={inputCls} />
        </Field>

        <Field label="Last Name" required>
          <input type="text" required value={form.lastName}
            onChange={(e) => set('lastName', e.target.value)} className={inputCls} />
        </Field>

        <Field label="Subject">
          <input type="text" value={form.subject}
            onChange={(e) => set('subject', e.target.value)} className={inputCls} />
        </Field>

        <Field label="Phone Number">
          <input type="text" value={form.phoneNumber}
            onChange={(e) => set('phoneNumber', e.target.value)} className={inputCls} />
        </Field>

        <Field label="Date of Birth">
          <input type="date" value={form.dateOfBirth}
            onChange={(e) => set('dateOfBirth', e.target.value)} className={inputCls} />
        </Field>

        <div className="flex gap-3 pt-2">
          <button type="submit" disabled={saving}
            className="bg-blue-600 hover:bg-blue-700 disabled:bg-blue-400 text-white text-sm font-medium px-5 py-2 rounded-md transition-colors">
            {saving ? 'Saving…' : 'Save Changes'}
          </button>
          <button type="button" onClick={() => router.push('/teachers')}
            className="text-sm text-gray-600 hover:text-gray-900 px-3 py-2">
            Cancel
          </button>
        </div>
      </form>
    </div>
  );
}
