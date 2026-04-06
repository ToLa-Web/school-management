'use client';
import { useState } from 'react';
import { useRouter } from 'next/navigation';
import Link from 'next/link';
import { registerUser, oauthLogin } from '@/lib/api';
import { School, Mail, Lock, User, UserPlus, AlertCircle } from 'lucide-react';

export default function RegisterPage() {
  const router = useRouter();
  const [formData, setFormData] = useState({ firstName: '', lastName: '', email: '', password: '', role: 2 }); // default student
  const [error, setError] = useState('');
  const [loading, setLoading] = useState(false);

  async function handleSubmit(e) {
    e.preventDefault();
    setError('');
    setLoading(true);

    try {
      const res = await registerUser(formData);
      const data = await res.json();

      if (!res.ok) {
        setError(data?.message ?? data?.error ?? 'Registration failed');
      } else {
        router.push('/verify-email?email=' + encodeURIComponent(formData.email));
      }
    } catch {
      setError('Cannot connect to the server.');
    } finally {
      setLoading(false);
    }
  }

  async function handleOAuth(provider) {
     alert(provider + ' OAuth coming soon!'); 
  }

  return (
    <div className="w-full flex-1 min-h-screen flex items-center justify-center bg-[#dde6ed] p-4">
      <div className="absolute inset-0 overflow-hidden pointer-events-none">
        <div className="absolute -top-40 -left-40 w-80 h-80 bg-[#9db2bf] rounded-full blur-3xl opacity-20" />
        <div className="absolute -bottom-40 -right-40 w-80 h-80 bg-[#526d82] rounded-full blur-3xl opacity-15" />
      </div>

      <div className="relative bg-white/95 backdrop-blur-sm rounded-2xl shadow-2xl w-full max-w-md p-8">
        <div className="flex justify-center mb-6">
          <div className="w-16 h-16 rounded-2xl bg-[#526d82] flex items-center justify-center shadow-lg shadow-slate-500/25">
            <School className="w-8 h-8 text-white" />
          </div>
        </div>
        <h1 className="text-2xl font-bold text-slate-900 text-center mb-1">Create an Account</h1>
        <p className="text-sm text-slate-500 text-center mb-6">Join the School Management System</p>

        {error && (
          <div className="flex items-start gap-3 bg-red-50 border border-red-100 text-red-700 text-sm rounded-xl p-4 mb-6">
            <AlertCircle className="w-5 h-5 shrink-0 mt-0.5" /><span>{error}</span>
          </div>
        )}

        <form onSubmit={handleSubmit} className="space-y-4">
          <div className="flex gap-4">
            <div className="relative flex-1">
              <User className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-slate-400" />
              <input type="text" required value={formData.firstName} onChange={(e) => setFormData({...formData, firstName: e.target.value})} placeholder="First Name" className="w-full pl-9 pr-4 py-2.5 bg-slate-50 border border-slate-200 rounded-xl text-sm focus:outline-none focus:ring-2 focus:ring-[#526d82]" />
            </div>
            <div className="relative flex-1">
              <User className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-slate-400" />
              <input type="text" required value={formData.lastName} onChange={(e) => setFormData({...formData, lastName: e.target.value})} placeholder="Last Name" className="w-full pl-9 pr-4 py-2.5 bg-slate-50 border border-slate-200 rounded-xl text-sm focus:outline-none focus:ring-2 focus:ring-[#526d82]" />
            </div>
          </div>
          <div className="relative">
            <Mail className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-slate-400" />
            <input type="email" required value={formData.email} onChange={(e) => setFormData({...formData, email: e.target.value})} placeholder="Email Address" className="w-full pl-9 pr-4 py-2.5 bg-slate-50 border border-slate-200 rounded-xl text-sm focus:outline-none focus:ring-2 focus:ring-[#526d82]" />
          </div>
          <div className="relative">
            <Lock className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-slate-400" />
            <input type="password" required value={formData.password} onChange={(e) => setFormData({...formData, password: e.target.value})} placeholder="Password" className="w-full pl-9 pr-4 py-2.5 bg-slate-50 border border-slate-200 rounded-xl text-sm focus:outline-none focus:ring-2 focus:ring-[#526d82]" />
          </div>
          
          <button type="submit" disabled={loading} className="w-full bg-[#526d82] hover:bg-[#27374d] text-white font-semibold py-3 rounded-xl text-sm shadow-lg shadow-slate-500/25 flex items-center justify-center gap-2">
            {loading ? 'Creating...' : <><UserPlus className="w-4 h-4" /> Sign Up</>}
          </button>
        </form>

        <div className="mt-6 flex items-center justify-between">
          <span className="border-b border-slate-200 w-1/5 lg:w-1/4"></span>
          <span className="text-xs text-center text-slate-500 uppercase font-medium">Or continue with</span>
          <span className="border-b border-slate-200 w-1/5 lg:w-1/4"></span>
        </div>

        <div className="mt-6 flex gap-3">
          <button onClick={() => handleOAuth('google')} className="w-full flex items-center justify-center gap-2 py-2.5 border border-slate-200 rounded-xl text-sm font-medium text-slate-700 hover:bg-slate-50 transition-colors">
            <svg className="w-5 h-5" viewBox="0 0 24 24"><path fill="#4285F4" d="M22.56 12.25c0-.78-.07-1.53-.2-2.25H12v4.26h5.92c-.26 1.37-1.04 2.53-2.21 3.31v2.77h3.57c2.08-1.92 3.28-4.74 3.28-8.09z"/><path fill="#34A853" d="M12 23c2.97 0 5.46-.98 7.28-2.66l-3.57-2.77c-.98.66-2.23 1.06-3.71 1.06-2.86 0-5.29-1.93-6.16-4.53H2.18v2.84C3.99 20.53 7.7 23 12 23z"/><path fill="#FBBC05" d="M5.84 14.09c-.22-.66-.35-1.36-.35-2.09s.13-1.43.35-2.09V7.07H2.18C1.43 8.55 1 10.22 1 12s.43 3.45 1.18 4.93l2.85-2.22.81-.62z"/><path fill="#EA4335" d="M12 5.38c1.62 0 3.06.56 4.21 1.64l3.15-3.15C17.45 2.09 14.97 1 12 1 7.7 1 3.99 3.47 2.18 7.07l3.66 2.84c.87-2.6 3.3-4.53 6.16-4.53z"/></svg> Google
          </button>
          <button onClick={() => handleOAuth('facebook')} className="w-full flex items-center justify-center gap-2 py-2.5 border border-slate-200 rounded-xl text-sm font-medium text-slate-700 hover:bg-slate-50 transition-colors">
            <svg className="w-5 h-5" viewBox="0 0 24 24"><path fill="#1877F2" d="M24 12.073c0-6.627-5.373-12-12-12s-12 5.373-12 12c0 5.99 4.388 10.954 10.125 11.854v-8.385H7.078v-3.469h3.047V9.43c0-3.007 1.792-4.669 4.533-4.669 1.312 0 2.686.235 2.686.235v2.953H15.83c-1.491 0-1.956.925-1.956 1.874v2.25h3.328l-.532 3.469h-2.796v8.385C19.612 23.027 24 18.062 24 12.073z"/></svg> Facebook
          </button>
        </div>

        <p className="mt-8 text-center text-sm text-slate-500">
          Already have an account? <Link href="/login" className="font-semibold text-[#526d82] hover:text-[#27374d]">Sign in</Link>
        </p>
      </div>
    </div>
  );
}
