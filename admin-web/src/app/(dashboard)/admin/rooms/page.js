'use client';
import { useEffect, useState } from 'react';
import Link from 'next/link';
import { useAuth } from '@/lib/auth';
import { getRooms, deleteRoom } from '@/lib/api';
import { Home, Plus, Trash2, AlertCircle, Search, MapPin, Users } from 'lucide-react';
import DeleteConfirmDialog from '@/components/DeleteConfirmDialog';

export default function RoomsPage() {
  useAuth();

  const [rooms, setRooms] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');
  const [search, setSearch] = useState('');
  const [deleteDialogOpen, setDeleteDialogOpen] = useState(false);
  const [deleteTarget, setDeleteTarget] = useState(null);
  const [deleting, setDeleting] = useState(false);

  useEffect(() => {
    getRooms().then((data) => {
      setRooms(data?.items ?? data ?? []);
      setLoading(false);
    });
  }, []);

  async function handleDeleteConfirm() {
    if (!deleteTarget) return;
    setDeleting(true);
    try {
      const res = await deleteRoom(deleteTarget.id);
      if (res?.ok) {
        setRooms((prev) => prev.filter((r) => r.id !== deleteTarget.id));
        setDeleteDialogOpen(false);
        setDeleteTarget(null);
      } else {
        setError('Failed to delete room.');
      }
    } finally {
      setDeleting(false);
    }
  }

  function handleDeleteClick(id, name) {
    setDeleteTarget({ id, name });
    setDeleteDialogOpen(true);
  }

  const filtered = rooms.filter(r =>
    (r.name ?? '').toLowerCase().includes(search.toLowerCase()) ||
    (r.location ?? '').toLowerCase().includes(search.toLowerCase())
  );

  const roomTypeColors = {
    1: { bg: 'bg-blue-50', badge: 'bg-blue-100 text-blue-700', label: 'Classroom' },
    2: { bg: 'bg-purple-50', badge: 'bg-purple-100 text-purple-700', label: 'Lab' },
    3: { bg: 'bg-green-50', badge: 'bg-green-100 text-green-700', label: 'Gym' },
    4: { bg: 'bg-orange-50', badge: 'bg-orange-100 text-orange-700', label: 'Auditorium' },
  };

  return (
    <div className="admin-page">
      {/* Header */}
      <div className="flex items-center justify-between mb-6">
        <div className="flex items-center gap-3">
          <div className="admin-header-icon">
            <Home className="w-5 h-5 text-white" />
          </div>
          <div>
            <h1 className="text-2xl font-bold text-slate-900">Rooms</h1>
            <p className="text-sm text-slate-500">{rooms.length} total</p>
          </div>
        </div>
        <Link
          href="/admin/rooms/new"
          className="admin-btn-primary"
        >
          <Plus className="w-4 h-4" />
          Add Room
        </Link>
      </div>

      {error && (
        <div className="flex items-center gap-3 bg-red-50 border border-red-100 text-red-700 text-sm rounded-xl p-4 mb-4">
          <AlertCircle className="w-5 h-5 shrink-0" />
          {error}
        </div>
      )}

      {/* Search */}
      <div className="relative mb-4">
        <Search className="absolute left-3 top-1/2 -translate-y-1/2 w-5 h-5 text-slate-400" />
        <input
          type="text"
          placeholder="Search by name or location..."
          value={search}
          onChange={(e) => setSearch(e.target.value)}
          className="w-full max-w-sm pl-10 pr-4 py-2.5 bg-white border border-slate-200 rounded-xl text-sm focus:outline-none focus:ring-2 focus:ring-emerald-500 focus:border-transparent"
        />
      </div>

      {/* Rooms Grid */}
      {loading ? (
        <div className="bg-white rounded-2xl border border-slate-100 p-12 text-center">
          <div className="w-8 h-8 border-2 border-emerald-500 border-t-transparent rounded-full animate-spin mx-auto mb-3" />
          <p className="text-slate-500 text-sm">Loading rooms...</p>
        </div>
      ) : filtered.length === 0 ? (
        <div className="bg-white rounded-2xl border border-slate-100 p-12 text-center">
          <Home className="w-12 h-12 text-slate-300 mx-auto mb-3" />
          <p className="text-slate-500 text-sm">
            {search ? 'No rooms match your search.' : 'No rooms yet. Create one to get started.'}
          </p>
        </div>
      ) : (
        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-5">
          {filtered.map((room) => {
            const typeInfo = roomTypeColors[room.type] || roomTypeColors[1];
            return (
              <div
                key={room.id}
                className="bg-white rounded-2xl border border-slate-100 shadow-sm hover:shadow-lg transition-all duration-200 overflow-hidden group"
              >
                {/* Top border accent */}
                <div className={`h-1 ${typeInfo.bg.replace('bg-', 'bg-').replace('50', '500')}`}></div>

                {/* Card Content */}
                <div className="p-5">
                  {/* Header with badge */}
                  <div className="flex items-start justify-between gap-3 mb-4">
                    <div className="flex-1">
                      <h3 className="font-semibold text-slate-900 text-lg leading-tight">
                        {room.name}
                      </h3>
                      {room.location && (
                        <div className="flex items-center gap-1.5 text-sm text-slate-500 mt-2">
                          <MapPin className="w-4 h-4 text-slate-400 shrink-0" />
                          <span>{room.location}</span>
                        </div>
                      )}
                    </div>
                    <span className={`text-xs font-semibold px-2.5 py-1 rounded-full shrink-0 whitespace-nowrap ${typeInfo.badge}`}>
                      {typeInfo.label}
                    </span>
                  </div>

                  {/* Capacity Info */}
                  {room.capacity > 0 && (
                    <div className="flex items-center gap-2 mb-4 text-sm text-slate-600 bg-slate-50 px-3 py-2 rounded-lg">
                      <Users className="w-4 h-4 text-slate-400" />
                      <span>{room.capacity} capacity</span>
                    </div>
                  )}

                  {/* Status Indicator */}
                  {room.isActive === false && (
                    <div className="inline-flex items-center gap-1.5 mb-4 px-2.5 py-1 rounded-lg bg-red-50 border border-red-100">
                      <div className="w-2 h-2 rounded-full bg-red-500"></div>
                      <span className="text-xs font-medium text-red-600">Inactive</span>
                    </div>
                  )}
                </div>

                {/* Divider */}
                <div className="border-t border-slate-100"></div>

                {/* Footer Actions */}
                <div className="flex items-center justify-between px-5 py-3 bg-slate-50/50">
                  <Link
                    href={`/admin/rooms/${room.id}`}
                    className="inline-flex items-center gap-2 px-4 py-2 text-sm font-medium text-emerald-600 hover:text-emerald-700 hover:bg-emerald-50 rounded-lg transition-all duration-200"
                  >
                    Edit
                  </Link>
                  <button
                    onClick={() => handleDeleteClick(room.id, room.name)}
                    className="inline-flex items-center justify-center w-9 h-9 text-slate-400 hover:text-red-600 hover:bg-red-50 rounded-lg transition-all duration-200"
                    title="Delete room"
                  >
                    <Trash2 className="w-4 h-4" />
                  </button>
                </div>
              </div>
            );
          })}
        </div>
      )}

      <DeleteConfirmDialog
        isOpen={deleteDialogOpen}
        title="Delete Room"
        message={`Are you sure you want to delete "${deleteTarget?.name}"? This cannot be undone.`}
        onConfirm={handleDeleteConfirm}
        onCancel={() => setDeleteDialogOpen(false)}
        isLoading={deleting}
      />
    </div>
  );
}
