'use client';
import { useEffect, useState } from 'react';
import Link from 'next/link';
import { useAuth } from '@/lib/auth';
import { getClassrooms, deleteClassroom } from '@/lib/api';
import { School, Plus, Settings, Trash2, AlertCircle, Search, Users } from 'lucide-react';
import DeleteConfirmDialog from '@/components/DeleteConfirmDialog';

export default function ClassroomsPage() {
  useAuth();

  const [classrooms, setClassrooms] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');
  const [search, setSearch] = useState('');
  const [deleteDialogOpen, setDeleteDialogOpen] = useState(false);
  const [deleteTarget, setDeleteTarget] = useState(null);
  const [deleting, setDeleting] = useState(false);

  useEffect(() => {
    getClassrooms(1, 100).then((data) => {
      setClassrooms(data?.items ?? data ?? []);
      setLoading(false);
    });
  }, []);

  async function handleDelete(id, name) {
    if (!confirm(`Delete classroom "${name}"? This cannot be undone.`)) return;
    const res = await deleteClassroom(id);
    if (res?.ok) {
      setClassrooms((prev) => prev.filter((c) => c.id !== id));
    } else {
      setError('Failed to delete classroom.');
    }
  }

  async function handleDeleteConfirm() {
    if (!deleteTarget) return;
    setDeleting(true);
    try {
      const res = await deleteClassroom(deleteTarget.id);
      if (res?.ok) {
        setClassrooms((prev) => prev.filter((c) => c.id !== deleteTarget.id));
        setDeleteDialogOpen(false);
        setDeleteTarget(null);
      } else {
        setError('Failed to delete classroom.');
      }
    } finally {
      setDeleting(false);
    }
  }

  function handleDeleteClick(id, name) {
    setDeleteTarget({ id, name });
    setDeleteDialogOpen(true);
  }

  const filtered = classrooms.filter(c =>
    (c.className ?? c.name ?? '').toLowerCase().includes(search.toLowerCase())
  );

  return (
    <div className="admin-page">
      {/* Header */}
      <div className="flex items-center justify-between mb-6">
        <div className="flex items-center gap-3">
          <div className="admin-header-icon">
            <School className="w-5 h-5 text-white" />
          </div>
          <div>
            <h1 className="text-2xl font-bold text-slate-900">Classrooms</h1>
            <p className="text-sm text-slate-500">{classrooms.length} total</p>
          </div>
        </div>
        <Link
          href="/admin/classrooms/new"
          className="admin-btn-primary"
        >
          <Plus className="w-4 h-4" />
          Add Classroom
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
          placeholder="Search classrooms..."
          value={search}
          onChange={(e) => setSearch(e.target.value)}
          className="w-full max-w-sm pl-10 pr-4 py-2.5 bg-white border border-slate-200 rounded-xl text-sm focus:outline-none focus:ring-2 focus:ring-emerald-500 focus:border-transparent"
        />
      </div>

      {loading ? (
        <div className="bg-white rounded-2xl border border-slate-100 p-12 text-center">
          <div className="w-8 h-8 border-2 border-emerald-500 border-t-transparent rounded-full animate-spin mx-auto mb-3" />
          <p className="text-slate-500 text-sm">Loading classrooms...</p>
        </div>
      ) : filtered.length === 0 ? (
        <div className="bg-white rounded-2xl border border-slate-100 p-12 text-center">
          <School className="w-12 h-12 text-slate-300 mx-auto mb-3" />
          <p className="text-slate-500 text-sm">
            {search ? 'No classrooms match your search.' : 'No classrooms yet.'}
          </p>
        </div>
      ) : (
        <div className="bg-white rounded-2xl border border-slate-100 shadow-sm overflow-hidden">
          <table className="w-full text-sm">
            <thead className="bg-slate-50 border-b border-slate-100">
              <tr>
                <th className="text-left px-5 py-4 font-semibold text-slate-600">Class Name</th>
                <th className="text-left px-5 py-4 font-semibold text-slate-600">Grade</th>
                <th className="text-left px-5 py-4 font-semibold text-slate-600">Teacher</th>
                <th className="text-left px-5 py-4 font-semibold text-slate-600">Students</th>
                <th className="px-5 py-4 w-24"></th>
              </tr>
            </thead>
            <tbody className="divide-y divide-slate-50">
              {filtered.map((c) => (
                <tr key={c.id} className="hover:bg-slate-50/50 transition-colors">
                  <td className="px-5 py-4">
                    <div className="flex items-center gap-3">
                      <div className="w-9 h-9 rounded-lg bg-[#526d82] flex items-center justify-center">
                        <School className="w-4 h-4 text-white" />
                      </div>
                      <span className="font-medium text-slate-900">{c.className ?? c.name}</span>
                    </div>
                  </td>
                  <td className="px-5 py-4">
                    <span className="px-2.5 py-1 rounded-full text-xs font-medium bg-slate-100 text-slate-600">
                      {c.grade ?? '—'}
                    </span>
                  </td>
                  <td className="px-5 py-4 text-slate-600">
                    {c.teacherName ?? c.teacher?.firstName ?? <span className="text-slate-400">Not assigned</span>}
                  </td>
                  <td className="px-5 py-4">
                    <div className="flex items-center gap-1.5 text-slate-600">
                      <Users className="w-4 h-4 text-slate-400" />
                      {c.studentCount ?? c.students?.length ?? 0}
                    </div>
                  </td>
                  <td className="px-5 py-4">
                    <div className="flex items-center justify-end gap-1">
                      <Link
                        href={`/admin/classrooms/${c.id}`}
                        className="p-2 text-slate-400 hover:text-slate-900 hover:bg-slate-100 rounded-lg transition-colors"
                        title="Manage"
                      >
                        <Settings className="w-4 h-4" />
                      </Link>
                      <button
                        onClick={() => handleDeleteClick(c.id, c.className ?? c.name)}
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
        title="Delete Classroom?"
        message={`Are you sure you want to delete classroom "${deleteTarget?.name}"? This action cannot be undone.`}
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
