'use client';

export default function StudentSectionCard({ icon: Icon, title, subtitle, action = null, children, className = '' }) {
  return (
    <section className={['admin-card rounded-[1.8rem] p-6', className].join(' ')}>
      <div className="flex flex-col gap-4 sm:flex-row sm:items-start sm:justify-between">
        <div className="flex items-start gap-3">
          {Icon ? (
            <div className="flex h-11 w-11 items-center justify-center rounded-2xl bg-slate-100 text-slate-700">
              <Icon className="h-5 w-5" />
            </div>
          ) : null}
          <div>
            <h2 className="text-xl font-semibold text-slate-950">{title}</h2>
            {subtitle ? <p className="mt-1 text-sm text-slate-500">{subtitle}</p> : null}
          </div>
        </div>
        {action}
      </div>

      <div className="mt-6">{children}</div>
    </section>
  );
}
