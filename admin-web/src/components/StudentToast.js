'use client';

import { AlertCircle, CheckCircle2, Info, X } from 'lucide-react';

const ICONS = {
  success: CheckCircle2,
  error: AlertCircle,
  info: Info,
};

const TONES = {
  success: 'border-emerald-200 bg-emerald-50 text-emerald-800',
  error: 'border-rose-200 bg-rose-50 text-rose-800',
  info: 'border-sky-200 bg-sky-50 text-sky-800',
};

export default function StudentToast({ open, title, message, tone = 'success', onClose }) {
  if (!open) return null;

  const Icon = ICONS[tone] ?? ICONS.info;

  return (
    <div className="fixed right-4 top-4 z-[90] w-full max-w-sm">
      <div className={`rounded-2xl border px-4 py-4 shadow-xl ${TONES[tone] ?? TONES.info}`}>
        <div className="flex items-start gap-3">
          <Icon className="mt-0.5 h-5 w-5 shrink-0" />
          <div className="min-w-0 flex-1">
            <p className="text-sm font-semibold">{title}</p>
            {message ? <p className="mt-1 text-sm">{message}</p> : null}
          </div>
          <button
            type="button"
            onClick={onClose}
            className="rounded-lg p-1 transition hover:bg-white/60"
            aria-label="Dismiss notification"
          >
            <X className="h-4 w-4" />
          </button>
        </div>
      </div>
    </div>
  );
}
