'use client';
import { useState, useEffect, Suspense } from 'react';
import { useRouter, useSearchParams } from 'next/navigation';
import Link from 'next/link';
import { verifyEmail } from '@/lib/api';
import { School, CheckCircle, KeyRound, AlertCircle } from 'lucide-react';

function VerifyEmailForm() {
  const router = useRouter();
  const searchParams = useSearchParams();
  const emailParam = searchParams.get('email') || '';
  
  const [email, setEmail] = useState('');
  const [code, setCode] = useState('');
  const [error, setError] = useState('');
  const [success, setSuccess] = useState(false);
  const [loading, setLoading] = useState(false);

  useEffect(() => {
    if (emailParam) setEmail(emailParam);
  }, [emailParam]);

  async function handleSubmit(e) {
    e.preventDefault();
    setError('');
    setLoading(true);

    try {
      const res = await verifyEmail(email, code);
      if (!res.ok) {
        const data = await res.json();
        setError(data?.message ?? 'Verification failed');
      } else {
        setSuccess(true);
        setTimeout(() => router.push('/login'), 3000);
      }
    } catch {
      setError('Cannot connect to the server.');
    } finally {
      setLoading(false);
    }
  }

  return (
    <div className="relative bg-white/95 backdrop-blur-sm rounded-2xl shadow-2xl w-full max-w-md p-8">
      <div className="flex justify-center mb-6">
        <div className="w-16 h-16 rounded-2xl bg-[#526d82] flex items-center justify-center shadow-lg shadow-slate-500/25">
          <School className="w-8 h-8 text-white" />
        </div>
      </div>
      
      {success ? (
        <div className="text-center">
          <CheckCircle className="w-16 h-16 text-emerald-500 mx-auto mb-4" />
          <h1 className="text-2xl font-bold text-slate-900 mb-2">Email Verified!</h1>
          <p className="text-slate-500 mb-6">You can now sign in to your account. Redirecting...</p>
          <Link href="/login" className="text-[#526d82] font-medium hover:underline">Go to Login</Link>
        </div>
      ) : (
        <>
          <h1 className="text-xl font-bold text-slate-900 text-center mb-1">Verify your Email</h1>
          <p className="text-sm text-slate-500 text-center mb-6">Enter the code sent to your email.</p>

          {error && (
            <div className="flex items-start gap-3 bg-red-50 border border-red-100 text-red-700 text-sm rounded-xl p-4 mb-6">
              <AlertCircle className="w-5 h-5 shrink-0 mt-0.5" /><span>{error}</span>
            </div>
          )}

          <form onSubmit={handleSubmit} className="space-y-4">
            <input type="email" required value={email} onChange={(e) => setEmail(e.target.value)} placeholder="Email Address" className="w-full px-4 py-2.5 bg-slate-50 border border-slate-200 rounded-xl text-sm focus:outline-none focus:ring-2 focus:ring-[#526d82]" />
            <div className="relative">
              <KeyRound className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-slate-400" />
              <input type="text" required value={code} onChange={(e) => setCode(e.target.value)} placeholder="Verification Code" className="w-full pl-9 pr-4 py-2.5 bg-slate-50 border border-slate-200 rounded-xl text-sm tracking-widest focus:outline-none focus:ring-2 focus:ring-[#526d82]" />
            </div>
            <button type="submit" disabled={loading} className="w-full bg-[#526d82] hover:bg-[#27374d] text-white font-semibold py-3 rounded-xl text-sm shadow-lg flex justify-center">
              {loading ? 'Verifying...' : 'Verify Email'}
            </button>
          </form>
        </>
      )}
    </div>
  );
}

export default function VerifyEmailPage() {
  return (
    <div className="w-full flex-1 min-h-screen flex items-center justify-center bg-[#dde6ed] p-4">
      <Suspense fallback={<div className="text-white text-sm">Loading...</div>}>
        <VerifyEmailForm />
      </Suspense>
    </div>
  );
}
