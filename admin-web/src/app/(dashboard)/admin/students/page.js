'use client';
import { useEffect, useState } from 'react';
import Link from 'next/link';
import { useAuth } from '@/lib/auth';
import { getStudents, deleteStudent } from '@/lib/api';
import { GraduationCap, Plus, Pencil, Trash2, AlertCircle, Search, X as XIcon } from 'lucide-react';
import DeleteConfirmDialog from '@/components/DeleteConfirmDialog';

export default function StudentsPage() {
  useAuth();

  const [students, setStudents] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');
  const [search, setSearch] = useState('');

  // Individual filter states
  const [filterName, setFilterName] = useState('');
  const [filterEmail, setFilterEmail] = useState('');
  const [filterPhone, setFilterPhone] = useState('');
  const [deleteDialogOpen, setDeleteDialogOpen] = useState(false);
  const [deleteTarget, setDeleteTarget] = useState(null);
  const [deleting, setDeleting] = useState(false);

  async function load() {
    setLoading(true);
    const data = await getStudents(1, 100);
    setStudents(data?.items ?? data ?? []);
    setLoading(false);
  }

  useEffect(() => { load(); }, []);

  async function handleDelete(id, name) {
    if (!confirm(`Delete ${name}? This cannot be undone.`)) return;
    const res = await deleteStudent(id);
    if (res?.ok) {
      setStudents((prev) => prev.filter((s) => s.id !== id));
    } else {
      setError('Failed to delete student.');
    }
  }

  async function handleDeleteConfirm() {
    if (!deleteTarget) return;
    setDeleting(true);
    try {
      const res = await deleteStudent(deleteTarget.id);
      if (res?.ok) {
        setStudents((prev) => prev.filter((s) => s.id !== deleteTarget.id));
        setDeleteDialogOpen(false);
        setDeleteTarget(null);
      } else {
        setError('Failed to delete student.');
      }
    } finally {
      setDeleting(false);
    }
  }

  function handleDeleteClick(id, name) {
    setDeleteTarget({ id, name });
    setDeleteDialogOpen(true);
  }

  // Filter students based on all criteria
  const getFilteredStudents = () => {
    return students.filter((s) => {
      const fullName = `${s.firstName ?? ''} ${s.lastName ?? ''}`.toLowerCase();
      const email = (s.email ?? '').toLowerCase();
      const phone = (s.phone ?? '').toLowerCase();

      const nameMatch = fullName.includes(filterName.toLowerCase());
      const emailMatch = email.includes(filterEmail.toLowerCase());
      const phoneMatch = phone.includes(filterPhone.toLowerCase());

      return nameMatch && emailMatch && phoneMatch;
    });
  };

  const filtered = getFilteredStudents();
  const hasFilters = filterName || filterEmail || filterPhone;

  const clearFilters = () => {
    setFilterName('');
    setFilterEmail('');
    setFilterPhone('');
  };

  return (
    <div className="admin-page">
      {/* Header */}
      <div className="flex items-center justify-between mb-6">
        <div className="flex items-center gap-3">
          <div className="admin-header-icon">
            <GraduationCap className="w-5 h-5 text-white" />
          </div>
          <div>
            <h1 className="text-2xl font-bold text-slate-900">Students</h1>
            <p className="text-sm text-slate-500">
              {hasFilters 
                ? `${filtered.length} of ${students.length} total`
                : `${students.length} total`}
            </p>
          </div>
        </div>
        <Link
          href="/admin/students/new"
          className="admin-btn-primary"
        >
          <Plus className="w-4 h-4" />
          Add Student
        </Link>
      </div>

      {error && (
        <div className="flex items-center gap-3 bg-red-50 border border-red-100 text-red-700 text-sm rounded-xl p-4 mb-4">
          <AlertCircle className="w-5 h-5 shrink-0" />
          {error}
        </div>
      )}

      {/* Filters */}
      <div className="bg-slate-50 rounded-xl border border-slate-100 p-4 mb-4">
        <div className="flex items-center justify-between mb-4">
          <h3 className="font-semibold text-slate-900 flex items-center gap-2">
            <Search className="w-4 h-4 text-slate-500" />
            Filters
          </h3>
          {hasFilters && (
            <button
              onClick={clearFilters}
              className="text-xs font-medium text-slate-600 hover:text-slate-900 hover:bg-white px-2.5 py-1.5 rounded-lg transition-colors"
            >
              <XIcon className="w-3.5 h-3.5 inline mr-1" />
              Clear Filters
            </button>
          )}
        </div>
        
        <div className="grid grid-cols-1 md:grid-cols-3 gap-3">
          {/* Name filter */}
          <div>
            <label className="text-xs font-semibold text-slate-700 mb-1.5 block">Search by Name</label>
            <input
              type="text"
              placeholder="First or last name..."
              value={filterName}
              onChange={(e) => setFilterName(e.target.value)}
              className="w-full px-3 py-2 text-sm border border-slate-200 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent"
            />
          </div>

          {/* Email filter */}
          <div>
            <label className="text-xs font-semibold text-slate-700 mb-1.5 block">Search by Email</label>
            <input
              type="text"
              placeholder="Email address..."
              value={filterEmail}
              onChange={(e) => setFilterEmail(e.target.value)}
              className="w-full px-3 py-2 text-sm border border-slate-200 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent"
            />
          </div>

          {/* Phone filter */}
          <div>
            <label className="text-xs font-semibold text-slate-700 mb-1.5 block">Search by Phone</label>
            <input
              type="text"
              placeholder="Phone number..."
              value={filterPhone}
              onChange={(e) => setFilterPhone(e.target.value)}
              className="w-full px-3 py-2 text-sm border border-slate-200 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent"
            />
          </div>
        </div>
      </div>

      {loading ? (
        <div className="bg-white rounded-2xl border border-slate-100 p-12 text-center">
          <div className="w-8 h-8 border-2 border-amber-500 border-t-transparent rounded-full animate-spin mx-auto mb-3" />
          <p className="text-slate-500 text-sm">Loading students...</p>
        </div>
      ) : filtered.length === 0 ? (
        <div className="bg-white rounded-2xl border border-slate-100 p-12 text-center">
          <GraduationCap className="w-12 h-12 text-slate-300 mx-auto mb-3" />
          <p className="text-slate-500 text-sm">
            {search ? 'No students match your search.' : 'No students yet. Create the first one.'}
          </p>
        </div>
      ) : (
        <div className="bg-white rounded-2xl border border-slate-100 shadow-sm overflow-hidden">
          <table className="w-full text-sm">
            <thead className="bg-slate-50 border-b border-slate-100">
              <tr>
                <th className="text-left px-5 py-4 font-semibold text-slate-600">Name</th>
                <th className="text-left px-5 py-4 font-semibold text-slate-600">Email</th>
                <th className="text-left px-5 py-4 font-semibold text-slate-600">Gender</th>
                <th className="text-left px-5 py-4 font-semibold text-slate-600">Phone</th>
                <th className="text-left px-5 py-4 font-semibold text-slate-600">Date of Birth</th>
                <th className="text-left px-5 py-4 font-semibold text-slate-600">Address</th>
                <th className="px-5 py-4 w-24"></th>
              </tr>
            </thead>
            <tbody className="divide-y divide-slate-50">
              {filtered.map((s) => (
                <tr key={s.id} className="hover:bg-slate-50/50 transition-colors">
                  <td className="px-5 py-4">
                    <div className="flex items-center gap-3">
                      <div className="w-9 h-9 rounded-full bg-[#526d82] flex items-center justify-center text-white font-semibold text-sm">
                        {s.firstName?.[0]}{s.lastName?.[0]}
                      </div>
                      <span className="font-medium text-slate-900">{s.firstName} {s.lastName}</span>
                    </div>
                  </td>
                  <td className="px-5 py-4 text-slate-600">{s.email ?? '—'}</td>
                  <td className="px-5 py-4 text-slate-600">{s.gender ?? '—'}</td>
                  <td className="px-5 py-4 text-slate-600">{s.phone ?? '—'}</td>
                  <td className="px-5 py-4 text-slate-500">
                    {s.dateOfBirth ? new Date(s.dateOfBirth).toLocaleDateString() : '—'}
                  </td>
                  <td className="px-5 py-4 text-slate-500 max-w-xs truncate">{s.address ?? '—'}</td>
                  <td className="px-5 py-4">
                    <div className="flex items-center justify-end gap-1">
                      <Link
                        href={`/admin/students/${s.id}`}
                        className="p-2 text-slate-400 hover:text-slate-900 hover:bg-slate-100 rounded-lg transition-colors"
                        title="Edit"
                      >
                        <Pencil className="w-4 h-4" />
                      </Link>
                      <button
                        onClick={() => handleDeleteClick(s.id, `${s.firstName} ${s.lastName}`)}
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
        title="Delete Student?"
        message={`Are you sure you want to delete ${deleteTarget?.name}? This action cannot be undone.`}
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
