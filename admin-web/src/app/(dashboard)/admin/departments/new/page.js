'use client';
import { useRouter } from 'next/navigation';
import { useAuth } from '@/lib/auth';
import { createDepartment } from '@/lib/api';
import { ArrowLeft } from 'lucide-react';
import DepartmentForm from '@/components/DepartmentForm';
import { useState } from 'react';

export default function NewDepartmentPage() {
  useAuth();
  const router = useRouter();
  const [error, setError] = useState('');
  const [isLoading, setIsLoading] = useState(false);

  async function handleSubmit(data) {
    setError('');
    setIsLoading(true);
    try {
      const result = await createDepartment(data);
      if (result?.ok) {
        router.push('/admin/departments');
      } else {
        setError('Failed to create department');
      }
    } catch (err) {
      setError('Failed to create department');
    } finally {
      setIsLoading(false);
    }
  }

  return (
    <div className="min-h-screen bg-gradient-to-br from-slate-50 to-slate-100 p-6">
      <div className="max-w-2xl mx-auto">
        {/* Header */}
        <button
          onClick={() => router.back()}
          className="inline-flex items-center gap-2 text-sm font-medium text-slate-600 hover:text-slate-900 mb-6 py-2"
        >
          <ArrowLeft className="w-4 h-4" />
          Back
        </button>

        <div className="bg-white rounded-2xl border border-slate-100 shadow-sm p-8">
          <h1 className="text-2xl font-bold text-slate-900 mb-2">Create Department</h1>
          <p className="text-slate-500 text-sm mb-6">Add a new department to your organization.</p>

          {error && (
            <div className="bg-red-50 border border-red-100 text-red-700 text-sm rounded-lg p-4 mb-6">
              {error}
            </div>
          )}

          <DepartmentForm
            onSubmit={handleSubmit}
            onCancel={() => router.back()}
            isLoading={isLoading}
          />
        </div>
      </div>
    </div>
  );
}
