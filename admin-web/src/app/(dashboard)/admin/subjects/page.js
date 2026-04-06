'use client';
import { useEffect, useState } from 'react';
import Link from 'next/link';
import { useAuth } from '@/lib/auth';
import { getSubjects, deleteSubject } from '@/lib/api';
import { BookOpen, Plus, Pencil, Trash2, AlertCircle, Search, CheckCircle, XCircle } from 'lucide-react';
import DeleteConfirmDialog from '@/components/DeleteConfirmDialog';

export default function SubjectsPage() {
  useAuth();

  const [subjects, setSubjects] = useState([]);
  const [loading, setLoading]   = useState(true);
  const [error, setError]       = useState('');
  const [search, setSearch]     = useState('');
  const [deleteDialogOpen, setDeleteDialogOpen] = useState(false);
  const [deleteTarget, setDeleteTarget] = useState(null);
  const [deleting, setDeleting] = useState(false);

  async function load() {
    setLoading(true);
    const data = await getSubjects();
    setSubjects(Array.isArray(data) ? data : data?.items ?? []);
    setLoading(false);
  }

  useEffect(() => { load(); }, []);

  async function handleDelete(id, name) {
    if (!confirm(`Delete subject "${name}"? This cannot be undone.`)) return;
    const res = await deleteSubject(id);
    if (res?.ok) {
      setSubjects((prev) => prev.filter((s) => s.id !== id));
    } else {
      setError('Failed to delete subject.');
    }
  }
  const filtered = subjects.filter(s =>
    s.subjectName.toLowerCase().includes(search.toLowerCase())
  );

  async function handleDeleteConfirm() {
    if (!deleteTarget) return;
    setDeleting(true);
    try {
      const res = await deleteSubject(deleteTarget.id);
      if (res?.ok) {
        setSubjects((prev) => prev.filter((s) => s.id !== deleteTarget.id));
        setDeleteDialogOpen(false);
        setDeleteTarget(null);
      } else {
        setError('Failed to delete subject.');
      }
    } finally {
      setDeleting(false);
    }
  }

  function handleDeleteClick(id, name) {
    setDeleteTarget({ id, name });
    setDeleteDialogOpen(true);
  }

  return (
    <div className="admin-page">
      {/* Header */}
      <div className="flex items-center justify-between mb-6">
        <div className="flex items-center gap-3">
          <div className="admin-header-icon">
            <BookOpen className="w-5 h-5 text-white" />
          </div>
          <div>
            <h1 className="text-2xl font-bold text-slate-900">Subjects</h1>
            <p className="text-sm text-slate-500">{subjects.length} total</p>
          </div>
        </div>
        <Link
          href="/admin/subjects/new"
          className="admin-btn-primary"
        >
          <Plus className="w-4 h-4" />
          Add Subject
        </Link>
      </div>

      {error && (
        <div className="flex items-center gap-3 bg-red-50 border border-red-100 text-red-700 text-sm rounded-xl p-4 mb-4">
          <AlertCircle className="w-5 h-5 shrink-0" />
          {error}
        </div>
      )}

      {/* Search */}
      <div className="relative mb-4">
        <Search className="absolute left-3 top-1/2 -translate-y-1/2 w-5 h-5 text-slate-400" />
        <input
          type="text"
          placeholder="Search subjects..."
          value={search}
          onChange={(e) => setSearch(e.target.value)}
          className="w-full max-w-sm pl-10 pr-4 py-2.5 bg-white border border-slate-200 rounded-xl text-sm focus:outline-none focus:ring-2 focus:ring-purple-500 focus:border-transparent"
        />
      </div>

      {loading ? (
        <div className="bg-white rounded-2xl border border-slate-100 p-12 text-center">
          <div className="w-8 h-8 border-2 border-purple-500 border-t-transparent rounded-full animate-spin mx-auto mb-3" />
          <p className="text-slate-500 text-sm">Loading subjects...</p>
        </div>
      ) : filtered.length === 0 ? (
        <div className="bg-white rounded-2xl border border-slate-100 p-12 text-center">
          <BookOpen className="w-12 h-12 text-slate-300 mx-auto mb-3" />
          <p className="text-slate-500 text-sm">
            {search ? 'No subjects match your search.' : 'No subjects yet.'}
          </p>
        </div>
      ) : (
        <div className="bg-white rounded-2xl border border-slate-100 shadow-sm overflow-hidden">
          <table className="w-full text-sm">
            <thead className="bg-slate-50 border-b border-slate-100">
              <tr>
                <th className="text-left px-5 py-4 font-semibold text-slate-600">Subject Name</th>
                <th className="text-left px-5 py-4 font-semibold text-slate-600">Status</th>
                <th className="text-left px-5 py-4 font-semibold text-slate-600">Teachers</th>
                <th className="text-left px-5 py-4 font-semibold text-slate-600">Created</th>
                <th className="px-5 py-4 w-24" />
              </tr>
            </thead>
            <tbody className="divide-y divide-slate-50">
              {filtered.map((s) => (
                <tr key={s.id} className="hover:bg-slate-50/50 transition-colors">
                  <td className="px-5 py-4">
                    <div className="flex items-center gap-3">
                      <div className="w-9 h-9 rounded-lg bg-[#526d82] flex items-center justify-center">
                        <BookOpen className="w-4 h-4 text-white" />
                      </div>
                      <Link href={`/admin/subjects/${s.id}`} className="font-medium text-slate-900 hover:text-slate-700 transition-colors">
                        {s.subjectName}
                      </Link>
                    </div>
                  </td>
                  <td className="px-5 py-4">
                    <span className={`inline-flex items-center gap-1.5 px-2.5 py-1 rounded-full text-xs font-medium ${
                      s.isActive
                        ? 'bg-emerald-50 text-emerald-700'
                        : 'bg-slate-100 text-slate-500'
                    }`}>
                      {s.isActive ? <CheckCircle className="w-3.5 h-3.5" /> : <XCircle className="w-3.5 h-3.5" />}
                      {s.isActive ? 'Active' : 'Inactive'}
                    </span>
                  </td>
                  <td className="px-5 py-4 text-slate-600">
                    {s.teacherNames?.length > 0 ? s.teacherNames.join(', ') : <span className="text-slate-400">No teachers</span>}
                  </td>
                  <td className="px-5 py-4 text-slate-500">
                    {s.createdAt ? new Date(s.createdAt).toLocaleDateString() : '—'}
                  </td>
                  <td className="px-5 py-4">
                    <div className="flex items-center justify-end gap-1">
                      <Link
                        href={`/admin/subjects/${s.id}`}
                        className="p-2 text-slate-400 hover:text-slate-900 hover:bg-slate-100 rounded-lg transition-colors"
                        title="Edit"
                      >
                        <Pencil className="w-4 h-4" />
                      </Link>
                      <button
                        onClick={() => handleDeleteClick(s.id, s.subjectName)}
                        className="p-2 text-slate-400 hover:text-red-600 hover:bg-red-50 rounded-lg transition-colors"
                        title="Delete"
                      >
                        <Trash2 className="w-4 h-4" />
                      </button>
                    </div>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      )}

      {/* Delete Confirm Dialog */}
      <DeleteConfirmDialog
        isOpen={deleteDialogOpen}
        title="Delete Subject?"
        message={`Are you sure you want to delete subject "${deleteTarget?.name}"? This action cannot be undone.`}
        onConfirm={handleDeleteConfirm}
        onCancel={() => {
          setDeleteDialogOpen(false);
          setDeleteTarget(null);
        }}
        isLoading={deleting}
      />
    </div>
  );
}
