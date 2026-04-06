'use client';
import { Shield } from 'lucide-react';

export default function StudentDashboard() {
  return (
    <div className="p-8">
      <div className="flex items-center gap-4 mb-8">
        <div className="p-3 bg-indigo-100 text-indigo-600 rounded-xl">
          <Shield className="w-8 h-8" />
        </div>
        <div>
          <h1 className="text-2xl font-bold text-slate-800">Student Dashboard</h1>
          <p className="text-slate-500">Welcome to your student portal.</p>
        </div>
      </div>
      <div className="grid gap-6 md:grid-cols-2 lg:grid-cols-3">
        {/* Placeholder cards */}
        <div className="p-6 bg-white border border-slate-200 rounded-2xl shadow-sm">
          <h3 className="font-semibold text-slate-800">My Grades</h3>
          <p className="text-slate-500 mt-2">View your recent assignments and grades.</p>
        </div>
        <div className="p-6 bg-white border border-slate-200 rounded-2xl shadow-sm">
          <h3 className="font-semibold text-slate-800">My Schedule</h3>
          <p className="text-slate-500 mt-2">Check your class timetable.</p>
        </div>
      </div>
    </div>
  );
}
