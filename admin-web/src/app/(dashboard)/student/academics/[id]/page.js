'use client';

import Link from 'next/link';
import { useParams } from 'next/navigation';
import { useEffect, useMemo, useState } from 'react';
import { ArrowLeft, BookOpen, ClipboardList, Download, Files, Layers3, UsersRound } from 'lucide-react';
import { getClassroom, getSubject } from '@/lib/api';
import { useAuth } from '@/lib/auth';
import StudentEmptyState from '@/components/StudentEmptyState';
import StudentPageShell from '@/components/StudentPageShell';
import StudentSectionCard from '@/components/StudentSectionCard';
import StudentStatusBadge from '@/components/StudentStatusBadge';
import {
  exportCsv,
  formatDate,
  formatPercent,
  getMaterialTypeLabel,
  getScoreTone,
  getSubmissionStatus,
  loadStudentBaseData,
  loadStudentGrades,
  loadStudentMaterials,
  loadStudentSubmissions,
  scoreToLetter,
} from '@/lib/student-portal';

const WEIGHTS = [
  { label: 'Quiz', weight: 20 },
  { label: 'Midterm', weight: 30 },
  { label: 'Final', weight: 50 },
];

export default function StudentAcademicDetailPage() {
  useAuth([2]);

  const { id } = useParams();
  const [state, setState] = useState({
    loading: true,
    error: '',
    user: null,
    student: null,
    subject: null,
    classrooms: [],
    classroomDetails: [],
    grades: [],
    materials: [],
    submissions: [],
  });
  const [activeSemester, setActiveSemester] = useState('');

  useEffect(() => {
    let active = true;

    async function load() {
      const base = await loadStudentBaseData();
      if (!active) return;

      if (!base.student) {
        setState((current) => ({ ...current, loading: false, user: base.user, error: 'Student profile not found.' }));
        return;
      }

      const relevantClassrooms = base.classrooms.filter((classroom) => classroom.subjectId === id);
      if (!relevantClassrooms.length) {
        setState((current) => ({
          ...current,
          loading: false,
          user: base.user,
          student: base.student,
          error: 'You are not enrolled in this subject.',
        }));
        return;
      }

      const [subject, grades, materials, submissions, classroomDetails] = await Promise.all([
        getSubject(id),
        loadStudentGrades(base.student.id),
        loadStudentMaterials(relevantClassrooms),
        loadStudentSubmissions(base.student.id),
        Promise.all(relevantClassrooms.map((classroom) => getClassroom(classroom.id))),
      ]);

      if (!active) return;

      const subjectGrades = grades.filter((grade) => grade.subjectId === id);
      const semesters = [...new Set(subjectGrades.map((grade) => grade.semester).filter(Boolean))];

      setActiveSemester(semesters[0] ?? '');
      setState({
        loading: false,
        error: '',
        user: base.user,
        student: base.student,
        subject,
        classrooms: relevantClassrooms,
        classroomDetails: classroomDetails.filter(Boolean),
        grades: subjectGrades,
        materials,
        submissions,
      });
    }

    load();
    return () => {
      active = false;
    };
  }, [id]);

  const filteredGrades = useMemo(() => {
    if (!activeSemester) return state.grades;
    return state.grades.filter((grade) => grade.semester === activeSemester);
  }, [activeSemester, state.grades]);

  if (state.loading) {
    return (
      <div className="rounded-[1.8rem] border border-slate-200/70 bg-white/85 p-12 text-center shadow-sm">
        <div className="mx-auto h-8 w-8 animate-spin rounded-full border-2 border-[#526d82] border-t-transparent" />
        <p className="mt-4 text-sm text-slate-500">Loading subject detail...</p>
      </div>
    );
  }

  const averageScore = filteredGrades.length
    ? filteredGrades.reduce((sum, grade) => sum + Number(grade.score ?? 0), 0) / filteredGrades.length
    : 0;
  const weights = WEIGHTS.map((item) => ({
    ...item,
    contribution: (averageScore / 100) * item.weight,
  }));
  const latestSubmissionByMaterialId = new Map(
    [...state.submissions]
      .sort((left, right) => new Date(right.submittedAt) - new Date(left.submittedAt))
      .map((submission) => [submission.materialId, submission]),
  );
  const roster = [...new Set(
    state.classroomDetails
      .flatMap((classroom) => classroom.students ?? [])
      .filter((student) => student.studentId !== state.student?.id)
      .map((student) => student.firstName)
      .filter(Boolean),
  )].sort((left, right) => left.localeCompare(right));

  return (
    <StudentPageShell
      title={state.subject?.subjectName ?? 'Subject Detail'}
      description="Review your current standing, classroom resources, and the roster connected to this enrolled subject."
      breadcrumbs={[
        { label: 'Student', href: '/student/dashboard' },
        { label: 'Academics', href: '/student/academics' },
        { label: state.subject?.subjectName ?? 'Subject' },
      ]}
      user={state.user}
      student={state.student}
      actions={
        <>
          <Link href="/student/academics" className="admin-btn-secondary">
            <ArrowLeft className="h-4 w-4" />
            Back to Academics
          </Link>
          <button
            type="button"
            onClick={() =>
              exportCsv(
                `${state.subject?.subjectName ?? 'subject'}-grades.csv`,
                ['Semester', 'Score', 'Letter', 'Recorded'],
                state.grades.map((grade) => [
                  grade.semester,
                  Number(grade.score ?? 0).toFixed(1),
                  scoreToLetter(grade.score),
                  formatDate(grade.createdAt),
                ]),
              )
            }
            className="admin-btn-primary"
          >
            <Download className="h-4 w-4" />
            Export Grades
          </button>
        </>
      }
    >
      {state.error ? (
        <div className="rounded-2xl border border-rose-200 bg-rose-50 px-4 py-4 text-sm text-rose-700">{state.error}</div>
      ) : null}

      <section className="grid gap-6 xl:grid-cols-[1.1fr_0.9fr]">
        <StudentSectionCard
          icon={BookOpen}
          title="Subject Overview"
          subtitle="Core metadata from the subject and classroom records."
        >
          <div className="grid gap-4 sm:grid-cols-2">
            {[
              ['Teacher', [...new Set(state.classrooms.map((classroom) => classroom.teacherName).filter(Boolean))].join(', ') || 'Teacher not assigned'],
              ['Department', state.subject?.departmentName || 'Department not specified'],
              ['Code', state.subject?.code || 'Code not specified'],
              ['Description', state.subject?.description || 'No subject description has been provided yet.'],
              ['Semester', [...new Set(state.classrooms.map((classroom) => classroom.semester || classroom.academicYear).filter(Boolean))].join(', ') || 'Current term'],
              ['Classroom', state.classrooms.map((classroom) => classroom.name).join(', ')],
            ].map(([label, value]) => (
              <div key={label} className="rounded-[1.4rem] border border-slate-200/70 bg-white/80 p-4">
                <p className="text-xs font-semibold uppercase tracking-[0.16em] text-slate-500">{label}</p>
                <p className="mt-3 text-sm leading-6 text-slate-700">{value}</p>
              </div>
            ))}
          </div>
        </StudentSectionCard>

        <StudentSectionCard
          icon={Layers3}
          title="Weighted Estimate"
          subtitle="Projected from the current aggregate score because component-level assessments are not exposed by the backend yet."
        >
          <div className="space-y-4">
            {weights.map((item) => (
              <div key={item.label}>
                <div className="flex items-center justify-between gap-3 text-sm">
                  <p className="font-medium text-slate-700">
                    {item.label} ({item.weight}%)
                  </p>
                  <p className="text-slate-500">{item.contribution.toFixed(1)} / {item.weight}</p>
                </div>
                <div className="mt-2 h-2.5 overflow-hidden rounded-full bg-slate-100">
                  <div className="h-full rounded-full bg-[#526d82]" style={{ width: `${Math.max((item.contribution / item.weight) * 100, 4)}%` }} />
                </div>
              </div>
            ))}
            <div className="rounded-[1.4rem] border border-slate-200/70 bg-slate-50/90 p-4">
              <p className="text-sm font-medium text-slate-700">Current aggregate score</p>
              <div className="mt-2 flex items-center gap-3">
                <span className="text-3xl font-semibold tracking-tight text-slate-950">{averageScore.toFixed(1)}%</span>
                <StudentStatusBadge label={`${formatPercent(averageScore, 0)} score`} tone={getScoreTone(averageScore)} />
              </div>
            </div>
          </div>
        </StudentSectionCard>
      </section>

      <StudentSectionCard
        icon={ClipboardList}
        title="Grades"
        subtitle="Switch semesters to review the available score history for this subject."
      >
        <div className="flex flex-wrap gap-2">
          {[...new Set(state.grades.map((grade) => grade.semester))].map((semester) => (
            <button
              key={semester}
              type="button"
              onClick={() => setActiveSemester(semester)}
              className={[
                'rounded-full px-3 py-2 text-sm font-semibold transition',
                activeSemester === semester ? 'bg-[#526d82] text-white' : 'bg-slate-100 text-slate-600 hover:bg-slate-200',
              ].join(' ')}
            >
              {semester}
            </button>
          ))}
        </div>

        {!filteredGrades.length ? (
          <div className="mt-6">
            <StudentEmptyState
              icon={ClipboardList}
              title="No grades recorded"
              description="This subject does not have any published grades for the selected semester yet."
            />
          </div>
        ) : (
          <div className="mt-6 grid gap-4 md:grid-cols-2 xl:grid-cols-3">
            {filteredGrades.map((grade) => (
              <div key={grade.id} className="rounded-[1.4rem] border border-slate-200/70 bg-white/80 p-4">
                <div className="flex items-center justify-between gap-3">
                  <p className="text-sm font-semibold text-slate-900">{grade.semester}</p>
                  <StudentStatusBadge label={scoreToLetter(grade.score)} />
                </div>
                <p className="mt-3 text-3xl font-semibold tracking-tight text-slate-950">{Number(grade.score ?? 0).toFixed(1)}%</p>
                <p className="mt-2 text-sm text-slate-500">Recorded {formatDate(grade.createdAt)}</p>
              </div>
            ))}
          </div>
        )}
      </StudentSectionCard>

      <section className="grid gap-6 xl:grid-cols-[1fr_0.95fr]">
        <StudentSectionCard
          icon={Files}
          title="Materials and Assignments"
          subtitle="Teacher uploads associated with this subject across your classroom sections."
        >
          {!state.materials.length ? (
            <StudentEmptyState
              icon={Files}
              title="No resources uploaded"
              description="Course slides, references, and assignments will appear here once teachers publish them."
            />
          ) : (
            <div className="space-y-3">
              {state.materials.map((material) => {
                const submission = latestSubmissionByMaterialId.get(material.id);
                return (
                  <div key={material.id} className="rounded-[1.4rem] border border-slate-200/70 bg-white/80 p-4">
                    <div className="flex flex-wrap items-center justify-between gap-3">
                      <div>
                        <p className="text-sm font-semibold text-slate-900">{material.title}</p>
                        <p className="mt-1 text-sm text-slate-500">{material.classroomName} | {getMaterialTypeLabel(material.type)}</p>
                      </div>
                      <div className="flex items-center gap-2">
                        <StudentStatusBadge label={getMaterialTypeLabel(material.type)} />
                        {Number(material.type) === 2 ? <StudentStatusBadge label={getSubmissionStatus(submission)} /> : null}
                      </div>
                    </div>
                    <p className="mt-3 text-sm leading-6 text-slate-600">{material.description || 'No description provided.'}</p>
                    {material.url ? (
                      <div className="mt-4">
                        <a href={material.url} target="_blank" rel="noreferrer" className="text-sm font-semibold text-[#526d82] transition hover:text-[#27374d]">
                          Open resource
                        </a>
                      </div>
                    ) : null}
                  </div>
                );
              })}
            </div>
          )}
        </StudentSectionCard>

        <StudentSectionCard
          icon={UsersRound}
          title="Class Roster"
          subtitle="Only first names are shown here to keep classmate details private."
        >
          {!roster.length ? (
            <StudentEmptyState
              icon={UsersRound}
              title="No classmates listed"
              description="Roster details are not available yet for this classroom."
            />
          ) : (
            <div className="flex flex-wrap gap-2">
              {roster.map((name) => (
                <span key={name} className="rounded-full border border-slate-200 bg-white px-3 py-2 text-sm font-medium text-slate-700">
                  {name}
                </span>
              ))}
            </div>
          )}
        </StudentSectionCard>
      </section>
    </StudentPageShell>
  );
}
