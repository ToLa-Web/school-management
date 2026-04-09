'use client';
import { useState } from 'react';
import { useRouter } from 'next/navigation';
import Link from 'next/link';
import { useAuth } from '@/lib/auth';
import { createTeacher } from '@/lib/api';
import { Users, ArrowLeft, AlertCircle, Save, User, Phone, BookOpen, Calendar, Mail, Briefcase, GraduationCap } from 'lucide-react';

const DEPARTMENT_SUBJECTS = {
  "Science": ["Physics", "Chemistry", "Biology", "Earth Science"],
  "Mathematics": ["Algebra", "Geometry", "Calculus", "Statistics"],
  "Arts & Humanities": ["History", "Literature", "Art", "Music"],
  "Languages": ["English", "Spanish", "French", "Mandarin"],
  "Physical Education": ["Health", "Sports", "Gym"],
  "Technology": ["Computer Science", "Information Technology", "Robotics"]
};

const defaultForm = {
  firstName: '',
  lastName: '',
  gender: '',
  dateOfBirth: '',
  phone: '',
  email: '',
  specialization: '',
  department: '',
  hireDate: '',
  isActive: true,
};

export default function NewTeacherPage() {
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
      const payload = { ...form };
      if (payload.dateOfBirth) {
        payload.dateOfBirth = new Date(payload.dateOfBirth).toISOString();
      }
      // HireDate should be sent as DateOnly format (YYYY-MM-DD), not ISO DateTime
      if (payload.hireDate) {
        payload.hireDate = payload.hireDate;
      } else {
        payload.hireDate = null;
      }
      // Ensure isActive is included
      payload.isActive = form.isActive ?? true;
      const res = await createTeacher(payload);
      if (res?.ok) {
        router.push('/admin/teachers');
      } else {
        const data = await res.json().catch(() => ({}));
        setError(data?.message ?? data?.error ?? 'Failed to create teacher.');
      }
    } finally {
      setSaving(false);
    }
  }

  return (
    <div className="max-w-lg admin-page">
      {/* Header */}
      <div className="flex items-center gap-3 mb-6">
        <Link
          href="/admin/teachers"
          className="p-2 text-slate-400 hover:text-slate-600 hover:bg-slate-100 rounded-lg transition-colors"
        >
          <ArrowLeft className="w-5 h-5" />
        </Link>
        <div className="admin-header-icon">
          <Users className="w-5 h-5 text-white" />
        </div>
        <div>
          <h1 className="text-2xl font-bold text-slate-900">New Teacher</h1>
          <p className="text-sm text-slate-500">Add a new teacher to the system</p>
        </div>
      </div>

      {error && (
        <div className="flex items-center gap-3 bg-red-50 border border-red-100 text-red-700 text-sm rounded-xl p-4 mb-4">
          <AlertCircle className="w-5 h-5 shrink-0" />
          {error}
        </div>
      )}

      <form onSubmit={handleSubmit} className="admin-section space-y-5">
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

        <div className="grid grid-cols-2 gap-4">
          <Field label="Gender" icon={<Users className="w-4 h-4" />}>
            <select
              value={form.gender}
              onChange={(e) => set('gender', e.target.value)}
              className={inputCls}
            >
              <option value="">Select gender</option>
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
        </div>

        <div className="grid grid-cols-2 gap-4">
          <Field label="Phone Number" icon={<Phone className="w-4 h-4" />}>
            <input
              type="text"
              value={form.phone}
              onChange={(e) => set('phone', e.target.value)}
              placeholder="+1 234 567 890"
              className={inputCls}
            />
          </Field>

          <Field label="Email" icon={<Mail className="w-4 h-4" />}>
            <input
              type="email"
              value={form.email}
              onChange={(e) => set('email', e.target.value)}
              placeholder="user@example.com"
              className={inputCls}
            />
          </Field>
        </div>

        <div className="grid grid-cols-2 gap-4">
          <Field label="Department" icon={<Briefcase className="w-4 h-4" />}>
            <input
              list="departments"
              value={form.department}
              onChange={(e) => setForm(prev => ({ ...prev, department: e.target.value, specialization: '' }))}
              placeholder="Select or type department"
              className={inputCls}
            />
            <datalist id="departments">
              {Object.keys(DEPARTMENT_SUBJECTS).map((dept) => (
                <option key={dept} value={dept} />
              ))}
            </datalist>
          </Field>

          <Field label="Specialization" icon={<GraduationCap className="w-4 h-4" />}>
            <input
              list={`specializations-${form.department}`}
              value={form.specialization}
              onChange={(e) => set('specialization', e.target.value)}
              placeholder={form.department ? "Select or type specialization" : "Select Department First"}
              className={inputCls}
              disabled={!form.department}
            />
            <datalist id={`specializations-${form.department}`}>
              {(DEPARTMENT_SUBJECTS[form.department] || []).map((subj) => (
                <option key={subj} value={subj} />
              ))}
            </datalist>
          </Field>
        </div>

        <Field label="Hire Date" icon={<Calendar className="w-4 h-4" />}>
          <input
            type="date"
            value={form.hireDate}
            onChange={(e) => set('hireDate', e.target.value)}
            className={inputCls}
          />
        </Field>

        <div className="flex items-center gap-3 py-2">
          <input type="checkbox" id="isActive" checked={form.isActive} onChange={(e) => set('isActive', e.target.checked)} className="h-4 w-4 rounded border-slate-300 text-slate-900 focus:ring-slate-400" />
          <label htmlFor="isActive" className="text-sm font-semibold text-slate-700">
            Active Teacher Account
          </label>
        </div>

        <div className="flex gap-3 pt-3">
          <button
            type="submit"
            disabled={saving}
            className="admin-btn-primary disabled:opacity-50"
          >
            {saving ? (
              <div className="w-4 h-4 border-2 border-white border-t-transparent rounded-full animate-spin" />
            ) : (
              <Save className="w-4 h-4" />
            )}
            {saving ? 'Saving...' : 'Create Teacher'}
          </button>
          <button
            type="button"
            onClick={() => router.push('/admin/teachers')}
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
  'admin-input';

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
