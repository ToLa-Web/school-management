'use client';

export default function StudentLineChart({ data = [], color = '#526d82', height = 200, formatValue = (value) => value }) {
  if (!data.length) {
    return (
      <div className="flex h-40 items-center justify-center rounded-[1.4rem] border border-dashed border-slate-200 bg-slate-50/80 text-sm text-slate-500">
        No trend data available yet.
      </div>
    );
  }

  const values = data.map((point) => Number(point.value ?? 0));
  const max = Math.max(...values, 1);
  const min = Math.min(...values, 0);
  const range = max - min || 1;
  const width = 100;

  const points = data
    .map((point, index) => {
      const x = (index / Math.max(data.length - 1, 1)) * width;
      const y = 100 - (((Number(point.value ?? 0) - min) / range) * 100);
      return `${x},${y}`;
    })
    .join(' ');

  return (
    <div className="space-y-4">
      <div className="rounded-[1.4rem] border border-slate-200/70 bg-white/75 p-4">
        <svg viewBox={`0 0 ${width} 100`} className="w-full" style={{ height }}>
          <polyline fill="none" stroke={color} strokeWidth="2.5" points={points} />
          {data.map((point, index) => {
            const x = (index / Math.max(data.length - 1, 1)) * width;
            const y = 100 - (((Number(point.value ?? 0) - min) / range) * 100);
            return <circle key={`${point.label}-${index}`} cx={x} cy={y} r="2.5" fill={color} />;
          })}
        </svg>
      </div>

      <div className="grid gap-3 sm:grid-cols-2 xl:grid-cols-4">
        {data.map((point) => (
          <div key={point.label} className="rounded-2xl border border-slate-200/70 bg-white/80 px-4 py-3">
            <p className="text-xs font-semibold uppercase tracking-[0.16em] text-slate-500">{point.label}</p>
            <p className="mt-2 text-lg font-semibold text-slate-900">{formatValue(point.value)}</p>
          </div>
        ))}
      </div>
    </div>
  );
}
