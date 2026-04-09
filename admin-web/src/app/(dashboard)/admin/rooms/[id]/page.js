'use client';
import { useEffect, useState } from 'react';
import { useRouter, useParams } from 'next/navigation';
import Link from 'next/link';
import { useAuth } from '@/lib/auth';
import { getRoom, updateRoom } from '@/lib/api';
import { Home, ArrowLeft, AlertCircle, Save, Loader2, MapPin, Users, Layers } from 'lucide-react';

const inputCls = 'admin-input';

const ROOM_TYPES = [
  { value: '1', label: 'Classroom' },
  { value: '2', label: 'Lab' },
  { value: '3', label: 'Gym' },
  { value: '4', label: 'Auditorium' },
];

export default function EditRoomPage() {
  useAuth();
  const router = useRouter();
  const params = useParams();
  const roomId = params.id;

  const [form, setForm] = useState({ name: '', location: '', capacity: '', type: '1' });
  const [error, setError] = useState('');
  const [loading, setLoading] = useState(true);
  const [saving, setSaving] = useState(false);

  useEffect(() => {
    getRoom(roomId).then((room) => {
      if (room) {
        setForm({
          name: room.name || '',
          location: room.location || '',
          capacity: room.capacity || '',
          type: String(room.type || '1'),
        });
      } else {
        setError('Room not found');
      }
      setLoading(false);
    });
  }, [roomId]);

  function set(field, value) {
    setForm((prev) => ({ ...prev, [field]: value }));
  }

  async function handleSubmit(e) {
    e.preventDefault();
    setError('');

    if (!form.name.trim()) {
      setError('Room name is required');
      return;
    }

    setSaving(true);
    try {
      const payload = {
        name: form.name.trim(),
        location: form.location.trim() || null,
        capacity: form.capacity ? parseInt(form.capacity, 10) : 0,
        type: parseInt(form.type, 10),
      };

      const res = await updateRoom(roomId, payload);
      if (!res?.ok) {
        const data = await res.json?.().catch(() => ({})) || {};
        setError(data?.details ?? data?.message ?? data?.error ?? 'Failed to update room.');
        return;
      }

      router.push('/admin/rooms');
    } finally {
      setSaving(false);
    }
  }

  if (loading) {
    return (
      <div className="admin-page flex items-center justify-center py-12">
        <Loader2 className="w-6 h-6 animate-spin text-slate-400" />
      </div>
    );
  }

  return (
    <div className="max-w-lg admin-page">
      {/* Header */}
      <div className="flex items-center gap-3 mb-6">
        <Link href="/admin/rooms" className="p-2 text-slate-400 hover:text-slate-600 hover:bg-slate-100 rounded-lg transition-colors">
          <ArrowLeft className="w-5 h-5" />
        </Link>
        <div className="admin-header-icon">
          <Home className="w-5 h-5 text-white" />
        </div>
        <div>
          <h1 className="text-2xl font-bold text-slate-900">Edit Room</h1>
          <p className="text-sm text-slate-500">{form.name}</p>
        </div>
      </div>

      {error && (
        <div className="flex items-center gap-3 bg-red-50 border border-red-100 text-red-700 text-sm rounded-xl p-4 mb-4">
          <AlertCircle className="w-5 h-5 shrink-0" />
          {error}
        </div>
      )}

      <form onSubmit={handleSubmit} className="space-y-5">
        <div className="admin-section space-y-5">
          <div>
            <label className="flex items-center gap-1.5 text-sm font-semibold text-slate-700 mb-1.5">
              <Home className="w-4 h-4 text-slate-400" />
              Room Name <span className="text-red-500">*</span>
            </label>
            <input
              type="text"
              required
              value={form.name}
              onChange={(e) => set('name', e.target.value)}
              placeholder="e.g. Room 101"
              className={inputCls}
            />
          </div>

          <div>
            <label className="flex items-center gap-1.5 text-sm font-semibold text-slate-700 mb-1.5">
              <MapPin className="w-4 h-4 text-slate-400" />
              Location
            </label>
            <input
              type="text"
              value={form.location}
              onChange={(e) => set('location', e.target.value)}
              placeholder="e.g. Building A, Floor 2"
              className={inputCls}
            />
          </div>

          <div>
            <label className="flex items-center gap-1.5 text-sm font-semibold text-slate-700 mb-1.5">
              <Layers className="w-4 h-4 text-slate-400" />
              Room Type <span className="text-red-500">*</span>
            </label>
            <select
              required
              value={form.type}
              onChange={(e) => set('type', e.target.value)}
              className={inputCls}
            >
              {ROOM_TYPES.map((t) => (
                <option key={t.value} value={t.value}>{t.label}</option>
              ))}
            </select>
          </div>

          <div>
            <label className="flex items-center gap-1.5 text-sm font-semibold text-slate-700 mb-1.5">
              <Users className="w-4 h-4 text-slate-400" />
              Capacity (optional)
            </label>
            <input
              type="number"
              value={form.capacity}
              onChange={(e) => set('capacity', e.target.value)}
              placeholder="e.g. 30"
              min="0"
              className={inputCls}
            />
          </div>
        </div>

        {/* Actions */}
        <div className="flex gap-3 pb-8">
          <button
            type="submit"
            disabled={saving}
            className="admin-btn-primary disabled:opacity-50"
          >
            {saving ? <Loader2 className="w-4 h-4 animate-spin" /> : <Save className="w-4 h-4" />}
            {saving ? 'Saving...' : 'Save Changes'}
          </button>
          <button
            type="button"
            onClick={() => router.push('/admin/rooms')}
            className="text-slate-600 hover:text-slate-800 text-sm font-medium px-5 py-2.5 rounded-xl border border-slate-200 hover:bg-slate-50 transition-colors"
          >
            Cancel
          </button>
        </div>
      </form>
    </div>
  );
}
