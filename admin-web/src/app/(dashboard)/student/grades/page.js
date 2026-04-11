'use client';

import { useEffect, useMemo, useState } from 'react';
import { Download, Filter, LineChart, Table2, TrendingUp } from 'lucide-react';
import { useAuth } from '@/lib/auth';
import StudentDataTable from '@/components/StudentDataTable';
import StudentEmptyState from '@/components/StudentEmptyState';
import StudentLineChart from '@/components/StudentLineChart';
import StudentPageShell from '@/components/StudentPageShell';
import StudentSectionCard from '@/components/StudentSectionCard';
import StudentStatCard from '@/components/StudentStatCard';
import StudentStatusBadge from '@/components/StudentStatusBadge';
import {
  buildGradeTrend,
  calculateGpa,
  calculateMedian,
  exportCsv,
  formatDate,
  loadStudentBaseData,
  loadStudentGrades,
  loadStudentSubjects,
  openPrintableTranscript,
  scoreToGpa,
  scoreToLetter,
} from '@/lib/student-portal';

export default function StudentGradesPage() {
  useAuth([2]);

  const [state, setState] = useState({
    loading: true,
    error: '',
    user: null,
    student: null,
    classrooms: [],
    grades: [],
    subjects: [],
  });
  const [semesterFilter, setSemesterFilter] = useState('all');
  const [subjectFilter, setSubjectFilter] = useState('all');
  const [rangeFilter, setRangeFilter] = useState('all');

  useEffect(() => {
    let active = true;

    async function load() {
      const base = await loadStudentBaseData();
      if (!active) return;

      if (!base.student) {
        setState((current) => ({ ...current, loading: false, user: base.user, error: 'Student profile not found.' }));
        return;
      }

      const [grades, subjects] = await Promise.all([
        loadStudentGrades(base.student.id),
        loadStudentSubjects(base.classrooms),
      ]);

      if (!active) return;

      setState({
        loading: false,
        error: '',
        user: base.user,
        student: base.student,
        classrooms: base.classrooms,
        grades,
        subjects,
      });
    }

    load();
    return () => {
      active = false;
    };
  }, []);

  const semesters = useMemo(() => [...new Set(state.grades.map((grade) => grade.semester).filter(Boolean))], [state.grades]);
  const filteredGrades = useMemo(() => {
    return state.grades.filter((grade) => {
      if (semesterFilter !== 'all' && grade.semester !== semesterFilter) return false;
      if (subjectFilter !== 'all' && grade.subjectId !== subjectFilter) return false;
      if (rangeFilter === '90' && Number(grade.score ?? 0) < 90) return false;
      if (rangeFilter === '80' && (Number(grade.score ?? 0) < 80 || Number(grade.score ?? 0) >= 90)) return false;
      if (rangeFilter === '70' && (Number(grade.score ?? 0) < 70 || Number(grade.score ?? 0) >= 80)) return false;
      if (rangeFilter === '60' && Number(grade.score ?? 0) >= 70) return false;
      return true;
    });
  }, [rangeFilter, semesterFilter, state.grades, subjectFilter]);

  if (state.loading) {
    return (
      <div className="rounded-[1.8rem] border border-slate-200/70 bg-white/85 p-12 text-center shadow-sm">
        <div className="mx-auto h-8 w-8 animate-spin rounded-full border-2 border-[#526d82] border-t-transparent" />
        <p className="mt-4 text-sm text-slate-500">Loading your transcript...</p>
      </div>
    );
  }

  const average = filteredGrades.length
    ? filteredGrades.reduce((sum, grade) => sum + Number(grade.score ?? 0), 0) / filteredGrades.length
    : 0;
  const median = calculateMedian(filteredGrades.map((grade) => Number(grade.score ?? 0)));
  const columns = [
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
      label: 'Letter Grade',
      sortable: true,
      sortValue: (row) => scoreToLetter(row.score),
      render: (row) => <StudentStatusBadge label={scoreToLetter(row.score)} />,
    },
    {
      key: 'semester',
      label: 'Semester',
      sortable: true,
    },
    {
      key: 'gpa',
      label: 'GPA Contribution',
      sortable: true,
      sortValue: (row) => scoreToGpa(row.score),
      render: (row) => scoreToGpa(row.score).toFixed(1),
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
      title="Grades and Transcript"
      description="Filter your transcript, review GPA progress, and export the current view for sharing or printing."
      breadcrumbs={[
        { label: 'Student', href: '/student/dashboard' },
        { label: 'Grades' },
      ]}
      user={state.user}
      student={state.student}
      actions={
        <>
          <button
            type="button"
            onClick={() =>
              exportCsv(
                'student-transcript.csv',
                ['Subject', 'Semester', 'Score', 'Letter', 'GPA', 'Date'],
                filteredGrades.map((grade) => [
                  grade.subjectName,
                  grade.semester,
                  Number(grade.score ?? 0).toFixed(1),
                  scoreToLetter(grade.score),
                  scoreToGpa(grade.score).toFixed(1),
                  formatDate(grade.createdAt),
                ]),
              )
            }
            className="admin-btn-secondary"
          >
            <Download className="h-4 w-4" />
            Export Excel
          </button>
          <button type="button" onClick={() => openPrintableTranscript(state.student, filteredGrades)} className="admin-btn-primary">
            <Download className="h-4 w-4" />
            Export PDF
          </button>
        </>
      }
    >
      {state.error ? (
        <div className="rounded-2xl border border-rose-200 bg-rose-50 px-4 py-4 text-sm text-rose-700">{state.error}</div>
      ) : null}

      <section className="grid gap-4 md:grid-cols-2 xl:grid-cols-4">
        <StudentStatCard icon={TrendingUp} label="Overall GPA" value={calculateGpa(filteredGrades).toFixed(2)} helper="4.0 scale based on visible scores" tone="blue" />
        <StudentStatCard icon={Table2} label="Average Score" value={`${average.toFixed(1)}%`} helper="Mean across the filtered transcript" tone="emerald" />
        <StudentStatCard icon={LineChart} label="Median Score" value={`${median.toFixed(1)}%`} helper="Middle score after sorting your results" tone="amber" />
        <StudentStatCard icon={Filter} label="Records" value={filteredGrades.length} helper="Transcript rows matching the current filters" tone="slate" />
      </section>

      <StudentSectionCard icon={Filter} title="Filters" subtitle="Narrow the transcript by semester, subject, and grade band.">
        <div className="grid gap-4 md:grid-cols-3">
          <label className="text-sm font-medium text-slate-700">
            Semester
            <select value={semesterFilter} onChange={(event) => setSemesterFilter(event.target.value)} className="admin-input mt-2">
              <option value="all">All semesters</option>
              {semesters.map((semester) => (
                <option key={semester} value={semester}>
                  {semester}
                </option>
              ))}
            </select>
          </label>
          <label className="text-sm font-medium text-slate-700">
            Subject
            <select value={subjectFilter} onChange={(event) => setSubjectFilter(event.target.value)} className="admin-input mt-2">
              <option value="all">All subjects</option>
              {state.subjects.map((subject) => (
                <option key={subject.id} value={subject.id}>
                  {subject.subjectName}
                </option>
              ))}
            </select>
          </label>
          <label className="text-sm font-medium text-slate-700">
            Grade range
            <select value={rangeFilter} onChange={(event) => setRangeFilter(event.target.value)} className="admin-input mt-2">
              <option value="all">All scores</option>
              <option value="90">A range (90-100)</option>
              <option value="80">B range (80-89)</option>
              <option value="70">C range (70-79)</option>
              <option value="60">At-risk (&lt;70)</option>
            </select>
          </label>
        </div>
      </StudentSectionCard>

      <section className="grid gap-6 xl:grid-cols-[1.05fr_0.95fr]">
        <StudentSectionCard
          icon={Table2}
          title="Transcript"
          subtitle="Subject-level grade records with semester and GPA contribution details."
        >
          <StudentDataTable
            columns={columns}
            rows={filteredGrades}
            pageSize={8}
            initialSortKey="createdAt"
            initialSortDirection="desc"
            emptyState={
              <StudentEmptyState
                icon={Table2}
                title="No grades match the current filters"
                description="Try expanding the filter set, or come back once teachers have published more assessment records."
              />
            }
          />
        </StudentSectionCard>

        <StudentSectionCard
          icon={LineChart}
          title="GPA Trend"
          subtitle="Semester-over-semester GPA movement from the grade records currently available."
        >
          <StudentLineChart
            data={buildGradeTrend(state.grades)}
            color="#526d82"
            formatValue={(value) => `${Number(value ?? 0).toFixed(2)} GPA`}
          />
        </StudentSectionCard>
      </section>
    </StudentPageShell>
  );
}
