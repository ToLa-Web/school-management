'use client';
import { useEffect, useState } from 'react';
import { useRouter } from 'next/navigation';
import Link from 'next/link';
import { useAuth } from '@/lib/auth';
import { createClassroom, getTeachers, getStudents, enrollStudent, getRooms, getSubjects } from '@/lib/api';
import {
  School, ArrowLeft, AlertCircle, Save, Bookmark, User,
  Users, Search, Check, Loader2, Home, BookOpen,
} from 'lucide-react';

const inputCls = 'admin-input';

export default function NewClassroomPage() {
  useAuth();
  const router = useRouter();

  const [form, setForm] = useState({ name: '', grade: '', academicYear: '', semester: '', roomId: '', teacherId: '', subjectId: '' });
  const [rooms, setRooms] = useState([]);
  const [teachers, setTeachers] = useState([]);
  const [subjects, setSubjects] = useState([]);
  const [students, setStudents] = useState([]);
  const [selectedIds, setSelectedIds] = useState(new Set());
  const [search, setSearch] = useState('');
  const [error, setError] = useState('');
  const [saving, setSaving] = useState(false);
  const [loadingStudents, setLoadingStudents] = useState(true);

  useEffect(() => {
    getRooms().then((data) => setRooms(data?.items ?? data ?? []));
    getTeachers(1, 100).then((data) => setTeachers(data?.items ?? data ?? []));
    getSubjects().then((data) => setSubjects(data?.items ?? data ?? []));
    getStudents(1, 500).then((data) => {
      setStudents(data?.items ?? data ?? []);
      setLoadingStudents(false);
    });
  }, []);

  function set(field, value) { setForm((prev) => ({ ...prev, [field]: value })); }

  function toggleStudent(id) {
    setSelectedIds((prev) => {
      const next = new Set(prev);
      if (next.has(id)) next.delete(id); else next.add(id);
      return next;
    });
  }

  function toggleAll() {
    const visible = filtered.map((s) => s.id);
    const allSelected = visible.every((id) => selectedIds.has(id));
    setSelectedIds((prev) => {
      const next = new Set(prev);
      if (allSelected) visible.forEach((id) => next.delete(id));
      else visible.forEach((id) => next.add(id));
      return next;
    });
  }

  const filtered = students.filter((s) => {
    const name = `${s.firstName ?? ''} ${s.lastName ?? ''} ${s.fullName ?? ''}`.toLowerCase();
    return name.includes(search.toLowerCase());
  });

  async function handleSubmit(e) {
    e.preventDefault();
    setError('');
    setSaving(true);
    try {
      const payload = {
        name: form.name,
        grade: form.grade || null,
        academicYear: form.academicYear || null,
        semester: form.semester || null,
        roomId: form.roomId || null,
        teacherId: form.teacherId || null,
        subjectId: form.subjectId || null,
      };
      const res = await createClassroom(payload);
      if (!res?.ok) {
        const data = await res.json().catch(() => ({}));
        setError(data?.details ?? data?.message ?? data?.error ?? 'Failed to create classroom.');
        return;
      }
      const created = await res.json().catch(() => null);
      const classroomId = created?.id ?? created?.classroom?.id;
      if (classroomId && selectedIds.size > 0) {
        await Promise.all([...selectedIds].map((studentId) => enrollStudent(classroomId, studentId)));
      }
      router.push('/admin/classrooms');
    } finally {
      setSaving(false);
    }
  }

  const visibleAllSelected = filtered.length > 0 && filtered.every((s) => selectedIds.has(s.id));

  return (
    <div className="max-w-2xl admin-page">
      {/* Header */}
      <div className="flex items-center gap-3 mb-6">
        <Link href="/admin/classrooms" className="p-2 text-slate-400 hover:text-slate-600 hover:bg-slate-100 rounded-lg transition-colors">
          <ArrowLeft className="w-5 h-5" />
        </Link>
        <div className="admin-header-icon">
          <School className="w-5 h-5 text-white" />
        </div>
        <div>
          <h1 className="text-2xl font-bold text-slate-900">New Classroom</h1>
          <p className="text-sm text-slate-500">Create a new classroom</p>
        </div>
      </div>

      {error && (
        <div className="flex items-center gap-3 bg-red-50 border border-red-100 text-red-700 text-sm rounded-xl p-4 mb-4">
          <AlertCircle className="w-5 h-5 shrink-0" />
          {error}
        </div>
      )}

      <form onSubmit={handleSubmit} className="space-y-5">
        {/* Basic info card */}
        <div className="admin-section space-y-5">
          <div>
            <label className="flex items-center gap-1.5 text-sm font-semibold text-slate-700 mb-1.5">
              <School className="w-4 h-4 text-slate-400" />
              Class Name <span className="text-red-500">*</span>
            </label>
            <input
              type="text" required
              value={form.name}
              onChange={(e) => set('name', e.target.value)}
              placeholder="e.g. Class A"
              className={inputCls}
            />
          </div>

          <div>
            <label className="flex items-center gap-1.5 text-sm font-semibold text-slate-700 mb-1.5">
              <BookOpen className="w-4 h-4 text-slate-400" />
              Subject <span className="text-red-500">*</span>
            </label>
            <select
              required
              value={form.subjectId}
              onChange={(e) => set('subjectId', e.target.value)}
              className={inputCls}
            >
              <option value="">Select Subject</option>
              {subjects.map((s) => (
                <option key={s.id} value={s.id}>{s.subjectName}</option>
              ))}
            </select>
          </div>

          <div>
            <label className="flex items-center gap-1.5 text-sm font-semibold text-slate-700 mb-1.5">
              <Bookmark className="w-4 h-4 text-slate-400" />
              Grade
            </label>
            <input
              type="text"
              value={form.grade}
              onChange={(e) => set('grade', e.target.value)}
              placeholder="e.g. Grade 10"
              className={inputCls}
            />
          </div>

          <div>
            <label className="flex items-center gap-1.5 text-sm font-semibold text-slate-700 mb-1.5">
              <Bookmark className="w-4 h-4 text-slate-400" />
              Academic Year
            </label>
            <input
              type="text"
              value={form.academicYear}
              onChange={(e) => set('academicYear', e.target.value)}
              placeholder="e.g. 2024-2025"
              className={inputCls}
            />
          </div>

          <div>
            <label className="flex items-center gap-1.5 text-sm font-semibold text-slate-700 mb-1.5">
              <Bookmark className="w-4 h-4 text-slate-400" />
              Semester
            </label>
            <select
              value={form.semester}
              onChange={(e) => set('semester', e.target.value)}
              className={inputCls}
            >
              <option value="">Select semester</option>
              <option value="Spring">Spring</option>
              <option value="Fall">Fall</option>
              <option value="Summer">Summer</option>
              <option value="Winter">Winter</option>
            </select>
          </div>

          <div>
            <label className="flex items-center gap-1.5 text-sm font-semibold text-slate-700 mb-1.5">
              <Home className="w-4 h-4 text-slate-400" />
              Room
            </label>
            <select
              value={form.roomId}
              onChange={(e) => set('roomId', e.target.value)}
              className={inputCls}
            >
              <option value="">No room assigned</option>
              {rooms.map((r) => (
                <option key={r.id} value={r.id}>{r.name} {r.location && `(${r.location})`}</option>
              ))}
            </select>
          </div>

          <div>
            <label className="flex items-center gap-1.5 text-sm font-semibold text-slate-700 mb-1.5">
              <User className="w-4 h-4 text-slate-400" />
              Assign Teacher
            </label>
            <select
              value={form.teacherId}
              onChange={(e) => set('teacherId', e.target.value)}
              className={inputCls}
            >
              <option value="">No teacher yet</option>
              {teachers.map((t) => (
                <option key={t.id} value={t.id}>{t.firstName} {t.lastName}</option>
              ))}
            </select>
          </div>
        </div>

        {/* Student picker card */}
        <div className="admin-card overflow-hidden">
          {/* Card header */}
          <div className="flex items-center justify-between px-5 py-4 border-b border-slate-100">
            <div className="flex items-center gap-2">
              <Users className="w-4 h-4 text-emerald-500" />
              <span className="text-sm font-semibold text-slate-700">Add Students</span>
              {selectedIds.size > 0 && (
                    <span className="rounded-full bg-slate-900 px-2 py-0.5 text-xs font-bold text-white">
                  {selectedIds.size} selected
                </span>
              )}
            </div>
            {filtered.length > 0 && (
              <button
                type="button"
                onClick={toggleAll}
                className="text-xs font-medium text-slate-700 hover:text-slate-900 transition-colors"
              >
                {visibleAllSelected ? 'Deselect all' : 'Select all'}
              </button>
            )}
          </div>

          {/* Search box */}
          <div className="px-4 py-3 border-b border-slate-50">
              <div className="flex items-center gap-2 rounded-xl bg-slate-50 px-3 py-2">
              <Search className="w-4 h-4 text-slate-400 shrink-0" />
              <input
                type="text"
                placeholder="Search students..."
                value={search}
                onChange={(e) => setSearch(e.target.value)}
                className="bg-transparent text-sm flex-1 outline-none placeholder:text-slate-400"
              />
            </div>
          </div>

          {/* List */}
          {loadingStudents ? (
            <div className="flex items-center justify-center gap-2 py-10 text-slate-400 text-sm">
              <Loader2 className="w-4 h-4 animate-spin" />
              Loading students...
            </div>
          ) : filtered.length === 0 ? (
            <div className="py-10 text-center text-slate-400 text-sm">
              {search ? 'No students match your search.' : 'No students found. Create students first.'}
            </div>
          ) : (
            <div className="divide-y divide-slate-50 max-h-96 overflow-y-auto">
              {filtered.map((s) => {
                const name = (s.fullName ?? `${s.firstName ?? ''} ${s.lastName ?? ''}`.trim()) || 'Unnamed Student';
                const initials = ((s.firstName?.[0] ?? '') + (s.lastName?.[0] ?? '')).toUpperCase() || name[0]?.toUpperCase() || '?';
                const selected = selectedIds.has(s.id);
                return (
                  <label key={s.id} onClick={() => toggleStudent(s.id)} className={`flex items-center gap-3 px-5 py-3 cursor-pointer transition-colors ${selected ? 'bg-slate-100' : 'hover:bg-slate-50'}`}>
                    <div className="w-8 h-8 rounded-full bg-slate-900 flex items-center justify-center text-white text-xs font-bold shrink-0">
                      {initials}
                    </div>
                    <div className="flex-1 min-w-0">
                      <p className="text-sm font-medium text-slate-800 truncate">{name}</p>
                      {s.gender && <p className="text-xs text-slate-400">{s.gender}</p>}
                    </div>
                    <div className={`w-5 h-5 rounded-md border-2 flex items-center justify-center shrink-0 transition-all ${selected ? 'bg-slate-900 border-slate-900' : 'border-slate-300'}`}>
                      {selected && <Check className="w-3 h-3 text-white" strokeWidth={3} />}
                    </div>
                  </label>
                );
              })}
            </div>
          )}
        </div>

        {/* Actions */}
        <div className="flex gap-3 pb-8">
          <button
            type="submit"
            disabled={saving}
            className="admin-btn-primary disabled:opacity-50"
          >
            {saving ? <Loader2 className="w-4 h-4 animate-spin" /> : <Save className="w-4 h-4" />}
            {saving ? 'Saving...' : 'Create Classroom'}
          </button>
          <button
            type="button"
            onClick={() => router.push('/admin/classrooms')}
            className="text-slate-600 hover:text-slate-800 text-sm font-medium px-5 py-2.5 rounded-xl border border-slate-200 hover:bg-slate-50 transition-colors"
          >
            Cancel
          </button>
        </div>
      </form>
    </div>
  );
}

