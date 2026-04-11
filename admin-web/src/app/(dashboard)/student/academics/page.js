'use client';

import Link from 'next/link';
import { useEffect, useState } from 'react';
import { ArrowRight, BookOpen, GraduationCap, Layers3, Users } from 'lucide-react';
import { useAuth } from '@/lib/auth';
import StudentDataTable from '@/components/StudentDataTable';
import StudentEmptyState from '@/components/StudentEmptyState';
import StudentPageShell from '@/components/StudentPageShell';
import StudentSectionCard from '@/components/StudentSectionCard';
import StudentStatCard from '@/components/StudentStatCard';
import StudentStatusBadge from '@/components/StudentStatusBadge';
import {
  calculateGpa,
  loadStudentBaseData,
  loadStudentGrades,
  loadStudentSubjects,
  scoreToLetter,
} from '@/lib/student-portal';

export default function StudentAcademicsPage() {
  useAuth([2]);

  const [state, setState] = useState({
    loading: true,
    error: '',
    user: null,
    student: null,
    classrooms: [],
    subjects: [],
    grades: [],
  });

  useEffect(() => {
    let active = true;

    async function load() {
      const base = await loadStudentBaseData();
      if (!active) return;

      if (!base.student) {
        setState((current) => ({ ...current, loading: false, user: base.user, error: 'Student profile not found.' }));
        return;
      }

      const [subjects, grades] = await Promise.all([
        loadStudentSubjects(base.classrooms),
        loadStudentGrades(base.student.id),
      ]);

      if (!active) return;

      setState({
        loading: false,
        error: '',
        user: base.user,
        student: base.student,
        classrooms: base.classrooms,
        subjects,
        grades,
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
        <p className="mt-4 text-sm text-slate-500">Loading your courses...</p>
      </div>
    );
  }

  const subjectMap = new Map(state.subjects.map((subject) => [subject.id, subject]));
  const courses = state.classrooms.map((classroom) => {
    const gradesForSubject = state.grades.filter((grade) => grade.subjectId === classroom.subjectId);
    const averageScore = gradesForSubject.length
      ? gradesForSubject.reduce((sum, grade) => sum + Number(grade.score ?? 0), 0) / gradesForSubject.length
      : null;

    return {
      classroomId: classroom.id,
      subjectId: classroom.subjectId,
      subjectName: classroom.subjectName,
      teacherName: classroom.teacherName || 'Teacher not assigned',
      semester: classroom.semester || classroom.academicYear || 'Current term',
      status: classroom.isActive ? 'Enrolled' : 'Inactive',
      score: averageScore,
      letter: averageScore === null ? '--' : scoreToLetter(averageScore),
      detail: subjectMap.get(classroom.subjectId),
    };
  });

  const columns = [
    {
      key: 'subjectName',
      label: 'Subject Name',
      sortable: true,
      render: (row) => (
        <div>
          <p className="font-medium text-slate-900">{row.subjectName}</p>
          <p className="mt-1 text-xs text-slate-500">{row.detail?.code || row.classroomId.slice(0, 8)}</p>
        </div>
      ),
    },
    {
      key: 'teacherName',
      label: 'Teacher',
      sortable: true,
    },
    {
      key: 'semester',
      label: 'Semester',
      sortable: true,
    },
    {
      key: 'score',
      label: 'Grade',
      sortable: true,
      render: (row) =>
        row.score === null ? (
          <span className="text-slate-400">No grade yet</span>
        ) : (
          <div className="flex items-center gap-2">
            <span className="font-medium text-slate-900">{row.score.toFixed(1)}%</span>
            <StudentStatusBadge label={row.letter} />
          </div>
        ),
    },
    {
      key: 'status',
      label: 'Status',
      sortable: true,
      render: (row) => <StudentStatusBadge label={row.status} tone={row.status === 'Enrolled' ? 'success' : 'neutral'} />,
    },
    {
      key: 'view',
      label: 'Details',
      render: (row) => (
        <Link href={`/student/academics/${row.subjectId}`} className="text-sm font-semibold text-[#526d82] transition hover:text-[#27374d]">
          View
        </Link>
      ),
    },
  ];

  return (
    <StudentPageShell
      title="Academics"
      description="Browse your enrolled subjects, current standings, and the classrooms that power each course."
      breadcrumbs={[
        { label: 'Student', href: '/student/dashboard' },
        { label: 'Academics' },
      ]}
      user={state.user}
      student={state.student}
      actions={
        <Link href="/student/grades" className="admin-btn-primary">
          <ArrowRight className="h-4 w-4" />
          View Transcript
        </Link>
      }
    >
      {state.error ? (
        <div className="rounded-2xl border border-rose-200 bg-rose-50 px-4 py-4 text-sm text-rose-700">{state.error}</div>
      ) : null}

      <section className="grid gap-4 md:grid-cols-2 xl:grid-cols-4">
        <StudentStatCard icon={BookOpen} label="Enrolled Subjects" value={courses.length} helper="Active classrooms mapped to your account" tone="blue" />
        <StudentStatCard icon={Users} label="Teachers" value={new Set(courses.map((course) => course.teacherName)).size} helper="Distinct instructors across your courses" tone="emerald" />
        <StudentStatCard icon={Layers3} label="Current GPA" value={calculateGpa(state.grades).toFixed(2)} helper="Calculated from your visible grade records" tone="amber" />
        <StudentStatCard
          icon={GraduationCap}
          label="Current Term"
          value={courses[0]?.semester ?? 'Current'}
          helper="Semester data pulled from classroom enrollment records"
          tone="slate"
        />
      </section>

      <StudentSectionCard
        icon={BookOpen}
        title="My Courses"
        subtitle="Select a subject to drill into grades, classmates, assignments, and classroom resources."
      >
        <StudentDataTable
          columns={columns}
          rows={courses}
          pageSize={8}
          initialSortKey="subjectName"
          emptyState={
            <StudentEmptyState
              icon={BookOpen}
              title="No enrolled courses found"
              description="Once a student is enrolled in classrooms, their subjects will appear here automatically."
            />
          }
        />
      </StudentSectionCard>
    </StudentPageShell>
  );
}
