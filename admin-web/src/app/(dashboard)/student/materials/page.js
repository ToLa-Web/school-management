'use client';

import Link from 'next/link';
import { useEffect, useMemo, useState } from 'react';
import { BookOpen, ExternalLink, FileText, FolderArchive, Link2, Search } from 'lucide-react';
import { useAuth } from '@/lib/auth';
import StudentEmptyState from '@/components/StudentEmptyState';
import StudentPageShell from '@/components/StudentPageShell';
import StudentSectionCard from '@/components/StudentSectionCard';
import StudentStatusBadge from '@/components/StudentStatusBadge';
import { formatDate, getMaterialTypeLabel, loadStudentBaseData, loadStudentMaterials } from '@/lib/student-portal';

function typeIcon(type) {
  const value = Number(type ?? 0);
  if (value === 3) return Link2;
  if (value === 4) return FolderArchive;
  return FileText;
}

export default function StudentMaterialsPage() {
  useAuth([2]);

  const [state, setState] = useState({
    loading: true,
    error: '',
    user: null,
    student: null,
    materials: [],
  });
  const [search, setSearch] = useState('');
  const [subjectFilter, setSubjectFilter] = useState('all');
  const [typeFilter, setTypeFilter] = useState('all');
  const [fromDate, setFromDate] = useState('');
  const [toDate, setToDate] = useState('');

  useEffect(() => {
    let active = true;

    async function load() {
      const base = await loadStudentBaseData();
      if (!active) return;

      if (!base.student) {
        setState((current) => ({ ...current, loading: false, user: base.user, error: 'Student profile not found.' }));
        return;
      }

      const materials = await loadStudentMaterials(base.classrooms);
      if (!active) return;

      setState({
        loading: false,
        error: '',
        user: base.user,
        student: base.student,
        materials,
      });
    }

    load();
    return () => {
      active = false;
    };
  }, []);

  const subjects = useMemo(() => [...new Set(state.materials.map((material) => material.subjectName).filter(Boolean))], [state.materials]);
  const filteredMaterials = useMemo(() => {
    return state.materials.filter((material) => {
      const created = new Date(material.createdAt);
      if (search && !`${material.title} ${material.subjectName} ${material.description ?? ''}`.toLowerCase().includes(search.toLowerCase())) return false;
      if (subjectFilter !== 'all' && material.subjectName !== subjectFilter) return false;
      if (typeFilter !== 'all' && getMaterialTypeLabel(material.type) !== typeFilter) return false;
      if (fromDate && created < new Date(fromDate)) return false;
      if (toDate) {
        const end = new Date(toDate);
        end.setHours(23, 59, 59, 999);
        if (created > end) return false;
      }
      return true;
    });
  }, [fromDate, search, state.materials, subjectFilter, toDate, typeFilter]);
  const grouped = useMemo(() => {
    return filteredMaterials.reduce((map, material) => {
      const key = material.subjectName || 'General';
      const group = map.get(key) ?? [];
      group.push(material);
      map.set(key, group);
      return map;
    }, new Map());
  }, [filteredMaterials]);

  if (state.loading) {
    return (
      <div className="rounded-[1.8rem] border border-slate-200/70 bg-white/85 p-12 text-center shadow-sm">
        <div className="mx-auto h-8 w-8 animate-spin rounded-full border-2 border-[#526d82] border-t-transparent" />
        <p className="mt-4 text-sm text-slate-500">Loading your materials...</p>
      </div>
    );
  }

  return (
    <StudentPageShell
      title="Materials"
      description="Search, filter, and open the course slides, references, links, and classroom resources available to you."
      breadcrumbs={[
        { label: 'Student', href: '/student/dashboard' },
        { label: 'Materials' },
      ]}
      user={state.user}
      student={state.student}
      actions={
        <Link href="/student/assignments" className="admin-btn-primary">
          <BookOpen className="h-4 w-4" />
          Open Assignments
        </Link>
      }
    >
      {state.error ? (
        <div className="rounded-2xl border border-rose-200 bg-rose-50 px-4 py-4 text-sm text-rose-700">{state.error}</div>
      ) : null}

      <StudentSectionCard icon={Search} title="Filters" subtitle="Find materials by name, subject, type, or upload date.">
        <div className="grid gap-4 md:grid-cols-2 xl:grid-cols-5">
          <label className="text-sm font-medium text-slate-700">
            Search
            <input value={search} onChange={(event) => setSearch(event.target.value)} className="admin-input mt-2" placeholder="Search materials..." />
          </label>
          <label className="text-sm font-medium text-slate-700">
            Subject
            <select value={subjectFilter} onChange={(event) => setSubjectFilter(event.target.value)} className="admin-input mt-2">
              <option value="all">All subjects</option>
              {subjects.map((subject) => (
                <option key={subject} value={subject}>
                  {subject}
                </option>
              ))}
            </select>
          </label>
          <label className="text-sm font-medium text-slate-700">
            Type
            <select value={typeFilter} onChange={(event) => setTypeFilter(event.target.value)} className="admin-input mt-2">
              <option value="all">All types</option>
              {['Slide', 'Assignment', 'Link', 'Reference'].map((label) => (
                <option key={label} value={label}>
                  {label}
                </option>
              ))}
            </select>
          </label>
          <label className="text-sm font-medium text-slate-700">
            From
            <input type="date" value={fromDate} onChange={(event) => setFromDate(event.target.value)} className="admin-input mt-2" />
          </label>
          <label className="text-sm font-medium text-slate-700">
            To
            <input type="date" value={toDate} onChange={(event) => setToDate(event.target.value)} className="admin-input mt-2" />
          </label>
        </div>
      </StudentSectionCard>

      {!filteredMaterials.length ? (
        <StudentEmptyState
          icon={BookOpen}
          title="No materials match the current filters"
          description="Try widening the search, or come back after teachers upload more classroom resources."
        />
      ) : (
        [...grouped.entries()].map(([subjectName, materials]) => (
          <StudentSectionCard
            key={subjectName}
            icon={BookOpen}
            title={subjectName}
            subtitle={`${materials.length} material${materials.length === 1 ? '' : 's'} currently visible for this subject.`}
          >
            <div className="grid gap-4 md:grid-cols-2 xl:grid-cols-3">
              {materials.map((material) => {
                const Icon = typeIcon(material.type);
                return (
                  <div key={material.id} className="rounded-[1.4rem] border border-slate-200/70 bg-white/80 p-4">
                    <div className="flex items-center justify-between gap-3">
                      <div className="flex h-11 w-11 items-center justify-center rounded-2xl bg-slate-100 text-slate-700">
                        <Icon className="h-5 w-5" />
                      </div>
                      <StudentStatusBadge label={getMaterialTypeLabel(material.type)} />
                    </div>
                    <p className="mt-4 text-sm font-semibold text-slate-900">{material.title}</p>
                    <p className="mt-2 text-sm leading-6 text-slate-600">{material.description || 'No description provided.'}</p>
                    <p className="mt-3 text-xs font-medium uppercase tracking-[0.16em] text-slate-400">{formatDate(material.createdAt)}</p>
                    <div className="mt-4 flex items-center gap-3">
                      {material.url ? (
                        <a href={material.url} target="_blank" rel="noreferrer" className="inline-flex items-center gap-2 text-sm font-semibold text-[#526d82] transition hover:text-[#27374d]">
                          <ExternalLink className="h-4 w-4" />
                          {Number(material.type) === 3 ? 'Open Link' : 'Download'}
                        </a>
                      ) : (
                        <span className="text-sm text-slate-400">No link provided</span>
                      )}
                    </div>
                  </div>
                );
              })}
            </div>
          </StudentSectionCard>
        ))
      )}
    </StudentPageShell>
  );
}
