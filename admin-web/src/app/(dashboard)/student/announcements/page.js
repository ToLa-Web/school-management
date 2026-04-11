'use client';

import { useEffect, useMemo, useState } from 'react';
import { Bell, MailOpen, Megaphone } from 'lucide-react';
import { useAuth } from '@/lib/auth';
import StudentEmptyState from '@/components/StudentEmptyState';
import StudentPageShell from '@/components/StudentPageShell';
import StudentSectionCard from '@/components/StudentSectionCard';
import StudentStatusBadge from '@/components/StudentStatusBadge';
import {
  formatDateTime,
  formatRelativeTime,
  getReadAnnouncementIds,
  loadStudentAnnouncements,
  loadStudentBaseData,
  saveReadAnnouncementIds,
} from '@/lib/student-portal';

export default function StudentAnnouncementsPage() {
  useAuth([2]);

  const [state, setState] = useState({
    loading: true,
    error: '',
    user: null,
    student: null,
    announcements: [],
  });
  const [selectedId, setSelectedId] = useState('');
  const [readIds, setReadIds] = useState([]);

  useEffect(() => {
    let active = true;

    async function load() {
      const base = await loadStudentBaseData();
      if (!active) return;

      if (!base.student) {
        setState((current) => ({ ...current, loading: false, user: base.user, error: 'Student profile not found.' }));
        return;
      }

      const announcements = await loadStudentAnnouncements(base.classrooms);
      if (!active) return;

      const storedReadIds = getReadAnnouncementIds(base.student.id);
      setReadIds(storedReadIds);
      setSelectedId(announcements[0]?.id ?? '');
      setState({
        loading: false,
        error: '',
        user: base.user,
        student: base.student,
        announcements,
      });
    }

    load();
    return () => {
      active = false;
    };
  }, []);

  const selected = useMemo(
    () => state.announcements.find((announcement) => announcement.id === selectedId) ?? state.announcements[0] ?? null,
    [selectedId, state.announcements],
  );

  function markSelectedAsRead() {
    if (!state.student?.id || !selected?.id || readIds.includes(selected.id)) return;
    const next = [...readIds, selected.id];
    setReadIds(next);
    saveReadAnnouncementIds(state.student.id, next);
  }

  if (state.loading) {
    return (
      <div className="rounded-[1.8rem] border border-slate-200/70 bg-white/85 p-12 text-center shadow-sm">
        <div className="mx-auto h-8 w-8 animate-spin rounded-full border-2 border-[#526d82] border-t-transparent" />
        <p className="mt-4 text-sm text-slate-500">Loading your announcements...</p>
      </div>
    );
  }

  return (
    <StudentPageShell
      title="Announcements"
      description="Catch up on the latest teacher notices and classroom messages, with read state tracked for this account on this device."
      breadcrumbs={[
        { label: 'Student', href: '/student/dashboard' },
        { label: 'Announcements' },
      ]}
      user={state.user}
      student={state.student}
    >
      {state.error ? (
        <div className="rounded-2xl border border-rose-200 bg-rose-50 px-4 py-4 text-sm text-rose-700">{state.error}</div>
      ) : null}

      {!state.announcements.length ? (
        <StudentEmptyState
          icon={Megaphone}
          title="No announcements available"
          description="Announcements from your teachers or the school will appear here after they are published."
        />
      ) : (
        <section className="grid gap-6 xl:grid-cols-[0.95fr_1.05fr]">
          <StudentSectionCard
            icon={Bell}
            title="Inbox"
            subtitle="Unread items stay highlighted until you mark them as read on this device."
          >
            <div className="space-y-3">
              {state.announcements.map((announcement) => {
                const isRead = readIds.includes(announcement.id);
                return (
                  <button
                    key={announcement.id}
                    type="button"
                    onClick={() => setSelectedId(announcement.id)}
                    className={[
                      'block w-full rounded-[1.4rem] border p-4 text-left transition',
                      selected?.id === announcement.id
                        ? 'border-[#526d82] bg-slate-50'
                        : 'border-slate-200/70 bg-white/80 hover:border-slate-300 hover:bg-white',
                    ].join(' ')}
                  >
                    <div className="flex items-start justify-between gap-3">
                      <div className="min-w-0">
                        <p className="truncate text-sm font-semibold text-slate-900">{announcement.title}</p>
                        <p className="mt-1 text-sm text-slate-500">
                          {announcement.authorTeacherName || 'School update'} | {announcement.classroomName || 'General'}
                        </p>
                      </div>
                      <StudentStatusBadge label={isRead ? 'Read' : 'Unread'} tone={isRead ? 'neutral' : 'info'} />
                    </div>
                    <p className="mt-3 line-clamp-2 text-sm leading-6 text-slate-600">{announcement.body}</p>
                    <p className="mt-3 text-xs text-slate-400">{formatRelativeTime(announcement.publishedAt ?? announcement.createdAt)}</p>
                  </button>
                );
              })}
            </div>
          </StudentSectionCard>

          <StudentSectionCard
            icon={MailOpen}
            title={selected?.title ?? 'Announcement'}
            subtitle={`${selected?.authorTeacherName || 'School update'} | ${selected?.classroomName || 'General'}`}
            action={
              selected && !readIds.includes(selected.id) ? (
                <button type="button" onClick={markSelectedAsRead} className="admin-btn-secondary">
                  Mark as Read
                </button>
              ) : null
            }
          >
            {selected ? (
              <div className="space-y-5">
                <div className="flex flex-wrap items-center gap-3">
                  <StudentStatusBadge label={readIds.includes(selected.id) ? 'Read' : 'Unread'} tone={readIds.includes(selected.id) ? 'neutral' : 'info'} />
                  <span className="text-sm text-slate-500">{formatDateTime(selected.publishedAt ?? selected.createdAt)}</span>
                </div>
                <div className="rounded-[1.4rem] border border-slate-200/70 bg-white/80 p-5">
                  <p className="text-sm leading-7 text-slate-700">{selected.body}</p>
                </div>
                <div className="rounded-[1.4rem] border border-dashed border-slate-200 bg-slate-50/80 p-4 text-sm text-slate-500">
                  Attachments are not exposed by the current announcement API, so this detail view focuses on the published message body and metadata.
                </div>
              </div>
            ) : (
              <StudentEmptyState
                icon={Megaphone}
                title="Choose an announcement"
                description="Select a message from the inbox to read its full content."
              />
            )}
          </StudentSectionCard>
        </section>
      )}
    </StudentPageShell>
  );
}
