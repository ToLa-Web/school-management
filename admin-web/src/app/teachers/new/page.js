'use client';
import { useState } from 'react';
import { useRouter } from 'next/navigation';
import { useAuth } from '@/lib/auth';
import { createTeacher } from '@/lib/api';

const defaultForm = {
  firstName:   '',
  lastName:    '',
  subject:     '',
  phoneNumber: '',
  dateOfBirth: '',
};

export default function NewTeacherPage() {
  useAuth();

  const router = useRouter();
  const [form,    setForm]    = useState(defaultForm);
  const [error,   setError]   = useState('');
  const [saving,  setSaving]  = useState(false);

  function set(field, value) {
    setForm((prev) => ({ ...prev, [field]: value }));
  }

  async function handleSubmit(e) {
    e.preventDefault();
    setError('');
    setSaving(true);
    try {
      const res = await createTeacher(form);
      if (res?.ok) {
        router.push('/teachers');
      } else {
        const data = await res.json().catch(() => ({}));
        setError(data?.message ?? data?.error ?? 'Failed to create teacher.');
      }
    } finally {
      setSaving(false);
    }
  }

  return (
    <div className="max-w-lg">
      <h1 className="text-2xl font-bold mb-6">New Teacher</h1>

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

        <Field label="Subject">
          <input
            type="text"
            value={form.subject}
            onChange={(e) => set('subject', e.target.value)}
            className={inputCls}
          />
        </Field>

        <Field label="Phone Number">
          <input
            type="text"
            value={form.phoneNumber}
            onChange={(e) => set('phoneNumber', e.target.value)}
            className={inputCls}
          />
        </Field>

        <Field label="Date of Birth">
          <input
            type="date"
            value={form.dateOfBirth}
            onChange={(e) => set('dateOfBirth', e.target.value)}
            className={inputCls}
          />
        </Field>

        <div className="flex gap-3 pt-2">
          <button
            type="submit"
            disabled={saving}
            className="bg-blue-600 hover:bg-blue-700 disabled:bg-blue-400 text-white text-sm font-medium px-5 py-2 rounded-md transition-colors"
          >
            {saving ? 'Saving…' : 'Create Teacher'}
          </button>
          <button
            type="button"
            onClick={() => router.push('/teachers')}
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
