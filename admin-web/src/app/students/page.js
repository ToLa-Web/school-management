'use client';
import Link from 'next/link';
import { useAuth } from '@/lib/auth';

export default function StudentsPage() {
  useAuth();
  return (
    <div>
      <div className="flex items-center justify-between mb-6">
        <h1 className="text-2xl font-bold">Students</h1>
      </div>
      <div className="bg-white rounded-xl shadow-sm p-10 text-center text-gray-400">
        <p className="text-4xl mb-3">🎒</p>
        <p className="text-base font-medium text-gray-600">Student management coming soon</p>
        <p className="text-sm mt-1">
          You can already{' '}
          <Link href="/classrooms" className="text-blue-600 hover:underline">
            enroll students into classrooms
          </Link>{' '}
          from the Classrooms page.
        </p>
      </div>
    </div>
  );
}
