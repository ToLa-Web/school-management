'use client';
import { useEffect, useState } from 'react';
import { useAuth } from '@/lib/auth';
import { getGrades, createGrade, deleteGrade, getStudents, getSubjects } from '@/lib/api';
import { BarChart3, Search, AlertCircle, Award, TrendingUp, TrendingDown, Plus, Trash2, X } from 'lucide-react';

export default function GradesPage() {
  useAuth([1]);

  const [grades, setGrades] = useState([]);
  const [students, setStudents] = useState([]);
  const [subjects, setSubjects] = useState([]);
  const [subjectId, setSubjectId] = useState('');
  const [semester, setSemester] = useState('');
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');
  const [showForm, setShowForm] = useState(false);
  const [saving, setSaving] = useState(false);
  const [gradeForm, setGradeForm] = useState({ studentId: '', subjectId: '', semester: '1', score: '' });

  useEffect(() => {
    async function loadFilters() {
      const [stu, s] = await Promise.all([getStudents(1, 200), getSubjects()]);
      setStudents(stu?.items ?? stu ?? []);
      setSubjects(Array.isArray(s) ? s : s?.items ?? []);
    }
    loadFilters();
  }, []);

  async function handleSearch(e) {
    e?.preventDefault();
    setLoading(true);
    setError('');
    const data = await getGrades({
      subjectId: subjectId || undefined,
      semester: semester || undefined,
    });
    if (data) {
      setGrades(Array.isArray(data) ? data : data.items ?? []);
    } else {
      setError('Failed to load grades.');
    }
    setLoading(false);
  }

  async function handleCreateGrade(e) {
    e.preventDefault();
    setSaving(true);
    setError('');
    try {
      const res = await createGrade({
        studentId: gradeForm.studentId,
        subjectId: gradeForm.subjectId,
        semester: parseInt(gradeForm.semester),
        score: parseFloat(gradeForm.score),
      });
      if (res?.ok) {
        setShowForm(false);
        setGradeForm({ studentId: '', subjectId: '', semester: '1', score: '' });
        handleSearch();
      } else {
        const data = await res.json().catch(() => ({}));
        setError(data?.message ?? data?.error ?? 'Failed to create grade.');
      }
    } finally {
      setSaving(false);
    }
  }

  async function handleDelete(id) {
    if (!confirm('Delete this grade record? This cannot be undone.')) return;
    const res = await deleteGrade(id);
    if (res?.ok) {
      setGrades((prev) => prev.filter((g) => g.id !== id));
    } else {
      setError('Failed to delete grade.');
    }
  }

  function gradeLabel(score) {
    if (score === undefined || score === null) return '—';
    if (score >= 90) return 'A';
    if (score >= 80) return 'B';
    if (score >= 70) return 'C';
    if (score >= 60) return 'D';
    return 'F';
  }

  function gradeColor(score) {
    if (score >= 90) return 'bg-emerald-100 text-emerald-700';
    if (score >= 80) return 'bg-blue-100 text-blue-700';
    if (score >= 70) return 'bg-amber-100 text-amber-700';
    if (score >= 60) return 'bg-orange-100 text-orange-700';
    return 'bg-red-100 text-red-700';
  }

  const selectCls = 'w-full border border-slate-200 rounded-xl px-3 py-2.5 text-sm focus:outline-none focus:ring-2 focus:ring-violet-500 focus:border-transparent bg-slate-50';

  return (
    <div className="p-8 max-w-7xl mx-auto relative min-h-full">
      {/* Decorative background blobs */}
      <div className="absolute top-0 left-0 w-full h-full overflow-hidden -z-10 pointer-events-none">
        <div className="absolute top-[-10%] right-[-5%] w-96 h-96 bg-violet-400/10 rounded-full blur-3xl animate-pulse" />
        <div className="absolute bottom-[-10%] left-[-5%] w-96 h-96 bg-fuchsia-400/10 rounded-full blur-3xl animate-pulse delay-700" />
      </div>

      {/* Header */}
      <div className="flex items-center justify-between mb-6">
        <div className="flex items-center gap-3">
          <div className="w-10 h-10 rounded-xl bg-[#526d82] flex items-center justify-center">
            <BarChart3 className="w-5 h-5 text-white" />
          </div>
          <div>
            <h1 className="text-2xl font-bold text-slate-900">Grades</h1>
            <p className="text-sm text-slate-500">View and manage student grades</p>
          </div>
        </div>
        <button
          onClick={() => setShowForm(!showForm)}
          className="bg-[#526d82] hover:bg-[#27374d] text-white text-sm font-bold px-5 py-3 rounded-2xl shadow-lg shadow-slate-500/20 hover:-translate-y-0.5 transition-all duration-300 flex items-center gap-2"
        >
          {showForm ? <X className="w-5 h-5" /> : <Plus className="w-5 h-5" />}
          {showForm ? 'Cancel' : 'Add Grade'}
        </button>
      </div>

      {/* Add Grade Form */}
      {showForm && (
        <form onSubmit={handleCreateGrade} className="bg-white/80 backdrop-blur-xl rounded-3xl border border-white/60 shadow-2xl shadow-slate-200/50 p-8 mb-8 animate-[fadeIn_0.3s_ease-out]">
          <h3 className="text-lg font-bold text-slate-800 mb-6 flex items-center gap-2"><BarChart3 className="text-violet-500 w-5 h-5"/> Record New Grade</h3>
          <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
            <div>
              <label className="block text-xs font-semibold text-slate-600 mb-1.5">Student *</label>
              <select required value={gradeForm.studentId} onChange={(e) => setGradeForm(f => ({ ...f, studentId: e.target.value }))} className={selectCls}>
                <option value="">Select student...</option>
                {students.map((s) => (
                  <option key={s.id} value={s.id}>{s.firstName} {s.lastName}</option>
                ))}
              </select>
            </div>
            <div>
              <label className="block text-xs font-semibold text-slate-600 mb-1.5">Subject *</label>
              <select required value={gradeForm.subjectId} onChange={(e) => setGradeForm(f => ({ ...f, subjectId: e.target.value }))} className={selectCls}>
                <option value="">Select subject...</option>
                {subjects.map((s) => (
                  <option key={s.id} value={s.id}>{s.subjectName}</option>
                ))}
              </select>
            </div>
            <div>
              <label className="block text-xs font-semibold text-slate-600 mb-1.5">Semester *</label>
              <select required value={gradeForm.semester} onChange={(e) => setGradeForm(f => ({ ...f, semester: e.target.value }))} className={selectCls}>
                <option value="1">Semester 1</option>
                <option value="2">Semester 2</option>
              </select>
            </div>
            <div>
              <label className="block text-xs font-semibold text-slate-600 mb-1.5">Score *</label>
              <input type="number" required min="0" max="100" step="0.1" value={gradeForm.score}
                onChange={(e) => setGradeForm(f => ({ ...f, score: e.target.value }))}
                placeholder="0-100"
                className={selectCls} />
            </div>
          </div>
          <div className="mt-4">
            <button type="submit" disabled={saving}
              className="bg-[#526d82] hover:bg-[#27374d] disabled:opacity-50 text-white text-sm font-bold px-6 py-3 rounded-2xl shadow-lg shadow-slate-500/20 hover:-translate-y-0.5 transition-all duration-300 flex items-center gap-2">
              {saving ? (
                <div className="w-5 h-5 border-2 border-white border-t-transparent rounded-full animate-spin" />
              ) : (
                <Plus className="w-5 h-5" />
              )}
              {saving ? 'Saving...' : 'Save Grade'}
            </button>
          </div>
        </form>
      )}

      {/* Filters */}
      <form
        onSubmit={handleSearch}
        className="bg-white/80 backdrop-blur-xl rounded-3xl border border-white/60 shadow-xl shadow-slate-200/50 p-6 mb-8"
      >
        <div className="flex flex-wrap gap-4 items-end">
          <div className="flex-1 min-w-[180px]">
            <label className="block text-xs font-semibold text-slate-600 mb-1.5">Subject</label>
            <select value={subjectId} onChange={(e) => setSubjectId(e.target.value)} className={selectCls}>
              <option value="">All Subjects</option>
              {subjects.map((s) => (
                <option key={s.id} value={s.id}>{s.subjectName}</option>
              ))}
            </select>
          </div>

          <div className="flex-1 min-w-[160px]">
            <label className="block text-xs font-semibold text-slate-600 mb-1.5">Semester</label>
            <select value={semester} onChange={(e) => setSemester(e.target.value)} className={selectCls}>
              <option value="">All Semesters</option>
              <option value="1">Semester 1</option>
              <option value="2">Semester 2</option>
            </select>
          </div>

          <button
            type="submit"
            className="bg-[#526d82] hover:bg-[#27374d] text-white text-sm font-bold px-8 py-2.5 rounded-xl shadow-lg shadow-slate-500/20 hover:-translate-y-0.5 transition-all duration-300 flex items-center gap-2 h-[42px]"
          >
            <Search className="w-4 h-4" />
            Search
          </button>
        </div>
      </form>

      {error && (
        <div className="flex items-center gap-3 bg-red-50 border border-red-100 text-red-700 text-sm rounded-xl p-4 mb-4">
          <AlertCircle className="w-5 h-5 shrink-0" />
          {error}
          <button onClick={() => setError('')} className="ml-auto text-red-400 hover:text-red-600"><X className="w-4 h-4" /></button>
        </div>
      )}

      {loading ? (
        <div className="bg-white/60 backdrop-blur-md rounded-3xl border border-white/50 p-16 text-center shadow-xl shadow-slate-200/30">
          <div className="w-10 h-10 border-4 border-violet-500 border-t-transparent rounded-full animate-spin mx-auto mb-4 shadow-sm" />
          <p className="text-slate-600 font-medium tracking-wide">Fetching grade records...</p>
        </div>
      ) : grades.length === 0 ? (
        <div className="bg-white/60 backdrop-blur-md rounded-3xl border border-white/50 p-16 text-center shadow-xl shadow-slate-200/30">
          <div className="w-20 h-20 bg-violet-50 rounded-full flex items-center justify-center mx-auto mb-4 border border-violet-100 shadow-inner">
             <BarChart3 className="w-10 h-10 text-violet-400" />
          </div>
          <h3 className="text-lg font-bold text-slate-800 mb-1">No Records Found</h3>
          <p className="text-slate-500 text-sm max-w-sm mx-auto">Use the filters above and click Search to load grades history.</p>
        </div>
      ) : (
        <div className="bg-white/80 backdrop-blur-xl rounded-3xl border border-white/60 shadow-xl shadow-slate-200/50 overflow-hidden">
          <table className="w-full text-sm">
            <thead className="bg-slate-50 border-b border-slate-100">
              <tr>
                <th className="text-left px-5 py-4 font-semibold text-slate-600">Student</th>
                <th className="text-left px-5 py-4 font-semibold text-slate-600">Subject</th>
                <th className="text-left px-5 py-4 font-semibold text-slate-600">Semester</th>
                <th className="text-left px-5 py-4 font-semibold text-slate-600">Score</th>
                <th className="text-left px-5 py-4 font-semibold text-slate-600">Grade</th>
                <th className="text-left px-5 py-4 font-semibold text-slate-600">Recorded</th>
                <th className="px-5 py-4 w-16"></th>
              </tr>
            </thead>
            <tbody className="divide-y divide-slate-50">
              {grades.map((g) => (
                <tr key={g.id} className="hover:bg-slate-50/50 transition-colors">
                  <td className="px-5 py-4">
                    <div className="flex items-center gap-3">
                      <div className="w-8 h-8 rounded-full bg-[#526d82] flex items-center justify-center text-white font-semibold text-xs">
                        {(g.studentName ?? 'S')[0]}
                      </div>
                      <span className="font-medium text-slate-900">{g.studentName ?? g.studentId}</span>
                    </div>
                  </td>
                  <td className="px-5 py-4 text-slate-600">{g.subjectName ?? g.subjectId}</td>
                  <td className="px-5 py-4">
                    <span className="px-2.5 py-1 rounded-full text-xs font-medium bg-slate-100 text-slate-600">
                      {g.semester ? `Semester ${g.semester}` : '—'}
                    </span>
                  </td>
                  <td className="px-5 py-4">
                    <div className="flex items-center gap-1.5">
                      <span className="font-bold text-slate-900">{g.score !== undefined ? g.score : '—'}</span>
                      {g.score !== undefined && (
                        g.score >= 70 ? <TrendingUp className="w-4 h-4 text-emerald-500" /> : <TrendingDown className="w-4 h-4 text-red-500" />
                      )}
                    </div>
                  </td>
                  <td className="px-5 py-4">
                    <span className={`inline-flex items-center gap-1 px-2.5 py-1 rounded-full text-xs font-bold ${gradeColor(g.score)}`}>
                      <Award className="w-3.5 h-3.5" />
                      {gradeLabel(g.score)}
                    </span>
                  </td>
                  <td className="px-5 py-4 text-slate-500">
                    {g.createdAt ? new Date(g.createdAt).toLocaleDateString() : '—'}
                  </td>
                  <td className="px-5 py-4">
                    <button
                      onClick={() => handleDelete(g.id)}
                      className="p-2 text-slate-400 hover:text-red-600 hover:bg-red-50 rounded-lg transition-colors"
                      title="Delete"
                    >
                      <Trash2 className="w-4 h-4" />
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

