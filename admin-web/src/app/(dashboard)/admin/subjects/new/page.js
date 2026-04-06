'use client';
import { useState } from 'react';
import { useRouter } from 'next/navigation';
import Link from 'next/link';
import { useAuth } from '@/lib/auth';
import { createSubject } from '@/lib/api';
import { BookOpen, ArrowLeft, AlertCircle, Save } from 'lucide-react';

export default function NewSubjectPage() {
  useAuth();

  const router = useRouter();
  const [subjectName, setSubjectName] = useState('');
  const [yearLevel, setYearLevel] = useState('');
  const [category, setCategory] = useState('');
  const [department, setDepartment] = useState('');
  const [description, setDescription] = useState('');
  const [code, setCode] = useState('');
  const [error, setError] = useState('');
  const [saving, setSaving] = useState(false);

  async function handleSubmit(e) {
    e.preventDefault();
    if (!subjectName.trim()) return;
    setError('');
    setSaving(true);
    try {
      const res = await createSubject({
        subjectName: subjectName.trim(),
        yearLevel: yearLevel ? parseInt(yearLevel) : 0,
        category: category || null,
        department: department || null,
        description: description || null,
        code: code || null
      });
      if (res?.ok) {
        router.push('/admin/subjects');
      } else {
        const data = await res.json().catch(() => ({}));
        setError(data?.message ?? data?.error ?? 'Failed to create subject.');
      }
    } finally {
      setSaving(false);
    }
  }

  return (
    <div className="max-w-lg admin-page">
      {/* Header */}
      <div className="flex items-center gap-3 mb-6">
        <Link
          href="/admin/subjects"
          className="p-2 text-slate-400 hover:text-slate-600 hover:bg-slate-100 rounded-lg transition-colors"
        >
          <ArrowLeft className="w-5 h-5" />
        </Link>
        <div className="admin-header-icon">
          <BookOpen className="w-5 h-5 text-white" />
        </div>
        <div>
          <h1 className="text-2xl font-bold text-slate-900">New Subject</h1>
          <p className="text-sm text-slate-500">Add a new subject to the curriculum</p>
        </div>
      </div>

      {error && (
        <div className="flex items-center gap-3 bg-red-50 border border-red-100 text-red-700 text-sm rounded-xl p-4 mb-4">
          <AlertCircle className="w-5 h-5 shrink-0" />
          {error}
        </div>
      )}

      <form onSubmit={handleSubmit} className="admin-section space-y-5">
        <div>
          <label className="flex items-center gap-1.5 text-sm font-semibold text-slate-700 mb-1.5">
            <BookOpen className="w-4 h-4 text-slate-400" />
            Subject Name <span className="text-red-500">*</span>
          </label>
          <input
            type="text"
            required
            value={subjectName}
            onChange={(e) => setSubjectName(e.target.value)}
            placeholder="e.g. Mathematics"
            className="admin-input"
          />
        </div>
        <div>
          <label className="text-sm font-semibold text-slate-700 mb-1.5">Department</label>
          <select
            value={department}
            onChange={e => setDepartment(e.target.value)}
            className="admin-input"
          >
            <option value="">Select Department</option>
            <option value="Computer Science">Computer Science</option>
            <option value="Mathematics">Mathematics</option>
            <option value="Physics">Physics</option>
            <option value="Chemistry">Chemistry</option>
            <option value="Biology">Biology</option>
          </select>
        </div>
        <div>
          <label className="text-sm font-semibold text-slate-700 mb-1.5">Year Level</label>
          <select
            value={yearLevel}
            onChange={e => setYearLevel(e.target.value)}
            className="admin-input"
          >
            <option value="">Select Year</option>
            <option value="1">1</option>
            <option value="2">2</option>
            <option value="3">3</option>
            <option value="4">4</option>
            <option value="5">5 (Capstone)</option>
          </select>
        </div>
        <div>
          <label className="text-sm font-semibold text-slate-700 mb-1.5">Category</label>
          <select
            value={category}
            onChange={e => setCategory(e.target.value)}
            className="admin-input"
          >
            <option value="">Select Category</option>
            <option value="Foundations">Foundations</option>
            <option value="Core CS">Core CS</option>
            <option value="Advanced">Advanced</option>
            <option value="Electives">Electives</option>
          </select>
        </div>
        <div>
          <label className="text-sm font-semibold text-slate-700 mb-1.5">Description/Topics</label>
          <textarea
            value={description}
            onChange={e => setDescription(e.target.value)}
            placeholder="e.g. Sorting, complexity"
            className="admin-input min-h-28"
          />
        </div>
        <div>
          <label className="text-sm font-semibold text-slate-700 mb-1.5">Subject Code</label>
          <input
            type="text"
            value={code}
            onChange={e => setCode(e.target.value)}
            placeholder="e.g. CS101"
            className="admin-input"
          />
        </div>

        <div className="flex gap-3 pt-3">
          <button
            type="submit"
            disabled={saving}
            className="admin-btn-primary disabled:opacity-50"
          >
            {saving ? (
              <div className="w-4 h-4 border-2 border-white border-t-transparent rounded-full animate-spin" />
            ) : (
              <Save className="w-4 h-4" />
            )}
            {saving ? 'Saving...' : 'Create Subject'}
          </button>
          <button
            type="button"
            onClick={() => router.push('/admin/subjects')}
            className="text-slate-600 hover:text-slate-800 text-sm font-medium px-5 py-2.5 rounded-xl border border-slate-200 hover:bg-slate-50 transition-colors"
          >
            Cancel
          </button>
        </div>
      </form>
    </div>
  );
}
