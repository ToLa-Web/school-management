'use client';

export default function StudentStatCard({ icon: Icon, label, value, helper, tone = 'slate', trend = null }) {
  const toneClasses = {
    slate: 'bg-slate-100 text-slate-700',
    blue: 'bg-blue-100 text-blue-700',
    emerald: 'bg-emerald-100 text-emerald-700',
    amber: 'bg-amber-100 text-amber-700',
    rose: 'bg-rose-100 text-rose-700',
  };

  return (
    <div className="rounded-[1.6rem] border border-slate-200/70 bg-white/88 p-5 shadow-[0_18px_40px_-34px_rgba(15,23,42,0.5)]">
      <div className="flex items-start justify-between gap-3">
        <div className={`flex h-11 w-11 items-center justify-center rounded-2xl ${toneClasses[tone] ?? toneClasses.slate}`}>
          {Icon ? <Icon className="h-5 w-5" /> : null}
        </div>
        {trend ? (
          <span className="rounded-full bg-slate-100 px-3 py-1 text-xs font-semibold text-slate-600">{trend}</span>
        ) : null}
      </div>
      <p className="mt-5 text-sm font-medium text-slate-500">{label}</p>
      <p className="mt-2 text-3xl font-semibold tracking-tight text-slate-950">{value}</p>
      {helper ? <p className="mt-2 text-sm leading-6 text-slate-500">{helper}</p> : null}
    </div>
  );
}
