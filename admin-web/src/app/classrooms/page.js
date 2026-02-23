'use client';
import { useEffect, useState } from 'react';
import Link from 'next/link';
import { useAuth } from '@/lib/auth';
import { getClassrooms, deleteClassroom } from '@/lib/api';

export default function ClassroomsPage() {
  useAuth();

  const [classrooms, setClassrooms] = useState([]);
  const [loading,    setLoading]    = useState(true);
  const [error,      setError]      = useState('');

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

  return (
    <div>
      <div className="flex items-center justify-between mb-6">
        <h1 className="text-2xl font-bold">Classrooms</h1>
        <Link
          href="/classrooms/new"
          className="bg-blue-600 hover:bg-blue-700 text-white text-sm font-medium px-4 py-2 rounded-md transition-colors"
        >
          + New Classroom
        </Link>
      </div>

      {error && (
        <div className="bg-red-50 border border-red-200 text-red-700 text-sm rounded-md p-3 mb-4">
          {error}
        </div>
      )}

      {loading ? (
        <p className="text-gray-500 text-sm">Loading…</p>
      ) : classrooms.length === 0 ? (
        <p className="text-gray-500 text-sm">No classrooms yet.</p>
      ) : (
        <div className="bg-white rounded-xl shadow-sm overflow-hidden">
          <table className="w-full text-sm">
            <thead className="bg-gray-50 border-b border-gray-200">
              <tr>
                <th className="text-left px-4 py-3 font-medium text-gray-600">Class Name</th>
                <th className="text-left px-4 py-3 font-medium text-gray-600">Grade</th>
                <th className="text-left px-4 py-3 font-medium text-gray-600">Teacher</th>
                <th className="text-left px-4 py-3 font-medium text-gray-600">Students</th>
                <th className="px-4 py-3"></th>
              </tr>
            </thead>
            <tbody className="divide-y divide-gray-100">
              {classrooms.map((c) => (
                <tr key={c.id} className="hover:bg-gray-50">
                  <td className="px-4 py-3 font-medium">{c.className ?? c.name}</td>
                  <td className="px-4 py-3 text-gray-600">{c.grade ?? '—'}</td>
                  <td className="px-4 py-3 text-gray-600">
                    {c.teacherName ?? c.teacher?.firstName ?? '—'}
                  </td>
                  <td className="px-4 py-3 text-gray-600">
                    {c.studentCount ?? c.students?.length ?? '—'}
                  </td>
                  <td className="px-4 py-3 text-right space-x-2">
                    <Link
                      href={`/classrooms/${c.id}`}
                      className="text-blue-600 hover:underline"
                    >
                      Manage
                    </Link>
                    <button
                      onClick={() => handleDelete(c.id, c.className ?? c.name)}
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
