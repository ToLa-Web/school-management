'use client';
import { useEffect, useState } from 'react';
import Link from 'next/link';
import { useAuth } from '@/lib/auth';
import { getTeachers, deleteTeacher } from '@/lib/api';

export default function TeachersPage() {
  useAuth();

  const [teachers, setTeachers] = useState([]);
  const [loading,  setLoading]  = useState(true);
  const [error,    setError]    = useState('');

  async function load() {
    setLoading(true);
    const data = await getTeachers(1, 100);
    setTeachers(data?.items ?? data ?? []);
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

  return (
    <div>
      <div className="flex items-center justify-between mb-6">
        <h1 className="text-2xl font-bold">Teachers</h1>
        <Link
          href="/teachers/new"
          className="bg-blue-600 hover:bg-blue-700 text-white text-sm font-medium px-4 py-2 rounded-md transition-colors"
        >
          + New Teacher
        </Link>
      </div>

      {error && (
        <div className="bg-red-50 border border-red-200 text-red-700 text-sm rounded-md p-3 mb-4">
          {error}
        </div>
      )}

      {loading ? (
        <p className="text-gray-500 text-sm">Loading…</p>
      ) : teachers.length === 0 ? (
        <p className="text-gray-500 text-sm">No teachers yet. Create the first one.</p>
      ) : (
        <div className="bg-white rounded-xl shadow-sm overflow-hidden">
          <table className="w-full text-sm">
            <thead className="bg-gray-50 border-b border-gray-200">
              <tr>
                <th className="text-left px-4 py-3 font-medium text-gray-600">Name</th>
                <th className="text-left px-4 py-3 font-medium text-gray-600">Subject</th>
                <th className="text-left px-4 py-3 font-medium text-gray-600">Phone</th>
                <th className="text-left px-4 py-3 font-medium text-gray-600">Date of Birth</th>
                <th className="px-4 py-3"></th>
              </tr>
            </thead>
            <tbody className="divide-y divide-gray-100">
              {teachers.map((t) => (
                <tr key={t.id} className="hover:bg-gray-50">
                  <td className="px-4 py-3 font-medium">
                    {t.firstName} {t.lastName}
                  </td>
                  <td className="px-4 py-3 text-gray-600">{t.subject ?? '—'}</td>
                  <td className="px-4 py-3 text-gray-600">{t.phoneNumber ?? '—'}</td>
                  <td className="px-4 py-3 text-gray-600">
                    {t.dateOfBirth ? new Date(t.dateOfBirth).toLocaleDateString() : '—'}
                  </td>
                  <td className="px-4 py-3 text-right space-x-2">
                    <Link
                      href={`/teachers/${t.id}`}
                      className="text-blue-600 hover:underline"
                    >
                      Edit
                    </Link>
                    <button
                      onClick={() => handleDelete(t.id, `${t.firstName} ${t.lastName}`)}
                      className="text-red-500 hover:underline"
                    >
                      Delete
                    </button>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      )}
    </div>
  );
}
