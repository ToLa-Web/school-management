'use client';

import Link from 'next/link';
import { useEffect, useState } from 'react';
import { GraduationCap, Pencil, ShieldCheck, UserCircle2 } from 'lucide-react';
import { useAuth } from '@/lib/auth';
import StudentPageShell from '@/components/StudentPageShell';
import StudentSectionCard from '@/components/StudentSectionCard';
import StudentStatusBadge from '@/components/StudentStatusBadge';
import { formatDate, loadStudentBaseData } from '@/lib/student-portal';
import { formatStudentId } from '@/lib/id-formatter';

export default function StudentProfilePage() {
  useAuth([2]);

  const [state, setState] = useState({
    loading: true,
    error: '',
    user: null,
    student: null,
    classrooms: [],
  });

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
        classrooms: base.classrooms,
      });
    }

    load();
    return () => {
      active = false;
    };
  }, []);

  if (state.loading) {
    return (
      <div className="rounded-[1.8rem] border border-slate-200/70 bg-white/85 p-12 text-center shadow-sm">
        <div className="mx-auto h-8 w-8 animate-spin rounded-full border-2 border-[#526d82] border-t-transparent" />
        <p className="mt-4 text-sm text-slate-500">Loading your profile...</p>
      </div>
    );
  }

  return (
    <StudentPageShell
      title="Profile"
      description="Review your student record, check current enrollment status, and jump into personal or security updates."
      breadcrumbs={[
        { label: 'Student', href: '/student/dashboard' },
        { label: 'Profile' },
      ]}
      user={state.user}
      student={state.student}
      actions={
        <>
          <Link href="/student/profile/edit" className="admin-btn-secondary">
            <Pencil className="h-4 w-4" />
            Edit Profile
          </Link>
          <Link href="/student/profile/security" className="admin-btn-primary">
            <ShieldCheck className="h-4 w-4" />
            Security
          </Link>
        </>
      }
    >
      {state.error ? (
        <div className="rounded-2xl border border-rose-200 bg-rose-50 px-4 py-4 text-sm text-rose-700">{state.error}</div>
      ) : null}

      {state.student ? (
        <section className="grid gap-6 xl:grid-cols-[1fr_0.95fr]">
          <StudentSectionCard
            icon={UserCircle2}
            title="Student Information"
            subtitle="Core account and contact details from the school profile."
          >
            <div className="grid gap-4 sm:grid-cols-2">
              {[
                ['Name', `${state.student.firstName} ${state.student.lastName}`],
                ['Email', state.student.email || state.user?.email || 'Not provided'],
                ['Phone', state.student.phone || 'Not provided'],
                ['Date of birth', state.student.dateOfBirth ? formatDate(state.student.dateOfBirth) : 'Not provided'],
                ['Gender', state.student.gender || 'Not provided'],
                ['Address', state.student.address || 'Not provided'],
              ].map(([label, value]) => (
                <div key={label} className="rounded-[1.4rem] border border-slate-200/70 bg-white/80 p-4">
                  <p className="text-xs font-semibold uppercase tracking-[0.16em] text-slate-500">{label}</p>
                  <p className="mt-3 text-sm leading-6 text-slate-700">{value}</p>
                </div>
              ))}
            </div>
          </StudentSectionCard>

          <div className="space-y-6">
            <StudentSectionCard
              icon={GraduationCap}
              title="Enrollment"
              subtitle="High-level status from your visible classroom and student records."
            >
              <div className="grid gap-4 sm:grid-cols-2">
                <div className="rounded-[1.4rem] border border-slate-200/70 bg-white/80 p-4">
                  <p className="text-xs font-semibold uppercase tracking-[0.16em] text-slate-500">Student ID</p>
                  <p className="mt-3 text-sm font-medium text-slate-900">{formatStudentId(state.student.id)}</p>
                </div>
                <div className="rounded-[1.4rem] border border-slate-200/70 bg-white/80 p-4">
                  <p className="text-xs font-semibold uppercase tracking-[0.16em] text-slate-500">Enrollment Status</p>
                  <div className="mt-3">
                    <StudentStatusBadge label={state.student.isActive ? 'Active' : 'Inactive'} tone={state.student.isActive ? 'success' : 'danger'} />
                  </div>
                </div>
                <div className="rounded-[1.4rem] border border-slate-200/70 bg-white/80 p-4">
                  <p className="text-xs font-semibold uppercase tracking-[0.16em] text-slate-500">Current Classrooms</p>
                  <p className="mt-3 text-2xl font-semibold tracking-tight text-slate-950">{state.classrooms.length}</p>
                </div>
                <div className="rounded-[1.4rem] border border-slate-200/70 bg-white/80 p-4">
                  <p className="text-xs font-semibold uppercase tracking-[0.16em] text-slate-500">Profile Created</p>
                  <p className="mt-3 text-sm font-medium text-slate-900">{formatDate(state.student.createdAt)}</p>
                </div>
              </div>
            </StudentSectionCard>

            <StudentSectionCard
              icon={ShieldCheck}
              title="Family and Security"
              subtitle="Parent linkage and session records can plug in here as those APIs become available."
            >
              <div className="space-y-4">
                <div className="rounded-[1.4rem] border border-dashed border-slate-200 bg-slate-50/80 p-4 text-sm text-slate-500">
                  Connected parent support is not currently exposed by the backend, so this section will expand automatically once parent-role data is available.
                </div>
                <div className="rounded-[1.4rem] border border-dashed border-slate-200 bg-slate-50/80 p-4 text-sm text-slate-500">
                  Use the security page to rotate your password. Session-by-session device management can be added here when the auth service exposes active session records.
                </div>
              </div>
            </StudentSectionCard>
          </div>
        </section>
      ) : null}
    </StudentPageShell>
  );
}
