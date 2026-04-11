'use client';
import { useEffect, useState } from 'react';
import Link from 'next/link';
import { useAuth } from '@/lib/auth';
import { getDepartments, deleteDepartment } from '@/lib/api';
import { Building2, Plus, Pencil, Trash2, AlertCircle, Search, CheckCircle, XCircle, X as XIcon } from 'lucide-react';
import DeleteConfirmDialog from '@/components/DeleteConfirmDialog';

export default function DepartmentsPage() {
  useAuth();

  const [departments, setDepartments] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');
  const [search, setSearch] = useState('');
  const [deleteDialogOpen, setDeleteDialogOpen] = useState(false);
  const [deleteTarget, setDeleteTarget] = useState(null);
  const [deleting, setDeleting] = useState(false);

  async function load() {
    setLoading(true);
    try {
      const data = await getDepartments();
      setDepartments(Array.isArray(data) ? data : data?.items ?? []);
    } catch (err) {
      setError('Failed to load departments');
    }
    setLoading(false);
  }

  useEffect(() => { load(); }, []);

  // Filter departments based on search
  const filtered = departments.filter(d =>
    d.name.toLowerCase().includes(search.toLowerCase()) ||
    (d.description && d.description.toLowerCase().includes(search.toLowerCase()))
  );

  const clearFilters = () => {
    setSearch('');
  }

  async function handleDeleteConfirm() {
    if (!deleteTarget) return;
    setDeleting(true);
    try {
      const res = await deleteDepartment(deleteTarget.id);
      if (res?.ok) {
        setDepartments((prev) => prev.filter((d) => d.id !== deleteTarget.id));
        setDeleteDialogOpen(false);
        setDeleteTarget(null);
      } else {
        setError('Failed to delete department.');
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
            <Building2 className="w-5 h-5 text-white" />
          </div>
          <div>
            <h1 className="text-2xl font-bold text-slate-900">Departments</h1>
            <p className="text-sm text-slate-500">
              {search ? `${filtered.length} of ${departments.length} total` : `${departments.length} total`}
            </p>
          </div>
        </div>
        <Link
          href="/admin/departments/new"
          className="admin-btn-primary"
        >
          <Plus className="w-4 h-4" />
          Add Department
        </Link>
      </div>

      {error && (
        <div className="flex items-center gap-3 bg-red-50 border border-red-100 text-red-700 text-sm rounded-xl p-4 mb-4">
          <AlertCircle className="w-5 h-5 shrink-0" />
          {error}
        </div>
      )}

      {/* Search Filter */}
      <div className="bg-slate-50 rounded-xl border border-slate-100 p-4 mb-4">
        <div className="flex items-center justify-between mb-4">
          <h3 className="font-semibold text-slate-900 flex items-center gap-2">
            <Search className="w-4 h-4 text-slate-500" />
            Search
          </h3>
          {search && (
            <button
              onClick={clearFilters}
              className="text-xs font-medium text-slate-600 hover:text-slate-900 hover:bg-white px-2.5 py-1.5 rounded-lg transition-colors"
            >
              <XIcon className="w-3.5 h-3.5 inline mr-1" />
              Clear Search
            </button>
          )}
        </div>
        
        <div>
          <label className="text-xs font-semibold text-slate-700 mb-1.5 block">Search by Name or Description</label>
          <input
            type="text"
            placeholder="Department name or description..."
            value={search}
            onChange={(e) => setSearch(e.target.value)}
            className="w-full px-3 py-2 text-sm border border-slate-200 rounded-lg focus:outline-none focus:ring-2 focus:ring-purple-500 focus:border-transparent"
          />
        </div>
      </div>

      {loading ? (
        <div className="bg-white rounded-2xl border border-slate-100 p-12 text-center">
          <div className="w-8 h-8 border-2 border-purple-500 border-t-transparent rounded-full animate-spin mx-auto mb-3" />
          <p className="text-slate-500 text-sm">Loading departments...</p>
        </div>
      ) : filtered.length === 0 ? (
        <div className="bg-white rounded-2xl border border-slate-100 p-12 text-center">
          <Building2 className="w-12 h-12 text-slate-300 mx-auto mb-3" />
          <p className="text-slate-500 text-sm">
            {search ? 'No departments match your search.' : 'No departments yet.'}
          </p>
        </div>
      ) : (
        <div className="bg-white rounded-2xl border border-slate-100 shadow-sm overflow-hidden">
          <table className="w-full text-sm">
            <thead className="bg-slate-50 border-b border-slate-100">
              <tr>
                <th className="text-left px-5 py-4 font-semibold text-slate-600">Department Name</th>
                <th className="text-left px-5 py-4 font-semibold text-slate-600">Description</th>
                <th className="text-left px-5 py-4 font-semibold text-slate-600">Status</th>
                <th className="text-left px-5 py-4 font-semibold text-slate-600">Created</th>
                <th className="px-5 py-4 w-24" />
              </tr>
            </thead>
            <tbody className="divide-y divide-slate-50">
              {filtered.map((d) => (
                <tr key={d.id} className="hover:bg-slate-50/50 transition-colors">
                  <td className="px-5 py-4">
                    <div className="flex items-center gap-3">
                      <div className="w-9 h-9 rounded-lg bg-[#526d82] flex items-center justify-center">
                        <Building2 className="w-4 h-4 text-white" />
                      </div>
                      <Link href={`/admin/departments/${d.id}`} className="font-medium text-slate-900 hover:text-slate-700 transition-colors">
                        {d.name}
                      </Link>
                    </div>
                  </td>
                  <td className="px-5 py-4 text-slate-600 max-w-xs truncate">
                    {d.description ?? <span className="text-slate-400">—</span>}
                  </td>
                  <td className="px-5 py-4">
                    <span className={`inline-flex items-center gap-1.5 px-2.5 py-1 rounded-full text-xs font-medium ${
                      d.isActive
                        ? 'bg-emerald-50 text-emerald-700'
                        : 'bg-slate-100 text-slate-500'
                    }`}>
                      {d.isActive ? <CheckCircle className="w-3.5 h-3.5" /> : <XCircle className="w-3.5 h-3.5" />}
                      {d.isActive ? 'Active' : 'Inactive'}
                    </span>
                  </td>
                  <td className="px-5 py-4 text-slate-500">
                    {d.createdAt ? new Date(d.createdAt).toLocaleDateString() : '—'}
                  </td>
                  <td className="px-5 py-4">
                    <div className="flex items-center justify-end gap-1">
                      <Link
                        href={`/admin/departments/${d.id}`}
                        className="p-2 text-slate-400 hover:text-slate-900 hover:bg-slate-100 rounded-lg transition-colors"
                        title="Edit"
                      >
                        <Pencil className="w-4 h-4" />
                      </Link>
                      <button
                        onClick={() => handleDeleteClick(d.id, d.name)}
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
        title="Delete Department?"
        message={`Are you sure you want to delete department "${deleteTarget?.name}"? This action cannot be undone.`}
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
