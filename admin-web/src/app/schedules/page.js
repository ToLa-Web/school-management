'use client';
import { useEffect, useState } from 'react';
import { useAuth } from '@/lib/auth';
import { getClassroomSchedule, getClassrooms } from '@/lib/api';
import { CalendarDays, Search, AlertCircle, Clock, BookOpen, User, School } from 'lucide-react';

const DAYS = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
const DAY_COLORS = {
  Monday: 'from-blue-500 to-indigo-500',
  Tuesday: 'from-purple-500 to-violet-500',
  Wednesday: 'from-emerald-500 to-teal-500',
  Thursday: 'from-amber-500 to-orange-500',
  Friday: 'from-rose-500 to-pink-500',
  Saturday: 'from-cyan-500 to-sky-500',
  Sunday: 'from-slate-500 to-slate-600',
};

export default function SchedulesPage() {
  useAuth();

  const [schedules, setSchedules] = useState([]);
  const [classrooms, setClassrooms] = useState([]);
  const [classroomId, setClassroomId] = useState('');
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');

  useEffect(() => {
    async function loadClassrooms() {
      const data = await getClassrooms(1, 100);
      setClassrooms(data?.items ?? data ?? []);
    }
    loadClassrooms();
  }, []);

  async function handleSearch(e) {
    e?.preventDefault();
    if (!classroomId) return;
    setLoading(true);
    setError('');
    const data = await getClassroomSchedule(classroomId);
    if (data) {
      setSchedules(Array.isArray(data) ? data : data.items ?? []);
    } else {
      setError('Failed to load schedules.');
    }
    setLoading(false);
  }

  // Group by day of week
  const byDay = DAYS.reduce((acc, day) => {
    acc[day] = schedules.filter((s) => s.dayOfWeek === day);
    return acc;
  }, {});

  const hasSchedules = schedules.length > 0;

  return (
    <div>
      {/* Header */}
      <div className="flex items-center gap-3 mb-6">
        <div className="w-10 h-10 rounded-xl bg-gradient-to-br from-rose-500 to-pink-600 flex items-center justify-center">
          <CalendarDays className="w-5 h-5 text-white" />
        </div>
        <div>
          <h1 className="text-2xl font-bold text-slate-900">Schedules</h1>
          <p className="text-sm text-slate-500">View weekly class schedules</p>
        </div>
      </div>

      {/* Classroom filter */}
      <form
        onSubmit={handleSearch}
        className="bg-white rounded-2xl border border-slate-100 shadow-sm p-5 mb-6"
      >
        <div className="flex flex-wrap gap-4 items-end">
          <div className="flex-1 min-w-[220px]">
            <label className="block text-xs font-semibold text-slate-600 mb-1.5">Classroom</label>
            <select
              value={classroomId}
              onChange={(e) => setClassroomId(e.target.value)}
              required
              className="w-full border border-slate-200 rounded-xl px-3 py-2.5 text-sm focus:outline-none focus:ring-2 focus:ring-rose-500 focus:border-transparent bg-slate-50"
            >
              <option value="">— Select a classroom —</option>
              {classrooms.map((c) => (
                <option key={c.id} value={c.id}>{c.name}</option>
              ))}
            </select>
          </div>

          <button
            type="submit"
            disabled={!classroomId}
            className="bg-gradient-to-r from-rose-500 to-pink-600 hover:from-rose-600 hover:to-pink-700 disabled:opacity-50 disabled:cursor-not-allowed text-white text-sm font-medium px-6 py-2.5 rounded-xl shadow-lg shadow-rose-500/20 hover:shadow-rose-500/30 transition-all flex items-center gap-2"
          >
            <Search className="w-4 h-4" />
            Load Schedule
          </button>
        </div>
      </form>

      {error && (
        <div className="flex items-center gap-3 bg-red-50 border border-red-100 text-red-700 text-sm rounded-xl p-4 mb-4">
          <AlertCircle className="w-5 h-5 shrink-0" />
          {error}
        </div>
      )}

      {loading ? (
        <div className="bg-white rounded-2xl border border-slate-100 p-12 text-center">
          <div className="w-8 h-8 border-2 border-rose-500 border-t-transparent rounded-full animate-spin mx-auto mb-3" />
          <p className="text-slate-500 text-sm">Loading schedule...</p>
        </div>
      ) : !hasSchedules ? (
        <div className="bg-white rounded-2xl border border-slate-100 p-12 text-center">
          <CalendarDays className="w-12 h-12 text-slate-300 mx-auto mb-3" />
          <p className="text-slate-500 text-sm">
            {classroomId ? 'No schedule entries for this classroom.' : 'Select a classroom to view its schedule.'}
          </p>
        </div>
      ) : (
        <div className="space-y-4">
          {DAYS.map((day) => {
            const items = byDay[day];
            if (items.length === 0) return null;
            return (
              <div key={day} className="bg-white rounded-2xl border border-slate-100 shadow-sm overflow-hidden">
                <div className={`bg-gradient-to-r ${DAY_COLORS[day]} px-5 py-3`}>
                  <span className="font-semibold text-white text-sm">{day}</span>
                  <span className="ml-2 text-white/70 text-xs">({items.length} {items.length === 1 ? 'class' : 'classes'})</span>
                </div>
                <div className="divide-y divide-slate-50">
                  {items.map((s) => (
                    <div key={s.id} className="px-5 py-4 flex items-center gap-4 hover:bg-slate-50/50 transition-colors">
                      <div className="flex items-center gap-2 min-w-[100px]">
                        <Clock className="w-4 h-4 text-slate-400" />
                        <span className="font-medium text-slate-900">{s.time ?? '—'}</span>
                      </div>
                      <div className="flex items-center gap-2 flex-1">
                        <BookOpen className="w-4 h-4 text-purple-500" />
                        <span className="text-slate-700">{s.subjectName ?? s.subjectId ?? '—'}</span>
                      </div>
                      <div className="flex items-center gap-2 flex-1">
                        <User className="w-4 h-4 text-blue-500" />
                        <span className="text-slate-600">{s.teacherName ?? s.teacherId ?? '—'}</span>
                      </div>
                      <div className="flex items-center gap-2">
                        <School className="w-4 h-4 text-emerald-500" />
                        <span className="text-slate-500">{s.classroomName ?? s.classroomId ?? '—'}</span>
                      </div>
                    </div>
                  ))}
                </div>
              </div>
            );
          })}
        </div>
      )}
    </div>
  );
}
