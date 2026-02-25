'use client';
import { useState } from 'react';
import { useRouter } from 'next/navigation';
import Link from 'next/link';
import { useAuth } from '@/lib/auth';
import { createStudent } from '@/lib/api';
import { GraduationCap, ArrowLeft, AlertCircle, Save, User, Phone, Calendar, MapPin, Users } from 'lucide-react';

const defaultForm = {
  firstName: '',
  lastName: '',
  gender: '',
  dateOfBirth: '',
  phone: '',
  address: '',
};

export default function NewStudentPage() {
  useAuth();

  const router = useRouter();
  const [form, setForm] = useState(defaultForm);
  const [error, setError] = useState('');
  const [saving, setSaving] = useState(false);

  function set(field, value) {
    setForm((prev) => ({ ...prev, [field]: value }));
  }

  async function handleSubmit(e) {
    e.preventDefault();
    setError('');
    setSaving(true);
    try {
      const res = await createStudent(form);
      if (res?.ok) {
        router.push('/students');
      } else {
        const data = await res.json().catch(() => ({}));
        setError(data?.message ?? data?.error ?? 'Failed to create student.');
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
          href="/students"
          className="p-2 text-slate-400 hover:text-slate-600 hover:bg-slate-100 rounded-lg transition-colors"
        >
          <ArrowLeft className="w-5 h-5" />
        </Link>
        <div className="w-10 h-10 rounded-xl bg-gradient-to-br from-amber-500 to-orange-500 flex items-center justify-center">
          <GraduationCap className="w-5 h-5 text-white" />
        </div>
        <div>
          <h1 className="text-2xl font-bold text-slate-900">New Student</h1>
          <p className="text-sm text-slate-500">Add a new student to the system</p>
        </div>
      </div>

      {error && (
        <div className="flex items-center gap-3 bg-red-50 border border-red-100 text-red-700 text-sm rounded-xl p-4 mb-4">
          <AlertCircle className="w-5 h-5 shrink-0" />
          {error}
        </div>
      )}

      <form onSubmit={handleSubmit} className="bg-white rounded-2xl border border-slate-100 shadow-sm p-6 space-y-5">
        <div className="grid grid-cols-2 gap-4">
          <Field label="First Name" required icon={<User className="w-4 h-4" />}>
            <input
              type="text" required
              value={form.firstName}
              onChange={(e) => set('firstName', e.target.value)}
              placeholder="John"
              className={inputCls}
            />
          </Field>

          <Field label="Last Name" required icon={<User className="w-4 h-4" />}>
            <input
              type="text" required
              value={form.lastName}
              onChange={(e) => set('lastName', e.target.value)}
              placeholder="Doe"
              className={inputCls}
            />
          </Field>
        </div>

        <Field label="Gender" icon={<Users className="w-4 h-4" />}>
          <select
            value={form.gender}
            onChange={(e) => set('gender', e.target.value)}
            className={inputCls}
          >
            <option value="">Select gender...</option>
            <option value="Male">Male</option>
            <option value="Female">Female</option>
            <option value="Other">Other</option>
          </select>
        </Field>

        <Field label="Date of Birth" icon={<Calendar className="w-4 h-4" />}>
          <input
            type="date"
            value={form.dateOfBirth}
            onChange={(e) => set('dateOfBirth', e.target.value)}
            className={inputCls}
          />
        </Field>

        <Field label="Phone" icon={<Phone className="w-4 h-4" />}>
          <input
            type="text"
            value={form.phone}
            onChange={(e) => set('phone', e.target.value)}
            placeholder="+1 234 567 890"
            className={inputCls}
          />
        </Field>

        <Field label="Address" icon={<MapPin className="w-4 h-4" />}>
          <input
            type="text"
            value={form.address}
            onChange={(e) => set('address', e.target.value)}
            placeholder="123 Main St, City"
            className={inputCls}
          />
        </Field>

        <div className="flex gap-3 pt-3">
          <button
            type="submit"
            disabled={saving}
            className="bg-gradient-to-r from-amber-500 to-orange-500 hover:from-amber-600 hover:to-orange-600 disabled:opacity-50 text-white text-sm font-medium px-5 py-2.5 rounded-xl shadow-lg shadow-amber-500/20 transition-all flex items-center gap-2"
          >
            {saving ? (
              <div className="w-4 h-4 border-2 border-white border-t-transparent rounded-full animate-spin" />
            ) : (
              <Save className="w-4 h-4" />
            )}
            {saving ? 'Saving...' : 'Create Student'}
          </button>
          <button
            type="button"
            onClick={() => router.push('/students')}
            className="text-slate-600 hover:text-slate-800 text-sm font-medium px-5 py-2.5 rounded-xl border border-slate-200 hover:bg-slate-50 transition-colors"
          >
            Cancel
          </button>
        </div>
      </form>
    </div>
  );
}

const inputCls =
  'w-full border border-slate-200 rounded-xl px-3 py-2.5 text-sm focus:outline-none focus:ring-2 focus:ring-amber-500 focus:border-transparent bg-slate-50 placeholder:text-slate-400';

function Field({ label, required, icon, children }) {
  return (
    <div>
      <label className="flex items-center gap-1.5 text-sm font-semibold text-slate-700 mb-1.5">
        {icon && <span className="text-slate-400">{icon}</span>}
        {label}{required && <span className="text-red-500 ml-0.5">*</span>}
      </label>
      {children}
    </div>
  );
}
