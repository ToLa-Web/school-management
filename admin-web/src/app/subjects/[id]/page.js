'use client';
import { useEffect, useState } from 'react';
import { useRouter, useParams } from 'next/navigation';
import { useAuth } from '@/lib/auth';
import {
  getSubject, updateSubject, deleteSubject,
  assignTeacherToSubject, removeTeacherFromSubject,
  getTeachers,
} from '@/lib/api';

const inputCls =
  'w-full border border-gray-200 rounded-md px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-blue-500';

export default function SubjectDetailPage() {
  useAuth();

  const { id }   = useParams();
  const router   = useRouter();

  const [subject,   setSubject]  = useState(null);
  const [teachers,  setTeachers] = useState([]);
  const [name,      setName]     = useState('');
  const [loading,   setLoading]  = useState(true);
  const [saving,    setSaving]   = useState(false);
  const [error,     setError]    = useState('');
  const [assignId,  setAssignId] = useState('');
  const [assigning, setAssigning] = useState(false);

  useEffect(() => {
    async function load() {
      const [s, t] = await Promise.all([getSubject(id), getTeachers(1, 100)]);
      if (s) { setSubject(s); setName(s.subjectName); }
      setTeachers(t?.items ?? t ?? []);
      setLoading(false);
    }
    load();
  }, [id]);

  async function handleSave(e) {
    e.preventDefault();
    setSaving(true);
    setError('');
    const res = await updateSubject(id, name.trim());
    if (res?.ok) {
      const s = await getSubject(id);
      setSubject(s);
    } else {
      setError('Failed to update subject.');
    }
    setSaving(false);
  }

  async function handleDelete() {
    if (!confirm(`Delete subject "${subject?.subjectName}"?`)) return;
    const res = await deleteSubject(id);
    if (res?.ok) router.push('/subjects');
    else setError('Failed to delete subject.');
  }

  async function handleAssign(e) {
    e.preventDefault();
    if (!assignId) return;
    setAssigning(true);
    const res = await assignTeacherToSubject(id, assignId);
    if (res?.ok) {
      const s = await getSubject(id);
      setSubject(s);
      setAssignId('');
    } else {
      setError('Failed to assign teacher.');
    }
    setAssigning(false);
  }

  async function handleRemoveTeacher(teacherName) {
    // Find the teacher id by name
    const teacher = teachers.find(
      (t) => `${t.firstName} ${t.lastName}` === teacherName
    );
    if (!teacher) return;
    const res = await removeTeacherFromSubject(id, teacher.id);
    if (res?.ok) {
      const s = await getSubject(id);
      setSubject(s);
    } else {
      setError('Failed to remove teacher.');
    }
  }

  if (loading) return <p className="text-gray-500 text-sm">Loading…</p>;
  if (!subject) return <p className="text-red-500 text-sm">Subject not found.</p>;

  const assignedNames = subject.teacherNames ?? [];
  const unassigned = teachers.filter(
    (t) => !assignedNames.includes(`${t.firstName} ${t.lastName}`)
  );

  return (
    <div className="max-w-xl space-y-6">
      <div className="flex items-center justify-between">
        <h1 className="text-2xl font-bold">Edit Subject</h1>
        <button
          onClick={handleDelete}
          className="text-red-500 hover:text-red-700 text-sm font-medium"
        >
          Delete Subject
        </button>
      </div>

      {error && (
        <div className="bg-red-50 border border-red-200 text-red-700 text-sm rounded-md p-3">
          {error}
        </div>
      )}

      {/* Name form */}
      <form onSubmit={handleSave} className="bg-white rounded-xl shadow-sm p-6 space-y-4">
        <div>
          <label className="block text-sm font-medium text-gray-700 mb-1">Subject Name</label>
          <input
            type="text"
            required
            value={name}
            onChange={(e) => setName(e.target.value)}
            className={inputCls}
          />
        </div>
        <button
          type="submit"
          disabled={saving}
          className="bg-blue-600 hover:bg-blue-700 disabled:opacity-50 text-white text-sm font-medium px-5 py-2 rounded-md transition-colors"
        >
          {saving ? 'Saving…' : 'Save Changes'}
        </button>
      </form>

      {/* Assigned teachers */}
      <div className="bg-white rounded-xl shadow-sm p-6 space-y-4">
        <h2 className="font-semibold text-gray-800">Assigned Teachers</h2>
        {assignedNames.length === 0 ? (
          <p className="text-gray-500 text-sm">No teachers assigned yet.</p>
        ) : (
          <ul className="space-y-2">
            {assignedNames.map((name) => (
              <li key={name} className="flex items-center justify-between text-sm">
                <span>{name}</span>
                <button
                  onClick={() => handleRemoveTeacher(name)}
                  className="text-red-500 hover:text-red-700 text-xs font-medium"
                >
                  Remove
                </button>
              </li>
            ))}
          </ul>
        )}

        {/* Assign teacher */}
        {unassigned.length > 0 && (
          <form onSubmit={handleAssign} className="flex gap-2 pt-2">
            <select
              value={assignId}
              onChange={(e) => setAssignId(e.target.value)}
              className="flex-1 border border-gray-200 rounded-md px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-blue-500"
            >
              <option value="">— Select teacher —</option>
              {unassigned.map((t) => (
                <option key={t.id} value={t.id}>
                  {t.firstName} {t.lastName}
                </option>
              ))}
            </select>
            <button
              type="submit"
              disabled={assigning || !assignId}
              className="bg-blue-600 hover:bg-blue-700 disabled:opacity-50 text-white text-sm font-medium px-4 py-2 rounded-md transition-colors"
            >
              {assigning ? 'Assigning…' : 'Assign'}
            </button>
          </form>
        )}
      </div>
    </div>
  );
}
