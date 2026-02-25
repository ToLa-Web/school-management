'use client';
import { useEffect, useState } from 'react';
import { useRouter, useParams } from 'next/navigation';
import { useAuth } from '@/lib/auth';
import { getStudent, updateStudent } from '@/lib/api';

export default function EditStudentPage() {
  useAuth();

  const router = useRouter();
  const { id } = useParams();

  const [form, setForm] = useState(null);
  const [error, setError] = useState('');
  const [saving, setSaving] = useState(false);

  useEffect(() => {
    getStudent(id).then((data) => {
      if (data) {
        setForm({
          firstName:   data.firstName ?? '',
          lastName:    data.lastName ?? '',
          gender:      data.gender ?? '',
          dateOfBirth: data.dateOfBirth ? data.dateOfBirth.slice(0, 10) : '',
          phone:       data.phone ?? '',
          address:     data.address ?? '',
        });
      }
    });
  }, [id]);

  function set(field, value) {
    setForm((prev) => ({ ...prev, [field]: value }));
  }

  async function handleSubmit(e) {
    e.preventDefault();
    setError('');
    setSaving(true);
    try {
      const res = await updateStudent(id, form);
      if (res?.ok) {
        router.push('/students');
      } else {
        const data = await res.json().catch(() => ({}));
        setError(data?.message ?? data?.error ?? 'Failed to update student.');
      }
    } finally {
      setSaving(false);
    }
  }

  if (!form) return <p className="text-gray-500 text-sm">Loading…</p>;

  return (
    <div className="max-w-lg">
      <h1 className="text-2xl font-bold mb-6">Edit Student</h1>

      {error && (
        <div className="bg-red-50 border border-red-200 text-red-700 text-sm rounded-md p-3 mb-4">
          {error}
        </div>
      )}

      <form onSubmit={handleSubmit} className="bg-white rounded-xl shadow-sm p-6 space-y-4">
        <Field label="First Name" required>
          <input
            type="text" required
            value={form.firstName}
            onChange={(e) => set('firstName', e.target.value)}
            className={inputCls}
          />
        </Field>

        <Field label="Last Name" required>
          <input
            type="text" required
            value={form.lastName}
            onChange={(e) => set('lastName', e.target.value)}
            className={inputCls}
          />
        </Field>

        <Field label="Gender">
          <select
            value={form.gender}
            onChange={(e) => set('gender', e.target.value)}
            className={inputCls}
          >
            <option value="">Select…</option>
            <option value="Male">Male</option>
            <option value="Female">Female</option>
            <option value="Other">Other</option>
          </select>
        </Field>

        <Field label="Date of Birth">
          <input
            type="date"
            value={form.dateOfBirth}
            onChange={(e) => set('dateOfBirth', e.target.value)}
            className={inputCls}
          />
        </Field>

        <Field label="Phone">
          <input
            type="text"
            value={form.phone}
            onChange={(e) => set('phone', e.target.value)}
            className={inputCls}
          />
        </Field>

        <Field label="Address">
          <input
            type="text"
            value={form.address}
            onChange={(e) => set('address', e.target.value)}
            className={inputCls}
          />
        </Field>

        <div className="flex gap-3 pt-2">
          <button
            type="submit"
            disabled={saving}
            className="bg-blue-600 hover:bg-blue-700 disabled:bg-blue-400 text-white text-sm font-medium px-5 py-2 rounded-md transition-colors"
          >
            {saving ? 'Saving…' : 'Update Student'}
          </button>
          <button
            type="button"
            onClick={() => router.push('/students')}
            className="text-sm text-gray-600 hover:text-gray-900 px-3 py-2"
          >
            Cancel
          </button>
        </div>
      </form>
    </div>
  );
}

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
