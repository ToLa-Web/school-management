'use client';
import { useEffect, useRef, useState } from 'react';
import { useAuth } from '@/lib/auth';
import { adminGetUsers, adminCreateUser, adminDeleteUser, adminUpdateUserRole, adminSyncProfile } from '@/lib/api';
import {
  Users, UserPlus, Trash2, AlertCircle, X,
  ShieldCheck, GraduationCap, BookOpen, User, ChevronDown, Check, Loader2,
} from 'lucide-react';

const ROLES = [
  { value: 1, label: 'Teacher', color: 'bg-blue-100 text-blue-700',     ring: 'ring-blue-400',   dot: 'bg-blue-500',    icon: BookOpen },
  { value: 2, label: 'Student', color: 'bg-yellow-100 text-yellow-700', ring: 'ring-yellow-400', dot: 'bg-yellow-500',  icon: GraduationCap },
  { value: 3, label: 'Parent',  color: 'bg-green-100 text-green-700',   ring: 'ring-green-400',  dot: 'bg-green-500',   icon: User },
  { value: 4, label: 'Admin',   color: 'bg-red-100 text-red-700',       ring: 'ring-red-400',    dot: 'bg-red-500',     icon: ShieldCheck },
];

const roleInfo = (v) => ROLES.find((r) => r.value === v || r.label === v) ?? ROLES[1];

const inputCls =
  'w-full border border-slate-200 rounded-xl px-3 py-2.5 text-sm focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:border-transparent bg-slate-50 placeholder:text-slate-400';

const emptyForm = { email: '', firstName: '', lastName: '', password: '', role: 2 };

/* ── Inline Role Picker ──────────────────────────────────────────────── */
function RolePicker({ userId, firstName, lastName, currentRole, onChanged }) {
  const [open, setOpen]       = useState(false);
  const [busy, setBusy]       = useState(false);
  const [roleVal, setRoleVal] = useState(currentRole);
  const ref = useRef(null);

  // close on outside click
  useEffect(() => {
    if (!open) return;
    function handle(e) { if (ref.current && !ref.current.contains(e.target)) setOpen(false); }
    document.addEventListener('mousedown', handle);
    return () => document.removeEventListener('mousedown', handle);
  }, [open]);

  async function pick(r) {
    if (r.value === roleVal) { setOpen(false); return; }
    setBusy(true);
    const res = await adminUpdateUserRole(userId, r.value);
    if (res?.ok || res?.status === 204) {
      setRoleVal(r.value);
      onChanged(userId, r.value, r.label);
      // sync school_db — creates a Teacher/Student profile if role requires one
      adminSyncProfile(userId, firstName, lastName, r.value).catch(() => {});
    }
    setBusy(false);
    setOpen(false);
  }

  const ri = roleInfo(roleVal);
  const RIcon = ri.icon;

  return (
    <div ref={ref} className="relative inline-block">
      <button
        type="button"
        onClick={() => !busy && setOpen((v) => !v)}
        className={`inline-flex items-center gap-1.5 px-2.5 py-1 rounded-lg text-xs font-semibold transition-all
          ${ri.color}
          ${open ? `ring-2 ${ri.ring}` : 'hover:ring-2 hover:ring-offset-1 ' + ri.ring}
          ${busy ? 'opacity-60 cursor-wait' : 'cursor-pointer'}`}
        title="Click to change role"
      >
        {busy
          ? <Loader2 className="w-3 h-3 animate-spin" />
          : <RIcon className="w-3 h-3" />}
        {ri.label}
        <ChevronDown className={`w-3 h-3 transition-transform ${open ? 'rotate-180' : ''}`} />
      </button>

      {open && (
        <div className="absolute left-0 top-full mt-1.5 z-50 w-40 bg-white rounded-xl border border-slate-200 shadow-xl shadow-slate-200/60 py-1 overflow-hidden">
          <p className="px-3 pt-1.5 pb-1 text-[10px] font-semibold text-slate-400 uppercase tracking-wider">Change role</p>
          {ROLES.map((r) => {
            const Icon = r.icon;
            const active = r.value === roleVal;
            return (
              <button
                key={r.value}
                type="button"
                onClick={() => pick(r)}
                className={`w-full flex items-center gap-2.5 px-3 py-2 text-xs font-medium transition-colors
                  ${active
                    ? 'bg-slate-50 text-slate-900'
                    : 'text-slate-600 hover:bg-slate-50 hover:text-slate-900'}`}
              >
                <span className={`w-2 h-2 rounded-full ${r.dot} shrink-0`} />
                <Icon className="w-3.5 h-3.5 shrink-0" />
                {r.label}
                {active && <Check className="w-3 h-3 ml-auto text-indigo-500" />}
              </button>
            );
          })}
        </div>
      )}
    </div>
  );
}

/* ── Page ────────────────────────────────────────────────────────────── */
export default function UsersPage() {
  useAuth();

  const [users,     setUsers]     = useState([]);
  const [loading,   setLoading]   = useState(true);
  const [error,     setError]     = useState('');
  const [showModal, setShowModal] = useState(false);
  const [form,      setForm]      = useState(emptyForm);
  const [saving,    setSaving]    = useState(false);
  const [formErr,   setFormErr]   = useState('');

  async function load() {
    setLoading(true);
    const data = await adminGetUsers();
    setUsers(data ?? []);
    setLoading(false);
  }

  useEffect(() => { load(); }, []);

  function setValue(field, val) { setForm((p) => ({ ...p, [field]: val })); }

  async function handleCreate(e) {
    e.preventDefault();
    setFormErr('');
    setSaving(true);
    try {
      const res  = await adminCreateUser({ ...form, role: Number(form.role) });
      const data = await res.json().catch(() => ({}));
      if (res.ok) {
        setShowModal(false);
        // sync school_db in background — fire and forget
        if (data?.id) {
          adminSyncProfile(data.id, form.firstName, form.lastName, Number(form.role)).catch(() => {});
        } else if (data?.user?.id) {
          adminSyncProfile(data.user.id, form.firstName, form.lastName, Number(form.role)).catch(() => {});
        }
        setForm(emptyForm);
        load();
      } else {
        setFormErr(data?.error ?? 'Failed to create account.');
      }
    } finally { setSaving(false); }
  }

  async function handleDelete(id, name) {
    if (!confirm(`Delete login account for ${name}?\nThey will no longer be able to log in.`)) return;
    const res = await adminDeleteUser(id);
    if (res?.ok || res?.status === 204) setUsers((p) => p.filter((u) => u.id !== id));
    else setError('Failed to delete account.');
  }

  function handleRoleChanged(id, newRoleVal, newRoleLabel) {
    setUsers((p) => p.map((u) => u.id === id ? { ...u, role: newRoleVal, userRole: newRoleLabel } : u));
  }

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="flex items-center justify-between">
        <div className="flex items-center gap-3">
          <div className="w-10 h-10 rounded-xl bg-gradient-to-br from-indigo-500 to-purple-600 flex items-center justify-center">
            <Users className="w-5 h-5 text-white" />
          </div>
          <div>
            <h1 className="text-2xl font-bold text-slate-900">Login Accounts</h1>
            <p className="text-sm text-slate-500">{users.length} accounts in auth service</p>
          </div>
        </div>
        <button
          onClick={() => { setShowModal(true); setFormErr(''); setForm(emptyForm); }}
          className="flex items-center gap-2 bg-gradient-to-r from-indigo-500 to-purple-600 hover:from-indigo-600 hover:to-purple-700 text-white text-sm font-medium px-5 py-2.5 rounded-xl shadow-lg shadow-indigo-500/20 transition-all"
        >
          <UserPlus className="w-4 h-4" />
          Add Account
        </button>
      </div>

      {error && (
        <div className="flex items-center gap-3 bg-red-50 border border-red-100 text-red-700 text-sm rounded-xl p-4">
          <AlertCircle className="w-5 h-5 shrink-0" />
          {error}
        </div>
      )}

      {/* Table */}
      <div className="bg-white rounded-2xl border border-slate-100 shadow-sm overflow-visible">
        {loading ? (
          <div className="p-12 text-center">
            <div className="w-8 h-8 border-2 border-indigo-500 border-t-transparent rounded-full animate-spin mx-auto mb-3" />
            <p className="text-slate-500 text-sm">Loading accounts…</p>
          </div>
        ) : users.length === 0 ? (
          <div className="p-12 text-center">
            <Users className="w-10 h-10 text-slate-300 mx-auto mb-2" />
            <p className="text-slate-500 text-sm">No accounts found.</p>
          </div>
        ) : (
          <table className="w-full text-sm">
            <thead className="bg-slate-50 border-b border-slate-100">
              <tr>
                <th className="text-left px-5 py-4 font-semibold text-slate-600">Name</th>
                <th className="text-left px-5 py-4 font-semibold text-slate-600">Email</th>
                <th className="text-left px-5 py-4 font-semibold text-slate-600">Role</th>
                <th className="text-left px-5 py-4 font-semibold text-slate-600">Verified</th>
                <th className="px-5 py-4 w-12"></th>
              </tr>
            </thead>
            <tbody className="divide-y divide-slate-50">
              {users.map((u, i) => (
                <tr key={u.id ?? i} className="hover:bg-slate-50/50 transition-colors">
                  <td className="px-5 py-3.5">
                    <div className="flex items-center gap-3">
                      <div className="w-8 h-8 rounded-full bg-gradient-to-br from-indigo-500 to-purple-500 flex items-center justify-center text-white font-semibold text-xs shrink-0">
                        {u.firstName?.[0]}{u.lastName?.[0]}
                      </div>
                      <span className="font-medium text-slate-900">{u.firstName} {u.lastName}</span>
                    </div>
                  </td>
                  <td className="px-5 py-3.5 text-slate-500">{u.email}</td>
                  <td className="px-5 py-3.5">
                    <RolePicker
                      userId={u.id}
                      firstName={u.firstName ?? ''}
                      lastName={u.lastName ?? ''}
                      currentRole={u.role ?? u.userRole}
                      onChanged={handleRoleChanged}
                    />
                  </td>
                  <td className="px-5 py-3.5">
                    {u.isEmailVerified
                      ? <span className="inline-flex items-center gap-1 text-emerald-600 text-xs font-medium"><Check className="w-3.5 h-3.5" />Verified</span>
                      : <span className="inline-flex items-center gap-1 text-amber-500 text-xs font-medium">Pending</span>}
                  </td>
                  <td className="px-5 py-3.5 text-right">
                    <button
                      onClick={() => handleDelete(u.id, `${u.firstName} ${u.lastName}`)}
                      className="p-2 text-slate-300 hover:text-red-500 hover:bg-red-50 rounded-lg transition-colors"
                      title="Delete account"
                    >
                      <Trash2 className="w-4 h-4" />
                    </button>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        )}
      </div>

      {/* Create Account Modal */}
      {showModal && (
        <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/40 backdrop-blur-sm p-4">
          <div className="bg-white rounded-2xl shadow-2xl w-full max-w-md">
            <div className="flex items-center justify-between p-6 border-b border-slate-100">
              <div className="flex items-center gap-3">
                <div className="w-9 h-9 rounded-xl bg-gradient-to-br from-indigo-500 to-purple-600 flex items-center justify-center">
                  <UserPlus className="w-4 h-4 text-white" />
                </div>
                <h2 className="text-lg font-semibold text-slate-900">Create Login Account</h2>
              </div>
              <button onClick={() => setShowModal(false)} className="p-2 text-slate-400 hover:text-slate-600 hover:bg-slate-100 rounded-lg transition-colors">
                <X className="w-5 h-5" />
              </button>
            </div>

            <form onSubmit={handleCreate} className="p-6 space-y-4">
              {formErr && (
                <div className="flex items-center gap-2 bg-red-50 border border-red-100 text-red-700 text-sm rounded-xl p-3">
                  <AlertCircle className="w-4 h-4 shrink-0" />
                  {formErr}
                </div>
              )}

              <div className="grid grid-cols-2 gap-3">
                <div>
                  <label className="text-xs font-semibold text-slate-700 mb-1 block">First Name <span className="text-red-500">*</span></label>
                  <input value={form.firstName} onChange={(e) => setValue('firstName', e.target.value)}
                    className={inputCls} placeholder="John" required />
                </div>
                <div>
                  <label className="text-xs font-semibold text-slate-700 mb-1 block">Last Name <span className="text-red-500">*</span></label>
                  <input value={form.lastName} onChange={(e) => setValue('lastName', e.target.value)}
                    className={inputCls} placeholder="Doe" required />
                </div>
              </div>

              <div>
                <label className="text-xs font-semibold text-slate-700 mb-1 block">Email <span className="text-red-500">*</span></label>
                <input type="email" value={form.email} onChange={(e) => setValue('email', e.target.value)}
                  className={inputCls} placeholder="john.doe@school.com" required />
              </div>

              <div>
                <label className="text-xs font-semibold text-slate-700 mb-1 block">Password <span className="text-red-500">*</span></label>
                <input type="password" value={form.password} onChange={(e) => setValue('password', e.target.value)}
                  className={inputCls} placeholder="Min. 8 characters" minLength={8} required />
              </div>

              {/* Role picker for Create modal — styled card selection */}
              <div>
                <label className="text-xs font-semibold text-slate-700 mb-2 block">Role <span className="text-red-500">*</span></label>
                <div className="grid grid-cols-2 gap-2">
                  {ROLES.map((r) => {
                    const Icon = r.icon;
                    const active = form.role === r.value;
                    return (
                      <button
                        key={r.value}
                        type="button"
                        onClick={() => setValue('role', r.value)}
                        className={`flex items-center gap-2 px-3 py-2.5 rounded-xl border-2 text-xs font-semibold transition-all
                          ${active
                            ? `${r.color} border-current shadow-sm`
                            : 'border-slate-200 text-slate-500 hover:border-slate-300 hover:bg-slate-50'}`}
                      >
                        <span className={`w-2 h-2 rounded-full ${r.dot} shrink-0`} />
                        <Icon className="w-3.5 h-3.5 shrink-0" />
                        {r.label}
                        {active && <Check className="w-3 h-3 ml-auto" />}
                      </button>
                    );
                  })}
                </div>
              </div>

              <p className="text-xs text-slate-400">Account will be pre-verified and ready to log in immediately.</p>

              <div className="flex gap-3 pt-1">
                <button type="submit" disabled={saving}
                  className="flex-1 bg-gradient-to-r from-indigo-500 to-purple-600 hover:from-indigo-600 hover:to-purple-700 disabled:opacity-50 text-white text-sm font-medium px-5 py-2.5 rounded-xl shadow-lg shadow-indigo-500/20 transition-all flex items-center justify-center gap-2">
                  {saving ? <Loader2 className="w-4 h-4 animate-spin" /> : <UserPlus className="w-4 h-4" />}
                  {saving ? 'Creating…' : 'Create Account'}
                </button>
                <button type="button" onClick={() => setShowModal(false)}
                  className="px-5 py-2.5 rounded-xl border border-slate-200 text-sm font-medium text-slate-600 hover:bg-slate-50 transition-colors">
                  Cancel
                </button>
              </div>
            </form>
          </div>
        </div>
      )}
    </div>
  );
}