'use client';

import Link from 'next/link';
import { useEffect, useState } from 'react';
import {
  AlarmClock,
  ArrowRight,
  BookOpen,
  CalendarDays,
  GraduationCap,
  Megaphone,
  TrendingUp,
  Zap,
} from 'lucide-react';
import { useAuth } from '@/lib/auth';
import StudentDataTable from '@/components/StudentDataTable';
import StudentEmptyState from '@/components/StudentEmptyState';
import StudentPageShell from '@/components/StudentPageShell';
import StudentSectionCard from '@/components/StudentSectionCard';
import StudentStatCard from '@/components/StudentStatCard';
import StudentStatusBadge from '@/components/StudentStatusBadge';
import {
  buildUpcomingScheduleItems,
  calculateAttendanceSummary,
  calculateGpa,
  formatDate,
  formatRelativeTime,
  formatTimeRange,
  getSubmissionStatus,
  loadStudentAnnouncements,
  loadStudentAttendance,
  loadStudentBaseData,
  loadStudentGrades,
  loadStudentMaterials,
  loadStudentSchedules,
  loadStudentSubmissions,
  parseTimeParts,
  scoreToLetter,
} from '@/lib/student-portal';

function getWeeklyHours(schedules) {
  return schedules.reduce((total, schedule) => {
    const [startHours, startMinutes] = parseTimeParts(schedule.startTime);
    const [endHours, endMinutes] = parseTimeParts(schedule.endTime);
    const start = startHours * 60 + startMinutes;
    const end = endHours * 60 + endMinutes;
    return total + Math.max(end - start, 0) / 60;
  }, 0);
}

export default function StudentDashboardPage() {
  useAuth([2]);

  const [state, setState] = useState({
    loading: true,
    error: '',
    user: null,
    student: null,
    classrooms: [],
    grades: [],
    attendance: [],
    schedules: [],
    announcements: [],
    materials: [],
    submissions: [],
  });

  useEffect(() => {
    let active = true;

    async function load() {
      const base = await loadStudentBaseData();

      if (!active) return;

      if (!base.student) {
        setState((current) => ({
          ...current,
          loading: false,
          user: base.user,
          error: 'We could not match this login to a student profile yet. Please sign in again or ask an administrator to sync the account.',
        }));
        return;
      }

      const [grades, attendance, schedules, announcements, materials, submissions] = await Promise.all([
        loadStudentGrades(base.student.id),
        loadStudentAttendance(base.student.id),
        loadStudentSchedules(base.classrooms),
        loadStudentAnnouncements(base.classrooms),
        loadStudentMaterials(base.classrooms),
        loadStudentSubmissions(base.student.id),
      ]);

      if (!active) return;

      setState({
        loading: false,
        error: '',
        user: base.user,
        student: base.student,
        classrooms: base.classrooms,
        grades,
        attendance,
        schedules,
        announcements,
        materials,
        submissions,
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
        <p className="mt-4 text-sm text-slate-500">Loading your student dashboard...</p>
      </div>
    );
  }

  const recentGrades = [...state.grades]
    .sort((left, right) => new Date(right.createdAt) - new Date(left.createdAt))
    .slice(0, 5);
  const upcomingClasses = buildUpcomingScheduleItems(state.schedules, state.classrooms, 3);
  const attendanceSummary = calculateAttendanceSummary(state.attendance);
  const gpa = calculateGpa(state.grades);
  const assignmentMaterials = state.materials.filter((item) => Number(item.type) === 2);
  const latestSubmissionByMaterialId = new Map(
    [...state.submissions]
      .sort((left, right) => new Date(right.submittedAt) - new Date(left.submittedAt))
      .map((submission) => [submission.materialId, submission]),
  );
  const pendingAssignments = assignmentMaterials.filter((item) => !latestSubmissionByMaterialId.get(item.id)).length;
  const weeklyHours = getWeeklyHours(state.schedules);

  const gradeColumns = [
    {
      key: 'subjectName',
      label: 'Subject',
      sortable: true,
      render: (row) => <span className="font-medium text-slate-900">{row.subjectName}</span>,
    },
    {
      key: 'score',
      label: 'Score',
      sortable: true,
      render: (row) => `${Number(row.score ?? 0).toFixed(1)} / 100`,
    },
    {
      key: 'letter',
      label: 'Grade',
      sortable: true,
      sortValue: (row) => scoreToLetter(row.score),
      render: (row) => <StudentStatusBadge label={scoreToLetter(row.score)} />,
    },
    {
      key: 'createdAt',
      label: 'Date',
      sortable: true,
      render: (row) => formatDate(row.createdAt),
    },
  ];

  return (
    <StudentPageShell
      title="Student Dashboard"
      description="Track your academic progress, next classes, and the latest updates from your teachers in one place."
      breadcrumbs={[
        { label: 'Student', href: '/student/dashboard' },
        { label: 'Dashboard' },
      ]}
      user={state.user}
      student={state.student}
      actions={
        <>
          <Link href="/student/academics" className="admin-btn-secondary">
            <BookOpen className="h-4 w-4" />
            View Academics
          </Link>
          <Link href="/student/profile" className="admin-btn-primary">
            <GraduationCap className="h-4 w-4" />
            Open Profile
          </Link>
        </>
      }
    >
      {state.error ? (
        <div className="rounded-2xl border border-rose-200 bg-rose-50 px-4 py-4 text-sm text-rose-700">{state.error}</div>
      ) : null}

      <section className="grid gap-4 md:grid-cols-2 xl:grid-cols-4">
        <StudentStatCard
          icon={TrendingUp}
          label="Current GPA"
          value={gpa.toFixed(2)}
          helper={`${state.grades.length} recorded grade${state.grades.length === 1 ? '' : 's'} so far`}
          tone="blue"
          trend={state.grades.length ? scoreToLetter(state.grades[0]?.score) : null}
        />
        <StudentStatCard
          icon={CalendarDays}
          label="Attendance Rate"
          value={`${attendanceSummary.rate.toFixed(0)}%`}
          helper={`${attendanceSummary.present} present, ${attendanceSummary.late} late`}
          tone="emerald"
        />
        <StudentStatCard
          icon={Zap}
          label="Pending Assignments"
          value={pendingAssignments}
          helper={`${assignmentMaterials.length} assignment${assignmentMaterials.length === 1 ? '' : 's'} posted`}
          tone="amber"
        />
        <StudentStatCard
          icon={AlarmClock}
          label="Scheduled Hours"
          value={`${weeklyHours.toFixed(1)}h`}
          helper="Estimated class hours in the current weekly timetable"
          tone="slate"
        />
      </section>

      <section className="grid gap-6 xl:grid-cols-[1.15fr_0.85fr]">
        <StudentSectionCard
          icon={BookOpen}
          title="Recent Grades"
          subtitle="Your latest recorded assessments, sorted by date."
          action={
            <Link href="/student/grades" className="admin-btn-secondary">
              View All
              <ArrowRight className="h-4 w-4" />
            </Link>
          }
        >
          <StudentDataTable
            columns={gradeColumns}
            rows={recentGrades}
            pageSize={5}
            initialSortKey="createdAt"
            initialSortDirection="desc"
            emptyState={
              <StudentEmptyState
                icon={BookOpen}
                title="No grades yet"
                description="Once teachers publish grade records, your latest results will show up here automatically."
              />
            }
          />
        </StudentSectionCard>

        <div className="space-y-6">
          <StudentSectionCard
            icon={CalendarDays}
            title="Upcoming Schedule"
            subtitle="The next classes from your recurring timetable."
            action={
              <Link href="/student/schedules" className="admin-btn-secondary">
                Full Schedule
              </Link>
            }
          >
            {upcomingClasses.length === 0 ? (
              <StudentEmptyState
                icon={CalendarDays}
                title="No upcoming classes"
                description="Your enrolled classrooms do not have any visible schedule blocks yet."
              />
            ) : (
              <div className="space-y-3">
                {upcomingClasses.map((item) => (
                  <div key={`${item.id}-${item.start.toISOString()}`} className="rounded-[1.4rem] border border-slate-200/70 bg-white/80 p-4">
                    <div className="flex flex-wrap items-center justify-between gap-3">
                      <div>
                        <p className="text-sm font-semibold text-slate-900">{item.subjectName}</p>
                        <p className="mt-1 text-sm text-slate-500">
                          {formatDate(item.start, { weekday: 'short', month: 'short', day: 'numeric' })} | {formatTimeRange(item.startTime, item.endTime)}
                        </p>
                      </div>
                      <StudentStatusBadge label={item.typeName ?? 'Regular'} tone="info" />
                    </div>
                    <p className="mt-2 text-sm text-slate-600">{item.teacherName ?? 'Teacher not assigned'} | {item.roomName ?? 'Room not assigned'}</p>
                  </div>
                ))}
              </div>
            )}
          </StudentSectionCard>

          <StudentSectionCard
            icon={Megaphone}
            title="Recent Announcements"
            subtitle="The latest classroom and school-wide updates."
            action={
              <Link href="/student/announcements" className="admin-btn-secondary">
                View All
              </Link>
            }
          >
            {!state.announcements.length ? (
              <StudentEmptyState
                icon={Megaphone}
                title="No announcements yet"
                description="Announcements from your teachers will show up here when they are published."
              />
            ) : (
              <div className="space-y-3">
                {state.announcements.slice(0, 3).map((announcement) => (
                  <Link
                    key={announcement.id}
                    href="/student/announcements"
                    className="block rounded-[1.4rem] border border-slate-200/70 bg-white/80 p-4 transition hover:border-slate-300 hover:bg-white"
                  >
                    <div className="flex items-start justify-between gap-3">
                      <div className="min-w-0">
                        <p className="truncate text-sm font-semibold text-slate-900">{announcement.title}</p>
                        <p className="mt-1 text-sm text-slate-500">
                          {announcement.authorTeacherName || 'School update'} | {announcement.classroomName || 'General'}
                        </p>
                      </div>
                      <p className="text-xs text-slate-400">{formatRelativeTime(announcement.publishedAt ?? announcement.createdAt)}</p>
                    </div>
                    <p className="mt-3 line-clamp-2 text-sm leading-6 text-slate-600">{announcement.body}</p>
                  </Link>
                ))}
              </div>
            )}
          </StudentSectionCard>
        </div>
      </section>

      <StudentSectionCard
        icon={Zap}
        title="Assignment Snapshot"
        subtitle="A quick look at your current submission tracking."
        action={
          <Link href="/student/assignments" className="admin-btn-secondary">
            Open Assignments
          </Link>
        }
      >
        {!assignmentMaterials.length ? (
          <StudentEmptyState
            icon={Zap}
            title="No assignments posted yet"
            description="When teachers upload assignment materials, your submission tracker will appear here."
          />
        ) : (
          <div className="grid gap-4 md:grid-cols-2 xl:grid-cols-3">
            {assignmentMaterials.slice(0, 3).map((assignment) => {
              const submission = latestSubmissionByMaterialId.get(assignment.id);
              return (
                <div key={assignment.id} className="rounded-[1.4rem] border border-slate-200/70 bg-white/80 p-4">
                  <div className="flex items-center justify-between gap-3">
                    <p className="text-sm font-semibold text-slate-900">{assignment.title}</p>
                    <StudentStatusBadge label={getSubmissionStatus(submission)} />
                  </div>
                  <p className="mt-2 text-sm text-slate-500">{assignment.subjectName}</p>
                  <p className="mt-3 text-sm text-slate-600">
                    {submission
                      ? `Last submitted ${formatRelativeTime(submission.submittedAt)}`
                      : 'Waiting for your first submission'}
                  </p>
                </div>
              );
            })}
          </div>
        )}
      </StudentSectionCard>
    </StudentPageShell>
  );
}
