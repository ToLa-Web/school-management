'use client';

import Link from 'next/link';
import { ChevronRight, LogOut, UserCircle2 } from 'lucide-react';
import { logout } from '@/lib/auth';
import { getDisplayName, getInitials } from '@/lib/student-portal';
import { formatStudentId } from '@/lib/id-formatter';

function Breadcrumbs({ items }) {
  if (!items?.length) return null;

  return (
    <div className="flex flex-wrap items-center gap-2 text-xs font-semibold uppercase tracking-[0.16em] text-slate-500">
      {items.map((item, index) => (
        <div key={`${item.label}-${index}`} className="flex items-center gap-2">
          {item.href ? (
            <Link href={item.href} className="transition hover:text-slate-900">
              {item.label}
            </Link>
          ) : (
            <span className="text-slate-900">{item.label}</span>
          )}
          {index < items.length - 1 ? <ChevronRight className="h-3.5 w-3.5" /> : null}
        </div>
      ))}
    </div>
  );
}

export default function StudentPageShell({ title, description, breadcrumbs = [], user, student, actions = null, children }) {
  const displayName = getDisplayName(student, user);
  const studentId = student?.id ? formatStudentId(student.id) : null;

  return (
    <div className="space-y-8">
      <section className="relative overflow-hidden rounded-[2rem] border border-slate-200/70 bg-[linear-gradient(135deg,#f7fafb_0%,#eef3f6_52%,#e2ebf0_100%)] p-6 shadow-[0_24px_80px_-48px_rgba(15,23,42,0.45)] sm:p-8">
        <div className="absolute right-[-12%] top-[-20%] h-64 w-64 rounded-full bg-white/45 blur-3xl" />
        <div className="absolute bottom-[-28%] left-[-6%] h-56 w-56 rounded-full bg-slate-200/60 blur-3xl" />

        <div className="relative flex flex-col gap-6 xl:flex-row xl:items-end xl:justify-between">
          <div className="max-w-3xl">
            <Breadcrumbs items={breadcrumbs} />
            <h1 className="mt-4 text-3xl font-semibold tracking-tight text-slate-950 sm:text-4xl">{title}</h1>
            <p className="mt-3 max-w-2xl text-sm leading-6 text-slate-600 sm:text-base">{description}</p>
            {actions ? <div className="relative mt-6 flex flex-wrap gap-3">{actions}</div> : null}
          </div>

          <div className="w-full max-w-md rounded-[1.6rem] border border-white/75 bg-white/72 p-3 shadow-[0_18px_45px_-34px_rgba(15,23,42,0.45)] backdrop-blur xl:min-w-[22rem]">
            <div className="rounded-[1.3rem] border border-slate-200/75 bg-white/92 p-4 shadow-sm">
              <div className="flex items-start gap-3">
                <div className="flex h-14 w-14 shrink-0 items-center justify-center rounded-[1.2rem] bg-[#526d82] text-base font-semibold text-white shadow-inner shadow-slate-950/10">
                  {getInitials(student, user)}
                </div>

                <div className="min-w-0 flex-1">
                  <div className="flex flex-wrap items-center gap-2">
                    <p className="truncate text-base font-semibold tracking-tight text-slate-950">{displayName}</p>
                    <span className="inline-flex items-center gap-1 rounded-full bg-slate-100 px-2.5 py-1 text-[10px] font-semibold uppercase tracking-[0.18em] text-slate-600">
                      <UserCircle2 className="h-3.5 w-3.5" />
                      Student
                    </span>
                  </div>

                  <p className="mt-1 truncate text-sm text-slate-600">{student?.email ?? user?.email ?? 'Student account'}</p>

                  <div className="mt-3 flex flex-wrap items-center gap-2">
                    {studentId ? (
                      <span className="inline-flex rounded-full border border-slate-200 bg-slate-50 px-3 py-1 text-[11px] font-semibold uppercase tracking-[0.16em] text-slate-500">
                        ID {studentId}
                      </span>
                    ) : null}
                    <span className="inline-flex rounded-full border border-emerald-200/80 bg-emerald-50 px-3 py-1 text-[11px] font-semibold text-emerald-700">
                      Active session
                    </span>
                  </div>
                </div>
              </div>

              <div className="mt-4 flex flex-col gap-3 border-t border-slate-200/80 pt-4 sm:flex-row sm:items-center sm:justify-between">
                <div>
                  <p className="text-[11px] font-semibold uppercase tracking-[0.18em] text-slate-400">Student workspace</p>
                  <p className="mt-1 text-sm text-slate-600">Quick access to classes, grades, and daily updates.</p>
                </div>

                <button
                  type="button"
                  onClick={logout}
                  className="inline-flex items-center justify-center gap-2 rounded-2xl border border-slate-300 bg-slate-900 px-4 py-2.5 text-sm font-semibold text-white transition hover:bg-slate-800"
                >
                  <LogOut className="h-4 w-4" />
                  Log Out
                </button>
              </div>
            </div>
          </div>
        </div>
      </section>

      {children}
    </div>
  );
}
