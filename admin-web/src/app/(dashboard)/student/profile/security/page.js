'use client';

import { useEffect, useMemo, useState } from 'react';
import { useRouter } from 'next/navigation';
import { KeyRound, ShieldCheck } from 'lucide-react';
import { changePassword } from '@/lib/api';
import { useAuth } from '@/lib/auth';
import StudentPageShell from '@/components/StudentPageShell';
import StudentSectionCard from '@/components/StudentSectionCard';
import StudentToast from '@/components/StudentToast';
import { calculatePasswordStrength, loadStudentBaseData } from '@/lib/student-portal';

export default function StudentProfileSecurityPage() {
  useAuth([2]);

  const router = useRouter();
  const [state, setState] = useState({
    loading: true,
    error: '',
    user: null,
    student: null,
  });
  const [form, setForm] = useState({
    currentPassword: '',
    newPassword: '',
    confirmPassword: '',
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
    }

    load();
    return () => {
      active = false;
    };
  }, []);

  const strength = useMemo(() => calculatePasswordStrength(form.newPassword), [form.newPassword]);

  async function handleSubmit(event) {
    event.preventDefault();

    if (!state.user?.userId) {
      setToast({
        open: true,
        tone: 'error',
        title: 'Please sign in again',
        message: 'This session does not include the auth user identifier needed to change your password.',
      });
      return;
    }

    if (form.newPassword !== form.confirmPassword) {
      setToast({
        open: true,
        tone: 'error',
        title: 'Passwords do not match',
        message: 'Make sure the new password and confirmation are identical before saving.',
      });
      return;
    }

    setSaving(true);
    try {
      const response = await changePassword({
        userId: state.user.userId,
        currentPassword: form.currentPassword,
        newPassword: form.newPassword,
      });

      if (!response.ok) {
        const body = await response.json().catch(() => ({}));
        throw new Error(body?.message ?? body?.error ?? 'Password change failed.');
      }

      setToast({
        open: true,
        tone: 'success',
        title: 'Password changed',
        message: 'You will be redirected to sign in again so the new credentials take effect cleanly.',
      });

      setTimeout(() => {
        localStorage.removeItem('token');
        localStorage.removeItem('refreshToken');
        localStorage.removeItem('user');
        router.replace('/login');
      }, 1200);
    } catch (error) {
      setToast({
        open: true,
        tone: 'error',
        title: 'Change failed',
        message: error.message || 'Password change failed.',
      });
    } finally {
      setSaving(false);
    }
  }

  if (state.loading) {
    return (
      <div className="rounded-[1.8rem] border border-slate-200/70 bg-white/85 p-12 text-center shadow-sm">
        <div className="mx-auto h-8 w-8 animate-spin rounded-full border-2 border-[#526d82] border-t-transparent" />
        <p className="mt-4 text-sm text-slate-500">Loading security settings...</p>
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
        title="Security"
        description="Rotate your password here and keep your student account credentials current."
        breadcrumbs={[
          { label: 'Student', href: '/student/dashboard' },
          { label: 'Profile', href: '/student/profile' },
          { label: 'Security' },
        ]}
        user={state.user}
        student={state.student}
      >
        {state.error ? (
          <div className="rounded-2xl border border-rose-200 bg-rose-50 px-4 py-4 text-sm text-rose-700">{state.error}</div>
        ) : null}

        <section className="grid gap-6 xl:grid-cols-[0.95fr_1.05fr]">
          <StudentSectionCard icon={KeyRound} title="Change Password" subtitle="Current password is required before the new password can be saved.">
            <form onSubmit={handleSubmit} className="space-y-5">
              <label className="block text-sm font-medium text-slate-700">
                Current Password
                <input
                  type="password"
                  required
                  value={form.currentPassword}
                  onChange={(event) => setForm((current) => ({ ...current, currentPassword: event.target.value }))}
                  className="admin-input mt-2"
                />
              </label>

              <label className="block text-sm font-medium text-slate-700">
                New Password
                <input
                  type="password"
                  required
                  value={form.newPassword}
                  onChange={(event) => setForm((current) => ({ ...current, newPassword: event.target.value }))}
                  className="admin-input mt-2"
                />
              </label>

              <label className="block text-sm font-medium text-slate-700">
                Confirm Password
                <input
                  type="password"
                  required
                  value={form.confirmPassword}
                  onChange={(event) => setForm((current) => ({ ...current, confirmPassword: event.target.value }))}
                  className="admin-input mt-2"
                />
              </label>

              <div className="rounded-[1.4rem] border border-slate-200/70 bg-slate-50/80 p-4">
                <div className="flex items-center justify-between gap-3">
                  <p className="text-sm font-medium text-slate-700">Password strength</p>
                  <span className="text-sm font-semibold text-slate-900">{strength.label}</span>
                </div>
                <div className="mt-3 h-2.5 overflow-hidden rounded-full bg-white">
                  <div
                    className={`h-full rounded-full ${
                      strength.tone === 'success' ? 'bg-emerald-500' : strength.tone === 'warning' ? 'bg-amber-500' : 'bg-rose-500'
                    }`}
                    style={{ width: `${Math.max((strength.score / 5) * 100, form.newPassword ? 10 : 0)}%` }}
                  />
                </div>
              </div>

              <button type="submit" disabled={saving} className="admin-btn-primary disabled:cursor-not-allowed disabled:opacity-60">
                {saving ? (
                  <div className="h-4 w-4 animate-spin rounded-full border-2 border-white border-t-transparent" />
                ) : (
                  <ShieldCheck className="h-4 w-4" />
                )}
                {saving ? 'Saving...' : 'Change Password'}
              </button>
            </form>
          </StudentSectionCard>

          <StudentSectionCard icon={ShieldCheck} title="Sessions" subtitle="Session-by-session device management can plug in here when the auth API exposes it.">
            <div className="space-y-4">
              <div className="rounded-[1.4rem] border border-slate-200/70 bg-white/80 p-4">
                <p className="text-sm font-semibold text-slate-900">Current browser session</p>
                <p className="mt-2 text-sm text-slate-600">This page is using your current local session token. After a successful password change, you will be redirected to sign in again.</p>
              </div>
              <div className="rounded-[1.4rem] border border-dashed border-slate-200 bg-slate-50/80 p-4 text-sm text-slate-500">
                The backend currently supports password rotation but does not yet expose a list of active sessions with device-level logout actions.
              </div>
            </div>
          </StudentSectionCard>
        </section>
      </StudentPageShell>
    </>
  );
}
