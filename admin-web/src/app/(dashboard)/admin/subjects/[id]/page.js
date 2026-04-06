'use client';

import Link from 'next/link';
import { useEffect, useState } from 'react';
import { useParams, useRouter } from 'next/navigation';
import { useAuth } from '@/lib/auth';
import { assignTeacherToSubject, deleteSubject, getSubject, getTeachers, removeTeacherFromSubject, updateSubject } from '@/lib/api';
import { AlertCircle, ArrowLeft, BookOpen, Save, Trash2, UserPlus, Users } from 'lucide-react';

const inputCls = 'admin-input';

export default function SubjectDetailPage() {
  useAuth([4]);

  const { id } = useParams();
  const router = useRouter();

  const [subject, setSubject] = useState(null);
  const [teachers, setTeachers] = useState([]);
  const [form, setForm] = useState({
    subjectName: '',
    yearLevel: '',
    category: '',
    department: '',
    description: '',
    code: '',
  });
  const [loading, setLoading] = useState(true);
  const [saving, setSaving] = useState(false);
  const [assigning, setAssigning] = useState(false);
  const [assignId, setAssignId] = useState('');
  const [error, setError] = useState('');

  useEffect(() => {
    async function load() {
      const [subjectRes, teachersRes] = await Promise.all([getSubject(id), getTeachers(1, 100)]);
      if (subjectRes) {
        setSubject(subjectRes);
        setForm({
          subjectName: subjectRes.subjectName ?? '',
          yearLevel: subjectRes.yearLevel?.toString() ?? '',
          category: subjectRes.category ?? '',
          department: subjectRes.department ?? '',
          description: subjectRes.description ?? '',
          code: subjectRes.code ?? '',
        });
      }
      setTeachers(Array.isArray(teachersRes?.items) ? teachersRes.items : teachersRes ?? []);
      setLoading(false);
    }

    load();
  }, [id]);

  async function refreshSubject() {
    const current = await getSubject(id);
    setSubject(current);
    return current;
  }

  async function handleSave(event) {
    event.preventDefault();
    setSaving(true);
    setError('');

    try {
      const response = await updateSubject(id, {
        subjectName: form.subjectName.trim(),
        yearLevel: form.yearLevel ? Number(form.yearLevel) : 0,
        category: form.category || null,
        department: form.department || null,
        description: form.description || null,
        code: form.code || null,
      });

      if (response?.ok) {
        await refreshSubject();
      } else {
        const data = await response.json().catch(() => ({}));
        setError(data?.message ?? data?.error ?? 'Failed to update subject.');
      }
    } finally {
      setSaving(false);
    }
  }

  async function handleDelete() {
    if (!confirm(`Delete subject "${subject?.subjectName}"?`)) return;
    const response = await deleteSubject(id);
    if (response?.ok) router.push('/admin/subjects');
    else setError('Failed to delete subject.');
  }

  async function handleAssign(event) {
    event.preventDefault();
    if (!assignId) return;

    setAssigning(true);
    const response = await assignTeacherToSubject(id, assignId);
    if (response?.ok) {
      await refreshSubject();
      setAssignId('');
    } else {
      setError('Failed to assign teacher.');
    }
    setAssigning(false);
  }

  async function handleRemoveTeacher(teacherName) {
    const teacher = teachers.find((item) => `${item.firstName} ${item.lastName}` === teacherName);
    if (!teacher) return;

    const response = await removeTeacherFromSubject(id, teacher.id);
    if (response?.ok) {
      await refreshSubject();
    } else {
      setError('Failed to remove teacher.');
    }
  }

  if (loading) {
    return (
      <div className="admin-section max-w-3xl text-center">
        <div className="mx-auto mb-3 h-8 w-8 animate-spin rounded-full border-2 border-slate-400 border-t-transparent" />
        <p className="text-sm text-slate-500">Loading subject...</p>
      </div>
    );
  }

  if (!subject) {
    return (
      <div className="max-w-3xl rounded-xl border border-red-100 bg-red-50 p-4 text-sm text-red-700">
        Subject not found.
      </div>
    );
  }

  const assignedNames = subject.teacherNames ?? [];
  const unassignedTeachers = teachers.filter((teacher) => !assignedNames.includes(`${teacher.firstName} ${teacher.lastName}`));

  return (
    <div className="admin-page max-w-3xl">
      <div className="admin-header">
        <div className="admin-header-main">
          <Link href="/admin/subjects" className="rounded-xl p-2 text-slate-400 transition-colors hover:bg-slate-100 hover:text-slate-700">
            <ArrowLeft className="h-5 w-5" />
          </Link>
          <div className="admin-header-icon">
            <BookOpen className="h-5 w-5" />
          </div>
          <div>
            <h1 className="admin-title">Edit Subject</h1>
            <p className="admin-subtitle">{subject.subjectName}</p>
          </div>
        </div>

        <button type="button" onClick={handleDelete} className="admin-btn-secondary text-red-700 hover:border-red-300 hover:bg-red-50 hover:text-red-700">
          <Trash2 className="h-4 w-4" />
          Delete
        </button>
      </div>

      {error && (
        <div className="flex items-center gap-3 rounded-xl border border-red-100 bg-red-50 p-4 text-sm text-red-700">
          <AlertCircle className="h-5 w-5 shrink-0" />
          {error}
        </div>
      )}

      <form onSubmit={handleSave} className="admin-section space-y-4">
        <div>
          <label className="mb-1.5 block text-sm font-semibold text-slate-700">Subject Name</label>
          <input className={inputCls} value={form.subjectName} onChange={(event) => setForm((current) => ({ ...current, subjectName: event.target.value }))} required />
        </div>

        <div className="grid gap-4 sm:grid-cols-2">
          <div>
            <label className="mb-1.5 block text-sm font-semibold text-slate-700">Department</label>
            <input className={inputCls} value={form.department} onChange={(event) => setForm((current) => ({ ...current, department: event.target.value }))} placeholder="Computer Science" />
          </div>
          <div>
            <label className="mb-1.5 block text-sm font-semibold text-slate-700">Subject Code</label>
            <input className={inputCls} value={form.code} onChange={(event) => setForm((current) => ({ ...current, code: event.target.value }))} placeholder="CS101" />
          </div>
        </div>

        <div className="grid gap-4 sm:grid-cols-2">
          <div>
            <label className="mb-1.5 block text-sm font-semibold text-slate-700">Year Level</label>
            <select className={inputCls} value={form.yearLevel} onChange={(event) => setForm((current) => ({ ...current, yearLevel: event.target.value }))}>
              <option value="">Select year</option>
              <option value="1">1</option>
              <option value="2">2</option>
              <option value="3">3</option>
              <option value="4">4</option>
              <option value="5">5</option>
            </select>
          </div>
          <div>
            <label className="mb-1.5 block text-sm font-semibold text-slate-700">Category</label>
            <select className={inputCls} value={form.category} onChange={(event) => setForm((current) => ({ ...current, category: event.target.value }))}>
              <option value="">Select category</option>
              <option value="Foundations">Foundations</option>
              <option value="Core CS">Core CS</option>
              <option value="Advanced">Advanced</option>
              <option value="Electives">Electives</option>
            </select>
          </div>
        </div>

        <div>
          <label className="mb-1.5 block text-sm font-semibold text-slate-700">Description</label>
          <textarea className={`${inputCls} min-h-28`} value={form.description} onChange={(event) => setForm((current) => ({ ...current, description: event.target.value }))} placeholder="Topics, goals, and scope" />
        </div>

        <div className="flex gap-3 pt-2">
          <button type="submit" disabled={saving} className="admin-btn-primary disabled:opacity-50">
            <Save className="h-4 w-4" />
            {saving ? 'Saving...' : 'Save Changes'}
          </button>
          <button type="button" onClick={() => router.push('/admin/subjects')} className="admin-btn-secondary">
            Back
          </button>
        </div>
      </form>

      <div className="admin-section space-y-4">
        <div className="flex items-center gap-2">
          <Users className="h-5 w-5 text-slate-500" />
          <h2 className="text-base font-semibold text-slate-900">Assigned Teachers</h2>
        </div>

        {assignedNames.length === 0 ? (
          <p className="text-sm text-slate-500">No teachers assigned yet.</p>
        ) : (
          <div className="space-y-2">
            {assignedNames.map((teacherName) => (
              <div key={teacherName} className="flex items-center justify-between rounded-xl border border-slate-200 bg-slate-50 px-4 py-3 text-sm">
                <span className="font-medium text-slate-800">{teacherName}</span>
                <button type="button" onClick={() => handleRemoveTeacher(teacherName)} className="text-sm font-medium text-red-600 hover:text-red-700">
                  Remove
                </button>
              </div>
            ))}
          </div>
        )}

        {unassignedTeachers.length > 0 && (
          <form onSubmit={handleAssign} className="flex gap-3 pt-2">
            <select value={assignId} onChange={(event) => setAssignId(event.target.value)} className="admin-input flex-1">
              <option value="">Select teacher</option>
              {unassignedTeachers.map((teacher) => (
                <option key={teacher.id} value={teacher.id}>
                  {teacher.firstName} {teacher.lastName}
                </option>
              ))}
            </select>
            <button type="submit" disabled={assigning || !assignId} className="admin-btn-primary disabled:opacity-50">
              <UserPlus className="h-4 w-4" />
              {assigning ? 'Assigning...' : 'Assign'}
            </button>
          </form>
        )}
      </div>
    </div>
  );
}
