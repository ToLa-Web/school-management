'use client';
import { useEffect, useState } from 'react';
import Link from 'next/link';
import { useAuth } from '@/lib/auth';
import { getTeachers, deleteTeacher, getDepartments } from '@/lib/api';
import { Users, Plus, Pencil, Trash2, AlertCircle, Search, X as XIcon } from 'lucide-react';
import DeleteConfirmDialog from '@/components/DeleteConfirmDialog';

export default function TeachersPage() {
  useAuth();

  const [teachers, setTeachers] = useState([]);
  const [departments, setDepartments] = useState([]);
  const [loading,  setLoading]  = useState(true);
  const [error,    setError]    = useState('');
  const [search,   setSearch]   = useState('');

  // Individual filter states
  const [filterName, setFilterName] = useState('');
  const [filterEmail, setFilterEmail] = useState('');
  const [filterPhone, setFilterPhone] = useState('');
  const [filterDepartment, setFilterDepartment] = useState('');
  const [deleteDialogOpen, setDeleteDialogOpen] = useState(false);
  const [deleteTarget, setDeleteTarget] = useState(null);
  const [deleting, setDeleting] = useState(false);

  async function load() {
    setLoading(true);
    const [teachersData, deptData] = await Promise.all([
      getTeachers(1, 100),
      getDepartments()
    ]);
    setTeachers(teachersData?.items ?? teachersData ?? []);
    setDepartments(Array.isArray(deptData) ? deptData : deptData?.items ?? []);
    setLoading(false);
  }

  useEffect(() => { load(); }, []);

  async function handleDelete(id, name) {
    if (!confirm(`Delete ${name}? This cannot be undone.`)) return;
    const res = await deleteTeacher(id);
    if (res?.ok) {
      setTeachers((prev) => prev.filter((t) => t.id !== id));
    } else {
      setError('Failed to delete teacher.');
    }
  }

  // Filter teachers based on all criteria
  const getFilteredTeachers = () => {
    return teachers.filter((t) => {
      const fullName = `${t.firstName ?? ''} ${t.lastName ?? ''}`.toLowerCase();
      const email = (t.email ?? '').toLowerCase();
      const phone = (t.phone ?? '').toLowerCase();

      const nameMatch = fullName.includes(filterName.toLowerCase());
      const emailMatch = email.includes(filterEmail.toLowerCase());
      const phoneMatch = phone.includes(filterPhone.toLowerCase());
      
      // Check if teacher has the selected department
      const deptMatch = !filterDepartment || 
        (t.departments && t.departments.some(d => d.departmentId === filterDepartment));

      return nameMatch && emailMatch && phoneMatch && deptMatch;
    });
  };
  const filtered = getFilteredTeachers();
  const hasFilters = filterName || filterEmail || filterPhone || filterDepartment;

  const clearFilters = () => {
    setFilterName('');
    setFilterEmail('');
    setFilterPhone('');
    setFilterDepartment('');
  }

  async function handleDeleteConfirm() {
    if (!deleteTarget) return;
    setDeleting(true);
    try {
      const res = await deleteTeacher(deleteTarget.id);
      if (res?.ok) {
        setTeachers((prev) => prev.filter((t) => t.id !== deleteTarget.id));
        setDeleteDialogOpen(false);
        setDeleteTarget(null);
      } else {
        setError('Failed to delete teacher.');
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
            <Users className="w-5 h-5 text-white" />
          </div>
          <div>
            <h1 className="text-2xl font-bold text-slate-900">Teachers</h1>
            <p className="text-sm text-slate-500">
              {hasFilters 
                ? `${filtered.length} of ${teachers.length} total`
                : `${teachers.length} total`}
            </p>
          </div>
        </div>
        <Link
          href="/admin/teachers/new"
          className="admin-btn-primary"
        >
          <Plus className="w-4 h-4" />
          Add Teacher
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
        
        <div className="grid grid-cols-1 md:grid-cols-4 gap-3">
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

          {/* Department filter */}
          <div>
            <label className="text-xs font-semibold text-slate-700 mb-1.5 block">Filter by Department</label>
            <select
              value={filterDepartment}
              onChange={(e) => setFilterDepartment(e.target.value)}
              className="w-full px-3 py-2 text-sm border border-slate-200 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent"
            >
              <option value="">All Departments</option>
              {departments.map((dept) => (
                <option key={dept.id} value={dept.id}>
                  {dept.name}
                </option>
              ))}
            </select>
          </div>
        </div>
      </div>

      {loading ? (
        <div className="bg-white rounded-2xl border border-slate-100 p-12 text-center">
          <div className="w-8 h-8 border-2 border-blue-500 border-t-transparent rounded-full animate-spin mx-auto mb-3" />
          <p className="text-slate-500 text-sm">Loading teachers...</p>
        </div>
      ) : filtered.length === 0 ? (
        <div className="bg-white rounded-2xl border border-slate-100 p-12 text-center">
          <Users className="w-12 h-12 text-slate-300 mx-auto mb-3" />
          <p className="text-slate-500 text-sm">
            {hasFilters ? 'No teachers match your filters.' : 'No teachers yet. Create the first one.'}
          </p>
        </div>
      ) : (
        <div className="bg-white rounded-2xl border border-slate-100 shadow-sm overflow-hidden">
          <table className="w-full text-sm">
            <thead className="bg-slate-50 border-b border-slate-100">
              <tr>
                <th className="text-left px-5 py-4 font-semibold text-slate-600">Name</th>
                <th className="text-left px-5 py-4 font-semibold text-slate-600">Email</th>
                <th className="text-left px-5 py-4 font-semibold text-slate-600">Departments</th>
                <th className="text-left px-5 py-4 font-semibold text-slate-600">Specialization</th>
                <th className="text-left px-5 py-4 font-semibold text-slate-600">Phone</th>
                <th className="text-left px-5 py-4 font-semibold text-slate-600">Date of Birth</th>
                <th className="px-5 py-4 w-24"></th>
              </tr>
            </thead>
            <tbody className="divide-y divide-slate-50">
              {filtered.map((t) => (
                <tr key={t.id} className="hover:bg-slate-50/50 transition-colors">
                  <td className="px-5 py-4">
                    <div className="flex items-center gap-3">
                      <div className="w-9 h-9 rounded-full bg-[#526d82] flex items-center justify-center text-white font-semibold text-sm">
                        {t.firstName?.[0]}{t.lastName?.[0]}
                      </div>
                      <span className="font-medium text-slate-900">{t.firstName} {t.lastName}</span>
                    </div>
                  </td>
                  <td className="px-5 py-4 text-slate-600">{t.email ?? '—'}</td>
                  <td className="px-5 py-4 text-slate-600">
                    {t.departments?.length > 0 
                      ? t.departments.map(d => d.departmentName).join(', ')
                      : <span className="text-slate-400">No departments</span>
                    }
                  </td>
                  <td className="px-5 py-4 text-slate-600">{t.specialization ?? '—'}</td>
                  <td className="px-5 py-4 text-slate-600">{t.phone ?? '—'}</td>
                  <td className="px-5 py-4 text-slate-500">
                    {t.dateOfBirth ? new Date(t.dateOfBirth).toLocaleDateString() : '—'}
                  </td>
                  <td className="px-5 py-4">
                    <div className="flex items-center justify-end gap-1">
                      <Link
                        href={`/admin/teachers/${t.id}`}
                        className="p-2 text-slate-400 hover:text-slate-900 hover:bg-slate-100 rounded-lg transition-colors"
                        title="Edit"
                      >
                        <Pencil className="w-4 h-4" />
                      </Link>
                      <button
                        onClick={() => handleDeleteClick(t.id, `${t.firstName} ${t.lastName}`)}
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
        title="Delete Teacher?"
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
