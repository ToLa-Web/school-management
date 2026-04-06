'use client';

import { useEffect, useState } from 'react';
import { useAuth } from '@/lib/auth';
import { createSchedule, deleteSchedule, getClassroomSchedule, getClassrooms, getSubjects, getTeachers } from '@/lib/api';
import { AlertCircle, BookOpen, CalendarDays, Clock, Plus, School, Search, Trash2, User, X } from 'lucide-react';

const DAYS = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];

function toItems(data) {
  if (Array.isArray(data)) return data;
  if (Array.isArray(data?.items)) return data.items;
  return [];
}

function formatTimeRange(item) {
  if (!item?.startTime || !item?.endTime) return '—';
  return `${String(item.startTime).slice(0, 5)} - ${String(item.endTime).slice(0, 5)}`;
}

export default function SchedulesPage() {
  useAuth([4]);

  const [schedules, setSchedules] = useState([]);
  const [classrooms, setClassrooms] = useState([]);
  const [subjects, setSubjects] = useState([]);
  const [teachers, setTeachers] = useState([]);
  const [classroomId, setClassroomId] = useState('');
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');
  const [showForm, setShowForm] = useState(false);
  const [saving, setSaving] = useState(false);
  const [scheduleForm, setScheduleForm] = useState({
    classroomId: '',
    subjectId: '',
    teacherId: '',
    dayOfWeek: 'Monday',
    time: '08:00',
  });

  useEffect(() => {
    async function loadData() {
      const [classroomsRes, subjectsRes, teachersRes] = await Promise.all([
        getClassrooms(1, 100),
        getSubjects(),
        getTeachers(1, 200),
      ]);

      setClassrooms(toItems(classroomsRes));
      setSubjects(toItems(subjectsRes));
      setTeachers(toItems(teachersRes));
    }

    loadData();
  }, []);

  async function handleSearch(event) {
    event?.preventDefault();
    if (!classroomId) return;

    setLoading(true);
    setError('');
    const result = await getClassroomSchedule(classroomId);

    if (result) setSchedules(toItems(result));
    else setError('Failed to load schedule entries.');

    setLoading(false);
  }

  async function handleCreateSchedule(event) {
    event.preventDefault();
    setSaving(true);
    setError('');

    try {
      const response = await createSchedule(scheduleForm);
      if (response?.ok) {
        setShowForm(false);
        setScheduleForm({ classroomId: '', subjectId: '', teacherId: '', dayOfWeek: 'Monday', time: '08:00' });
        if (classroomId) handleSearch();
      } else {
        const data = await response.json().catch(() => ({}));
        setError(data?.message ?? data?.error ?? 'Failed to create schedule entry.');
      }
    } finally {
      setSaving(false);
    }
  }

  async function handleDeleteSchedule(id) {
    if (!confirm('Delete this schedule entry?')) return;

    setError('');
    const response = await deleteSchedule(id);
    if (response?.ok) {
      setSchedules((current) => current.filter((item) => item.id !== id));
    } else {
      setError('Failed to delete schedule entry.');
    }
  }

  const byDay = DAYS.reduce((acc, day) => {
    acc[day] = schedules.filter(
      (item) => item.dayOfWeekName === day || item.dayOfWeek === DAYS.indexOf(day) + 1 || item.dayOfWeek === day,
    );
    return acc;
  }, {});

  return (
    <div className="admin-page">
      <div className="admin-header">
        <div className="admin-header-main">
          <div className="admin-header-icon">
            <CalendarDays className="h-5 w-5" />
          </div>
          <div>
            <h1 className="admin-title">Schedules</h1>
            <p className="admin-subtitle">Manage the weekly schedule using the current backend contract.</p>
          </div>
        </div>

        <button type="button" onClick={() => setShowForm((value) => !value)} className="admin-btn-primary">
          {showForm ? <X className="h-4 w-4" /> : <Plus className="h-4 w-4" />}
          {showForm ? 'Cancel' : 'Add Schedule'}
        </button>
      </div>

      {showForm && (
        <form onSubmit={handleCreateSchedule} className="admin-section">
          <h2 className="mb-4 text-base font-semibold text-slate-900">New Schedule Entry</h2>
          <div className="grid grid-cols-1 gap-4 sm:grid-cols-2 lg:grid-cols-3">
            <div>
              <label className="mb-1.5 block text-xs font-semibold uppercase tracking-[0.16em] text-slate-500">Classroom</label>
              <select
                required
                value={scheduleForm.classroomId}
                onChange={(event) => setScheduleForm((form) => ({ ...form, classroomId: event.target.value }))}
                className="admin-input"
              >
                <option value="">Select classroom</option>
                {classrooms.map((classroom) => (
                  <option key={classroom.id} value={classroom.id}>
                    {classroom.className ?? classroom.name}
                  </option>
                ))}
              </select>
            </div>

            <div>
              <label className="mb-1.5 block text-xs font-semibold uppercase tracking-[0.16em] text-slate-500">Subject</label>
              <select
                required
                value={scheduleForm.subjectId}
                onChange={(event) => setScheduleForm((form) => ({ ...form, subjectId: event.target.value }))}
                className="admin-input"
              >
                <option value="">Select subject</option>
                {subjects.map((subject) => (
                  <option key={subject.id} value={subject.id}>
                    {subject.subjectName}
                  </option>
                ))}
              </select>
            </div>

            <div>
              <label className="mb-1.5 block text-xs font-semibold uppercase tracking-[0.16em] text-slate-500">Teacher</label>
              <select
                required
                value={scheduleForm.teacherId}
                onChange={(event) => setScheduleForm((form) => ({ ...form, teacherId: event.target.value }))}
                className="admin-input"
              >
                <option value="">Select teacher</option>
                {teachers.map((teacher) => (
                  <option key={teacher.id} value={teacher.id}>
                    {teacher.firstName} {teacher.lastName}
                  </option>
                ))}
              </select>
            </div>

            <div>
              <label className="mb-1.5 block text-xs font-semibold uppercase tracking-[0.16em] text-slate-500">Day</label>
              <select
                required
                value={scheduleForm.dayOfWeek}
                onChange={(event) => setScheduleForm((form) => ({ ...form, dayOfWeek: event.target.value }))}
                className="admin-input"
              >
                {DAYS.map((day) => (
                  <option key={day} value={day}>
                    {day}
                  </option>
                ))}
              </select>
            </div>

            <div>
              <label className="mb-1.5 block text-xs font-semibold uppercase tracking-[0.16em] text-slate-500">Start Time</label>
              <input
                type="time"
                required
                value={scheduleForm.time}
                onChange={(event) => setScheduleForm((form) => ({ ...form, time: event.target.value }))}
                className="admin-input"
              />
            </div>
          </div>

          <div className="mt-4">
            <button type="submit" disabled={saving} className="admin-btn-primary disabled:opacity-50">
              {saving ? <span className="h-4 w-4 animate-spin rounded-full border-2 border-white border-t-transparent" /> : <Plus className="h-4 w-4" />}
              {saving ? 'Saving...' : 'Create Entry'}
            </button>
          </div>
        </form>
      )}

      <form onSubmit={handleSearch} className="admin-section">
        <div className="flex flex-wrap items-end gap-4">
          <div className="min-w-[220px] flex-1">
            <label className="mb-1.5 block text-xs font-semibold uppercase tracking-[0.16em] text-slate-500">Classroom</label>
            <select value={classroomId} onChange={(event) => setClassroomId(event.target.value)} required className="admin-input">
              <option value="">Select a classroom</option>
              {classrooms.map((classroom) => (
                <option key={classroom.id} value={classroom.id}>
                  {classroom.className ?? classroom.name}
                </option>
              ))}
            </select>
          </div>

          <button type="submit" disabled={!classroomId} className="admin-btn-primary disabled:cursor-not-allowed disabled:opacity-50">
            <Search className="h-4 w-4" />
            Load Schedule
          </button>
        </div>
      </form>

      {error && (
        <div className="flex items-center gap-3 rounded-xl border border-red-100 bg-red-50 p-4 text-sm text-red-700">
          <AlertCircle className="h-5 w-5 shrink-0" />
          {error}
        </div>
      )}

      {loading ? (
        <div className="admin-section text-center">
          <div className="mx-auto mb-3 h-8 w-8 animate-spin rounded-full border-2 border-slate-400 border-t-transparent" />
          <p className="text-sm text-slate-500">Loading schedule…</p>
        </div>
      ) : schedules.length === 0 ? (
        <div className="admin-section text-center">
          <CalendarDays className="mx-auto mb-3 h-12 w-12 text-slate-300" />
          <p className="text-sm text-slate-500">
            {classroomId ? 'No schedule entries for this classroom.' : 'Select a classroom to view its schedule.'}
          </p>
        </div>
      ) : (
        <div className="space-y-4">
          {DAYS.map((day) => {
            const items = byDay[day];
            if (items.length === 0) return null;

            return (
              <div key={day} className="admin-card overflow-hidden">
                <div className="border-b border-slate-200 bg-slate-900 px-5 py-3">
                  <span className="text-sm font-semibold text-white">{day}</span>
                  <span className="ml-2 text-xs text-white/70">({items.length} {items.length === 1 ? 'class' : 'classes'})</span>
                </div>

                <div className="divide-y divide-slate-50">
                  {items.map((item) => (
                    <div key={item.id} className="flex items-center gap-4 px-5 py-4 transition-colors hover:bg-slate-50/50">
                      <div className="flex min-w-[150px] items-center gap-2">
                        <Clock className="h-4 w-4 text-slate-400" />
                        <span className="font-medium text-slate-900">{formatTimeRange(item)}</span>
                      </div>

                      <div className="flex flex-1 items-center gap-2">
                        <BookOpen className="h-4 w-4 text-slate-500" />
                        <span className="text-slate-700">{item.subjectName ?? item.subjectId ?? '—'}</span>
                      </div>

                      <div className="flex flex-1 items-center gap-2">
                        <User className="h-4 w-4 text-slate-500" />
                        <span className="text-slate-600">{item.teacherName ?? item.teacherId ?? '—'}</span>
                      </div>

                      <div className="flex items-center gap-2">
                        <School className="h-4 w-4 text-slate-500" />
                        <span className="text-slate-500">{item.classroomName ?? item.classroomId ?? '—'}</span>
                      </div>

                      <button
                        type="button"
                        onClick={() => handleDeleteSchedule(item.id)}
                        className="ml-2 text-slate-300 transition-colors hover:text-red-500"
                        title="Delete entry"
                      >
                        <Trash2 className="h-4 w-4" />
                      </button>
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
