'use client';

import { useEffect, useMemo, useState } from 'react';
import { Download, FileUp, FolderOpen, NotebookPen, UploadCloud } from 'lucide-react';
import { submitStudentSubmission } from '@/lib/api';
import { useAuth } from '@/lib/auth';
import StudentDataTable from '@/components/StudentDataTable';
import StudentEmptyState from '@/components/StudentEmptyState';
import StudentPageShell from '@/components/StudentPageShell';
import StudentSectionCard from '@/components/StudentSectionCard';
import StudentStatusBadge from '@/components/StudentStatusBadge';
import StudentToast from '@/components/StudentToast';
import {
  formatDate,
  formatDateTime,
  getSubmissionStatus,
  loadStudentBaseData,
  loadStudentMaterials,
  loadStudentSubmissions,
  validateSubmissionFile,
} from '@/lib/student-portal';

export default function StudentAssignmentsPage() {
  useAuth([2]);

  const [state, setState] = useState({
    loading: true,
    error: '',
    user: null,
    student: null,
    assignments: [],
    submissions: [],
  });
  const [subjectFilter, setSubjectFilter] = useState('all');
  const [statusFilter, setStatusFilter] = useState('all');
  const [selectedAssignment, setSelectedAssignment] = useState(null);
  const [selectedFile, setSelectedFile] = useState(null);
  const [fileError, setFileError] = useState('');
  const [submitting, setSubmitting] = useState(false);
  const [toast, setToast] = useState({ open: false, tone: 'success', title: '', message: '' });

  useEffect(() => {
    let active = true;

    async function load() {
      const base = await loadStudentBaseData();
      if (!active) return;

      if (!base.student) {
        setState((current) => ({ ...current, loading: false, user: base.user, error: 'Student profile not found.' }));
        return;
      }

      const [materials, submissions] = await Promise.all([
        loadStudentMaterials(base.classrooms),
        loadStudentSubmissions(base.student.id),
      ]);

      if (!active) return;

      setState({
        loading: false,
        error: '',
        user: base.user,
        student: base.student,
        assignments: materials.filter((item) => Number(item.type) === 2),
        submissions,
      });
    }

    load();
    return () => {
      active = false;
    };
  }, []);

  const latestSubmissionByMaterialId = useMemo(() => {
    return new Map(
      [...state.submissions]
        .sort((left, right) => new Date(right.submittedAt) - new Date(left.submittedAt))
        .map((submission) => [submission.materialId, submission]),
    );
  }, [state.submissions]);
  const subjects = useMemo(() => [...new Set(state.assignments.map((assignment) => assignment.subjectName).filter(Boolean))], [state.assignments]);
  const filteredAssignments = useMemo(() => {
    return state.assignments.filter((assignment) => {
      const submission = latestSubmissionByMaterialId.get(assignment.id);
      const status = getSubmissionStatus(submission).toLowerCase();
      if (subjectFilter !== 'all' && assignment.subjectName !== subjectFilter) return false;
      if (statusFilter !== 'all' && status !== statusFilter) return false;
      return true;
    });
  }, [latestSubmissionByMaterialId, state.assignments, statusFilter, subjectFilter]);

  if (state.loading) {
    return (
      <div className="rounded-[1.8rem] border border-slate-200/70 bg-white/85 p-12 text-center shadow-sm">
        <div className="mx-auto h-8 w-8 animate-spin rounded-full border-2 border-[#526d82] border-t-transparent" />
        <p className="mt-4 text-sm text-slate-500">Loading assignments...</p>
      </div>
    );
  }

  async function handleSubmitAssignment() {
    if (!state.student || !selectedAssignment) return;

    const validationError = validateSubmissionFile(selectedFile);
    setFileError(validationError);
    if (validationError) return;

    setSubmitting(true);
    try {
      const response = await submitStudentSubmission(state.student.id, {
        materialId: selectedAssignment.id,
        submissionUrl: selectedFile.name,
      });

      if (!response.ok) {
        const body = await response.json().catch(() => ({}));
        throw new Error(body?.message ?? body?.error ?? 'The submission could not be saved.');
      }

      const created = await response.json();
      setState((current) => ({
        ...current,
        submissions: [created, ...current.submissions.filter((submission) => submission.id !== created.id)],
      }));
      setSelectedFile(null);
      setFileError('');
      setToast({
        open: true,
        tone: 'success',
        title: 'Assignment submitted',
        message: 'The current API stores the uploaded file name as your submission reference until file storage is connected.',
      });
    } catch (error) {
      setToast({
        open: true,
        tone: 'error',
        title: 'Submission failed',
        message: error.message || 'The assignment could not be submitted.',
      });
    } finally {
      setSubmitting(false);
    }
  }

  const columns = [
    {
      key: 'title',
      label: 'Assignment',
      sortable: true,
      render: (row) => <span className="font-medium text-slate-900">{row.title}</span>,
    },
    {
      key: 'subjectName',
      label: 'Subject',
      sortable: true,
    },
    {
      key: 'createdAt',
      label: 'Posted',
      sortable: true,
      render: (row) => formatDate(row.createdAt),
    },
    {
      key: 'status',
      label: 'Status',
      sortable: true,
      sortValue: (row) => getSubmissionStatus(latestSubmissionByMaterialId.get(row.id)),
      render: (row) => <StudentStatusBadge label={getSubmissionStatus(latestSubmissionByMaterialId.get(row.id))} />,
    },
    {
      key: 'grade',
      label: 'Grade',
      sortable: true,
      sortValue: (row) => latestSubmissionByMaterialId.get(row.id)?.grade ?? -1,
      render: (row) => {
        const submission = latestSubmissionByMaterialId.get(row.id);
        return submission?.grade !== null && submission?.grade !== undefined
          ? `${Number(submission.grade).toFixed(1)}%`
          : 'Pending';
      },
    },
    {
      key: 'view',
      label: 'View',
      render: (row) => (
        <button type="button" onClick={() => {
          setSelectedAssignment(row);
          setSelectedFile(null);
          setFileError('');
        }} className="text-sm font-semibold text-[#526d82] transition hover:text-[#27374d]">
          Open
        </button>
      ),
    },
  ];

  const activeSubmission = selectedAssignment ? latestSubmissionByMaterialId.get(selectedAssignment.id) : null;

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
        title="Assignments"
        description="Track assignment status, review teacher instructions, and submit your current work from one place."
        breadcrumbs={[
          { label: 'Student', href: '/student/dashboard' },
          { label: 'Assignments' },
        ]}
        user={state.user}
        student={state.student}
      >
        {state.error ? (
          <div className="rounded-2xl border border-rose-200 bg-rose-50 px-4 py-4 text-sm text-rose-700">{state.error}</div>
        ) : null}

        <StudentSectionCard
          icon={NotebookPen}
          title="Filters"
          subtitle="Sort your assignments by subject and current submission status."
        >
          <div className="grid gap-4 md:grid-cols-2">
            <label className="text-sm font-medium text-slate-700">
              Subject
              <select value={subjectFilter} onChange={(event) => setSubjectFilter(event.target.value)} className="admin-input mt-2">
                <option value="all">All subjects</option>
                {subjects.map((subject) => (
                  <option key={subject} value={subject}>
                    {subject}
                  </option>
                ))}
              </select>
            </label>
            <label className="text-sm font-medium text-slate-700">
              Status
              <select value={statusFilter} onChange={(event) => setStatusFilter(event.target.value)} className="admin-input mt-2">
                <option value="all">All statuses</option>
                <option value="pending">Pending</option>
                <option value="submitted">Submitted</option>
                <option value="graded">Graded</option>
              </select>
            </label>
          </div>
        </StudentSectionCard>

        <StudentSectionCard
          icon={NotebookPen}
          title="My Assignments"
          subtitle="Open an assignment to review the brief, download the attachment, and submit the current file reference."
        >
          <StudentDataTable
            columns={columns}
            rows={filteredAssignments}
            pageSize={8}
            initialSortKey="createdAt"
            initialSortDirection="desc"
            emptyState={
              <StudentEmptyState
                icon={NotebookPen}
                title="No assignments match the current filters"
                description="Try clearing the filters, or come back once teachers publish assignment materials."
              />
            }
          />
        </StudentSectionCard>

        {selectedAssignment ? (
          <div className="fixed inset-0 z-[90] flex items-center justify-center bg-slate-950/35 p-4 backdrop-blur-sm">
            <div className="w-full max-w-3xl rounded-[1.8rem] border border-slate-200 bg-white p-6 shadow-2xl">
              <div className="flex items-start justify-between gap-4">
                <div>
                  <p className="text-xs font-semibold uppercase tracking-[0.16em] text-slate-500">{selectedAssignment.subjectName}</p>
                  <h3 className="mt-2 text-2xl font-semibold text-slate-950">{selectedAssignment.title}</h3>
                </div>
                <button type="button" onClick={() => setSelectedAssignment(null)} className="rounded-xl border border-slate-200 px-3 py-2 text-sm font-medium text-slate-600 transition hover:border-slate-300 hover:text-slate-900">
                  Close
                </button>
              </div>

              <div className="mt-6 grid gap-6 xl:grid-cols-[1fr_0.95fr]">
                <div className="space-y-4">
                  <div className="rounded-[1.4rem] border border-slate-200/70 bg-white/80 p-4">
                    <div className="flex flex-wrap items-center gap-2">
                      <StudentStatusBadge label={getSubmissionStatus(activeSubmission)} />
                      <span className="text-sm text-slate-500">Posted {formatDate(selectedAssignment.createdAt)}</span>
                    </div>
                    <p className="mt-4 text-sm leading-7 text-slate-700">{selectedAssignment.description || 'No detailed instructions were provided with this assignment.'}</p>
                    <div className="mt-4 rounded-2xl border border-dashed border-slate-200 bg-slate-50/80 px-4 py-3 text-sm text-slate-500">
                      Due date is not currently exposed by the materials API, so this assignment view uses the published date and submission status for tracking.
                    </div>
                  </div>

                  <div className="rounded-[1.4rem] border border-slate-200/70 bg-white/80 p-4">
                    <p className="text-sm font-semibold text-slate-900">Attachments</p>
                    {selectedAssignment.url ? (
                      <div className="mt-3 flex flex-wrap gap-3">
                        <a href={selectedAssignment.url} target="_blank" rel="noreferrer" className="inline-flex items-center gap-2 text-sm font-semibold text-[#526d82] transition hover:text-[#27374d]">
                          <Download className="h-4 w-4" />
                          Download instructions
                        </a>
                      </div>
                    ) : (
                      <p className="mt-3 text-sm text-slate-500">No attachment link was provided for this assignment.</p>
                    )}
                  </div>

                  {activeSubmission ? (
                    <div className="rounded-[1.4rem] border border-slate-200/70 bg-white/80 p-4">
                      <p className="text-sm font-semibold text-slate-900">Submission history</p>
                      <p className="mt-3 text-sm text-slate-600">Submitted {formatDateTime(activeSubmission.submittedAt)}</p>
                      <p className="mt-1 text-sm text-slate-500">Stored reference: {activeSubmission.submissionUrl || 'No file reference recorded'}</p>
                      {activeSubmission.grade !== null && activeSubmission.grade !== undefined ? (
                        <div className="mt-4 rounded-2xl border border-emerald-200 bg-emerald-50 px-4 py-3">
                          <p className="text-sm font-semibold text-emerald-800">Grade {Number(activeSubmission.grade).toFixed(1)}%</p>
                          <p className="mt-2 text-sm text-emerald-700">{activeSubmission.feedback || 'No teacher feedback has been provided yet.'}</p>
                        </div>
                      ) : null}
                    </div>
                  ) : null}
                </div>

                <div className="rounded-[1.4rem] border border-slate-200/70 bg-slate-50/80 p-5">
                  <div className="flex items-center gap-3">
                    <div className="flex h-11 w-11 items-center justify-center rounded-2xl bg-slate-100 text-slate-700">
                      <UploadCloud className="h-5 w-5" />
                    </div>
                    <div>
                      <p className="text-sm font-semibold text-slate-900">Submit Assignment</p>
                      <p className="text-sm text-slate-500">PDF, DOCX, image, and ZIP files up to 10MB.</p>
                    </div>
                  </div>

                  <label className="mt-5 flex cursor-pointer flex-col items-center justify-center rounded-[1.4rem] border border-dashed border-slate-300 bg-white px-4 py-8 text-center transition hover:border-slate-400">
                    <FolderOpen className="h-6 w-6 text-slate-500" />
                    <p className="mt-3 text-sm font-semibold text-slate-700">{selectedFile ? selectedFile.name : 'Choose a file to upload'}</p>
                    <p className="mt-1 text-xs text-slate-500">Click to browse or replace the current selection.</p>
                    <input
                      type="file"
                      className="sr-only"
                      accept=".pdf,.doc,.docx,.png,.jpg,.jpeg,.webp,.zip"
                      onChange={(event) => {
                        const file = event.target.files?.[0] ?? null;
                        setSelectedFile(file);
                        setFileError(validateSubmissionFile(file));
                      }}
                    />
                  </label>

                  {fileError ? <p className="mt-3 text-sm text-rose-600">{fileError}</p> : null}

                  <button
                    type="button"
                    onClick={handleSubmitAssignment}
                    disabled={submitting || !selectedFile || Boolean(fileError)}
                    className="admin-btn-primary mt-5 w-full justify-center disabled:cursor-not-allowed disabled:opacity-60"
                  >
                    {submitting ? (
                      <div className="h-4 w-4 animate-spin rounded-full border-2 border-white border-t-transparent" />
                    ) : (
                      <FileUp className="h-4 w-4" />
                    )}
                    {submitting ? 'Submitting...' : 'Submit'}
                  </button>

                  <p className="mt-4 text-xs leading-6 text-slate-500">
                    The current backend stores the selected file name as a submission reference. A full file-storage workflow can be connected later without changing the page layout.
                  </p>
                </div>
              </div>
            </div>
          </div>
        ) : null}
      </StudentPageShell>
    </>
  );
}
