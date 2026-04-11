'use client';

export default function StudentEmptyState({ icon: Icon, title, description, action = null }) {
  return (
    <div className="rounded-[1.6rem] border border-dashed border-slate-200 bg-white/85 p-8 text-center shadow-sm">
      {Icon && (
        <div className="mx-auto flex h-14 w-14 items-center justify-center rounded-2xl bg-slate-100 text-slate-500">
          <Icon className="h-6 w-6" />
        </div>
      )}
      <h3 className="mt-4 text-lg font-semibold text-slate-900">{title}</h3>
      <p className="mt-2 text-sm leading-6 text-slate-500">{description}</p>
      {action ? <div className="mt-5">{action}</div> : null}
    </div>
  );
}
