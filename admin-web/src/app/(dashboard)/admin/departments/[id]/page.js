'use client';
import { useRouter, useParams } from 'next/navigation';
import { useEffect, useState } from 'react';
import { useAuth } from '@/lib/auth';
import { getDepartment, updateDepartment } from '@/lib/api';
import { ArrowLeft, AlertCircle } from 'lucide-react';
import DepartmentForm from '@/components/DepartmentForm';

export default function EditDepartmentPage() {
  useAuth();
  const router = useRouter();
  const params = useParams();
  const departmentId = params.id;

  const [department, setDepartment] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');
  const [isSubmitting, setIsSubmitting] = useState(false);

  useEffect(() => {
    async function load() {
      try {
        const data = await getDepartment(departmentId);
        setDepartment(data);
      } catch (err) {
        setError('Failed to load department');
      } finally {
        setLoading(false);
      }
    }
    load();
  }, [departmentId]);

  async function handleSubmit(data) {
    setError('');
    setIsSubmitting(true);
    try {
      const result = await updateDepartment(departmentId, data);
      if (result?.ok) {
        router.push('/admin/departments');
      } else {
        setError('Failed to update department');
      }
    } catch (err) {
      setError('Failed to update department');
    } finally {
      setIsSubmitting(false);
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
          <h1 className="text-2xl font-bold text-slate-900 mb-2">Edit Department</h1>
          <p className="text-slate-500 text-sm mb-6">Update department information.</p>

          {error && (
            <div className="flex items-center gap-3 bg-red-50 border border-red-100 text-red-700 text-sm rounded-lg p-4 mb-6">
              <AlertCircle className="w-5 h-5 shrink-0" />
              {error}
            </div>
          )}

          {loading ? (
            <div className="text-center py-12">
              <div className="w-8 h-8 border-2 border-purple-500 border-t-transparent rounded-full animate-spin mx-auto mb-3" />
              <p className="text-slate-500 text-sm">Loading department...</p>
            </div>
          ) : department ? (
            <DepartmentForm
              department={department}
              onSubmit={handleSubmit}
              onCancel={() => router.back()}
              isLoading={isSubmitting}
            />
          ) : (
            <div className="text-center py-12">
              <p className="text-slate-500 text-sm">Department not found</p>
            </div>
          )}
        </div>
      </div>
    </div>
  );
}
