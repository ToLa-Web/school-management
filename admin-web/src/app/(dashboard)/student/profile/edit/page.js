'use client';

import { useEffect, useState } from 'react';
import { useRouter } from 'next/navigation';
import { Save } from 'lucide-react';
import { updateStudent } from '@/lib/api';
import { useAuth } from '@/lib/auth';
import StudentPageShell from '@/components/StudentPageShell';
import StudentSectionCard from '@/components/StudentSectionCard';
import StudentToast from '@/components/StudentToast';
import { loadStudentBaseData } from '@/lib/student-portal';

export default function StudentProfileEditPage() {
  useAuth([2]);

  const router = useRouter();
  const [state, setState] = useState({
    loading: true,
    error: '',
    user: null,
    student: null,
  });
  const [form, setForm] = useState({
    firstName: '',
    lastName: '',
    gender: '',
    dateOfBirth: '',
    email: '',
    phone: '',
    address: '',
  });
  const [saving, setSaving] = useState(false);
  const [toast, setToast] = useState({ open: false, tone: 'success', title: '', message: '' });

  useEffect(() => {
    let active = true;

    async function load() {
      const base = await loadStudentBaseData();
      if (!active) return;

      setState({
        loading: false,
        error: base.student ? '' : 'Student profile not found.',
        user: base.user,
        student: base.student,
      });

      if (base.student) {
        setForm({
          firstName: base.student.firstName ?? '',
          lastName: base.student.lastName ?? '',
          gender: base.student.gender ?? '',
          dateOfBirth: base.student.dateOfBirth ? String(base.student.dateOfBirth).slice(0, 10) : '',
          email: base.student.email ?? base.user?.email ?? '',
          phone: base.student.phone ?? '',
          address: base.student.address ?? '',
        });
      }
    }

    load();
    return () => {
      active = false;
    };
  }, []);

  async function handleSave(event) {
    event.preventDefault();
    if (!state.student) return;

    setSaving(true);
    try {
      const response = await updateStudent(state.student.id, {
        firstName: form.firstName,
        lastName: form.lastName,
        gender: form.gender || null,
        dateOfBirth: form.dateOfBirth || null,
        email: form.email || null,
        phone: form.phone || null,
        address: form.address || null,
        isActive: state.student.isActive,
      });

      if (!response.ok) {
        const body = await response.json().catch(() => ({}));
        throw new Error(body?.message ?? body?.error ?? 'The profile could not be updated.');
      }

      setToast({
        open: true,
        tone: 'success',
        title: 'Profile updated',
        message: 'Your student profile has been saved successfully.',
      });
      setTimeout(() => router.push('/student/profile'), 700);
    } catch (error) {
      setToast({
        open: true,
        tone: 'error',
        title: 'Update failed',
        message: error.message || 'The profile could not be updated.',
      });
    } finally {
      setSaving(false);
    }
  }

  if (state.loading) {
    return (
      <div className="rounded-[1.8rem] border border-slate-200/70 bg-white/85 p-12 text-center shadow-sm">
        <div className="mx-auto h-8 w-8 animate-spin rounded-full border-2 border-[#526d82] border-t-transparent" />
        <p className="mt-4 text-sm text-slate-500">Loading profile editor...</p>
      </div>
    );
  }

  return (
    <>
      <StudentToast
        open={toast.open}
        tone={toast.tone}
        title={toast.title}
        message={toast.message}
        onClose={() => setToast((current) => ({ ...current, open: false }))}
      />

      <StudentPageShell
        title="Edit Profile"
        description="Update the student profile fields currently supported by the school service."
        breadcrumbs={[
          { label: 'Student', href: '/student/dashboard' },
          { label: 'Profile', href: '/student/profile' },
          { label: 'Edit' },
        ]}
        user={state.user}
        student={state.student}
      >
        {state.error ? (
          <div className="rounded-2xl border border-rose-200 bg-rose-50 px-4 py-4 text-sm text-rose-700">{state.error}</div>
        ) : null}

        <StudentSectionCard title="Personal Information" subtitle="First and last name are required. The remaining fields are optional.">
          <form onSubmit={handleSave} className="space-y-5">
            <div className="grid gap-4 md:grid-cols-2">
              <label className="text-sm font-medium text-slate-700">
                First Name
                <input required value={form.firstName} onChange={(event) => setForm((current) => ({ ...current, firstName: event.target.value }))} className="admin-input mt-2" />
              </label>
              <label className="text-sm font-medium text-slate-700">
                Last Name
                <input required value={form.lastName} onChange={(event) => setForm((current) => ({ ...current, lastName: event.target.value }))} className="admin-input mt-2" />
              </label>
            </div>

            <div className="grid gap-4 md:grid-cols-2">
              <label className="text-sm font-medium text-slate-700">
                Gender
                <select value={form.gender} onChange={(event) => setForm((current) => ({ ...current, gender: event.target.value }))} className="admin-input mt-2">
                  <option value="">Select gender</option>
                  <option value="Male">Male</option>
                  <option value="Female">Female</option>
                  <option value="Other">Other</option>
                </select>
              </label>
              <label className="text-sm font-medium text-slate-700">
                Date of Birth
                <input type="date" value={form.dateOfBirth} onChange={(event) => setForm((current) => ({ ...current, dateOfBirth: event.target.value }))} className="admin-input mt-2" />
              </label>
            </div>

            <div className="grid gap-4 md:grid-cols-2">
              <label className="text-sm font-medium text-slate-700">
                Email
                <input type="email" value={form.email} onChange={(event) => setForm((current) => ({ ...current, email: event.target.value }))} className="admin-input mt-2" />
              </label>
              <label className="text-sm font-medium text-slate-700">
                Phone
                <input value={form.phone} onChange={(event) => setForm((current) => ({ ...current, phone: event.target.value }))} className="admin-input mt-2" />
              </label>
            </div>

            <label className="block text-sm font-medium text-slate-700">
              Address
              <textarea value={form.address} onChange={(event) => setForm((current) => ({ ...current, address: event.target.value }))} className="admin-input mt-2 min-h-[8rem]" />
            </label>

            <div className="rounded-[1.4rem] border border-dashed border-slate-200 bg-slate-50/80 p-4 text-sm text-slate-500">
              Emergency contact fields are not persisted yet because the current student API only exposes core profile attributes. The form will expand automatically once those backend fields are available.
            </div>

            <div className="flex flex-wrap gap-3">
              <button type="submit" disabled={saving} className="admin-btn-primary disabled:cursor-not-allowed disabled:opacity-60">
                {saving ? (
                  <div className="h-4 w-4 animate-spin rounded-full border-2 border-white border-t-transparent" />
                ) : (
                  <Save className="h-4 w-4" />
                )}
                {saving ? 'Saving...' : 'Save Changes'}
              </button>
              <button type="button" onClick={() => router.push('/student/profile')} className="admin-btn-secondary">
                Cancel
              </button>
            </div>
          </form>
        </StudentSectionCard>
      </StudentPageShell>
    </>
  );
}
