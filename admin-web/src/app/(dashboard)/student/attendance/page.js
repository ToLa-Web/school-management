'use client';

import { useEffect, useMemo, useState } from 'react';
import { AlertTriangle, BarChart3, CalendarClock, ClipboardCheck } from 'lucide-react';
import { useAuth } from '@/lib/auth';
import StudentDataTable from '@/components/StudentDataTable';
import StudentEmptyState from '@/components/StudentEmptyState';
import StudentLineChart from '@/components/StudentLineChart';
import StudentPageShell from '@/components/StudentPageShell';
import StudentSectionCard from '@/components/StudentSectionCard';
import StudentStatCard from '@/components/StudentStatCard';
import StudentStatusBadge from '@/components/StudentStatusBadge';
import {
  buildAttendanceTrend,
  calculateAttendanceSummary,
  formatDate,
  formatTimeRange,
  loadStudentAttendance,
  loadStudentBaseData,
  loadStudentSchedules,
} from '@/lib/student-portal';

export default function StudentAttendancePage() {
  useAuth([2]);

  const [state, setState] = useState({
    loading: true,
    error: '',
    user: null,
    student: null,
    classrooms: [],
    attendance: [],
    schedules: [],
  });
  const [classroomFilter, setClassroomFilter] = useState('all');

  useEffect(() => {
    let active = true;

    async function load() {
      const base = await loadStudentBaseData();
      if (!active) return;

      if (!base.student) {
        setState((current) => ({ ...current, loading: false, user: base.user, error: 'Student profile not found.' }));
        return;
      }

      const [attendance, schedules] = await Promise.all([
        loadStudentAttendance(base.student.id),
        loadStudentSchedules(base.classrooms),
      ]);

      if (!active) return;

      setState({
        loading: false,
        error: '',
        user: base.user,
        student: base.student,
        classrooms: base.classrooms,
        attendance,
        schedules,
      });
    }

    load();
    return () => {
      active = false;
    };
  }, []);

  const scheduleMap = useMemo(
    () =>
      new Map(
        state.schedules
          .filter((schedule) => schedule.classroomId)
          .map((schedule) => [schedule.classroomId, schedule]),
      ),
    [state.schedules],
  );
  const filteredAttendance = useMemo(
    () =>
      state.attendance.filter((record) => classroomFilter === 'all' || record.classroomId === classroomFilter),
    [classroomFilter, state.attendance],
  );

  if (state.loading) {
    return (
      <div className="rounded-[1.8rem] border border-slate-200/70 bg-white/85 p-12 text-center shadow-sm">
        <div className="mx-auto h-8 w-8 animate-spin rounded-full border-2 border-[#526d82] border-t-transparent" />
        <p className="mt-4 text-sm text-slate-500">Loading your attendance history...</p>
      </div>
    );
  }

  const summary = calculateAttendanceSummary(filteredAttendance);
  const columns = [
    {
      key: 'date',
      label: 'Date',
      sortable: true,
      render: (row) => formatDate(row.date),
    },
    {
      key: 'classroomName',
      label: 'Subject / Class',
      sortable: true,
      render: (row) => <span className="font-medium text-slate-900">{row.classroomName || 'Classroom'}</span>,
    },
    {
      key: 'time',
      label: 'Time',
      render: (row) => {
        const schedule = scheduleMap.get(row.classroomId);
        return schedule ? formatTimeRange(schedule.startTime, schedule.endTime) : 'Time not provided';
      },
    },
    {
      key: 'status',
      label: 'Status',
      sortable: true,
      render: (row) => <StudentStatusBadge label={row.status} />,
    },
  ];

  return (
    <StudentPageShell
      title="Attendance"
      description="Review attendance totals, track your rate over time, and catch any patterns that need attention early."
      breadcrumbs={[
        { label: 'Student', href: '/student/dashboard' },
        { label: 'Attendance' },
      ]}
      user={state.user}
      student={state.student}
    >
      {state.error ? (
        <div className="rounded-2xl border border-rose-200 bg-rose-50 px-4 py-4 text-sm text-rose-700">{state.error}</div>
      ) : null}

      {summary.rate < 75 ? (
        <div className="rounded-2xl border border-rose-200 bg-rose-50 px-4 py-4 text-sm text-rose-700">
          <div className="flex items-start gap-3">
            <AlertTriangle className="mt-0.5 h-5 w-5 shrink-0" />
            <div>
              <p className="font-semibold">Attendance warning</p>
              <p className="mt-1">Your filtered attendance rate is below 75%. Please check in with your teacher or advisor if you need support.</p>
            </div>
          </div>
        </div>
      ) : null}

      <section className="grid gap-4 md:grid-cols-2 xl:grid-cols-4">
        <StudentStatCard icon={ClipboardCheck} label="Total Attended" value={summary.present} helper="Present records in the current filter" tone="emerald" />
        <StudentStatCard icon={AlertTriangle} label="Total Absent" value={summary.absent} helper="Absence records currently visible" tone="rose" />
        <StudentStatCard icon={CalendarClock} label="Total Late" value={summary.late} helper="Late arrivals counted separately" tone="amber" />
        <StudentStatCard icon={BarChart3} label="Attendance Rate" value={`${summary.rate.toFixed(0)}%`} helper={`${summary.total} attendance records reviewed`} tone="blue" />
      </section>

      <section className="grid gap-6 xl:grid-cols-[1.05fr_0.95fr]">
        <StudentSectionCard
          icon={ClipboardCheck}
          title="Attendance History"
          subtitle="Filterable history by classroom with sortable dates and status records."
        >
          <div className="mb-4 max-w-sm">
            <label className="text-sm font-medium text-slate-700">
              Classroom
              <select value={classroomFilter} onChange={(event) => setClassroomFilter(event.target.value)} className="admin-input mt-2">
                <option value="all">All classrooms</option>
                {state.classrooms.map((classroom) => (
                  <option key={classroom.id} value={classroom.id}>
                    {classroom.name}
                  </option>
                ))}
              </select>
            </label>
          </div>

          <StudentDataTable
            columns={columns}
            rows={filteredAttendance}
            pageSize={8}
            initialSortKey="date"
            initialSortDirection="desc"
            emptyState={
              <StudentEmptyState
                icon={ClipboardCheck}
                title="No attendance records found"
                description="Attendance records will appear here after teachers mark a classroom session."
              />
            }
          />
        </StudentSectionCard>

        <StudentSectionCard
          icon={BarChart3}
          title="Attendance Trend"
          subtitle="Month-over-month attendance rate based on the records currently available."
        >
          <StudentLineChart
            data={buildAttendanceTrend(filteredAttendance)}
            color="#526d82"
            formatValue={(value) => `${Number(value ?? 0).toFixed(0)}%`}
          />
        </StudentSectionCard>
      </section>
    </StudentPageShell>
  );
}
