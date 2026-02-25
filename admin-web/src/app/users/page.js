'use client';
import { useEffect, useState } from 'react';
import { useAuth } from '@/lib/auth';
import { getTeachers, getStudents } from '@/lib/api';

// The auth-service has no "list all users" endpoint.
// We show what we can: all school-service records (teachers + students).
export default function UsersPage() {
  useAuth();

  const [teachers,  setTeachers]  = useState([]);
  const [students,  setStudents]  = useState([]);
  const [loading,   setLoading]   = useState(true);

  useEffect(() => {
    Promise.all([
      getTeachers(1, 200),
      getStudents(1, 200),
    ]).then(([tea, stu]) => {
      setTeachers(tea?.items ?? tea ?? []);
      setStudents(stu?.items ?? stu ?? []);
      setLoading(false);
    });
  }, []);

  const allUsers = [
    ...teachers.map((t) => ({ ...t, type: 'Teacher' })),
    ...students.map((s) => ({ ...s, type: 'Student' })),
  ].sort((a, b) => `${a.firstName}${a.lastName}`.localeCompare(`${b.firstName}${b.lastName}`));

  return (
    <div>
      <h1 className="text-2xl font-bold mb-2">Users</h1>
      <p className="text-sm text-gray-500 mb-6">
        All teachers and students registered in the school service.
      </p>

      {loading ? (
        <p className="text-gray-500 text-sm">Loading…</p>
      ) : allUsers.length === 0 ? (
        <p className="text-gray-500 text-sm">No records found.</p>
      ) : (
        <div className="bg-white rounded-xl shadow-sm overflow-hidden">
          <table className="w-full text-sm">
            <thead className="bg-gray-50 border-b border-gray-200">
              <tr>
                <th className="text-left px-4 py-3 font-medium text-gray-600">Name</th>
                <th className="text-left px-4 py-3 font-medium text-gray-600">Role</th>
                <th className="text-left px-4 py-3 font-medium text-gray-600">Subject / Grade</th>
                <th className="text-left px-4 py-3 font-medium text-gray-600">Phone</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-gray-100">
              {allUsers.map((u) => (
                <tr key={`${u.type}-${u.id}`} className="hover:bg-gray-50">
                  <td className="px-4 py-3 font-medium">{u.firstName} {u.lastName}</td>
                  <td className="px-4 py-3">
                    <span className={`inline-flex items-center px-2 py-0.5 rounded text-xs font-medium ${
                      u.type === 'Teacher'
                        ? 'bg-blue-100 text-blue-700'
                        : 'bg-yellow-100 text-yellow-700'
                    }`}>
                      {u.type}
                    </span>
                  </td>
                  <td className="px-4 py-3 text-gray-600">{u.subject ?? u.grade ?? '—'}</td>
                  <td className="px-4 py-3 text-gray-600">{u.phoneNumber ?? '—'}</td>
                </tr>
              ))}
            </tbody>
          </table>
          <p className="text-xs text-gray-400 px-4 py-2 border-t border-gray-100">
            {allUsers.length} records — {teachers.length} teachers, {students.length} students
          </p>
        </div>
      )}
    </div>
  );
}
