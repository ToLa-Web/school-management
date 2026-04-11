'use client';

const TONE_CLASSES = {
  success: 'bg-emerald-100 text-emerald-700 border-emerald-200',
  warning: 'bg-amber-100 text-amber-700 border-amber-200',
  danger: 'bg-rose-100 text-rose-700 border-rose-200',
  info: 'bg-sky-100 text-sky-700 border-sky-200',
  neutral: 'bg-slate-100 text-slate-700 border-slate-200',
};

function inferTone(label) {
  const value = String(label ?? '').toLowerCase();
  if (['present', 'active', 'graded', 'submitted', 'published', 'a'].includes(value)) return 'success';
  if (['late', 'pending', 'upcoming', 'b', 'c'].includes(value)) return 'warning';
  if (['absent', 'inactive', 'overdue', 'missing', 'f'].includes(value)) return 'danger';
  if (['link', 'announcement'].includes(value)) return 'info';
  return 'neutral';
}

export default function StudentStatusBadge({ label, tone, className = '' }) {
  const resolvedTone = tone ?? inferTone(label);

  return (
    <span
      className={[
        'inline-flex items-center rounded-full border px-2.5 py-1 text-xs font-semibold',
        TONE_CLASSES[resolvedTone] ?? TONE_CLASSES.neutral,
        className,
      ].join(' ')}
    >
      {label}
    </span>
  );
}
