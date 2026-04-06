'use client';
import { useEffect, useState } from 'react';
import { useAuth } from '@/lib/auth';
import { getHealthDashboard } from '@/lib/api';
import { Activity, AlertCircle, RefreshCcw } from 'lucide-react';

export default function HealthPage() {
  useAuth();

  const [data,    setData]    = useState(null);
  const [loading, setLoading] = useState(true);
  const [error,   setError]   = useState('');

  async function load() {
    setLoading(true);
    setError('');
    const result = await getHealthDashboard();
    if (result) setData(result);
    else setError('Could not reach the health endpoint. Is the backend running?');
    setLoading(false);
  }

  useEffect(() => { load(); }, []);

  return (
    <div className="admin-page">
      <div className="admin-header">
        <div className="admin-header-main">
          <div className="admin-header-icon">
            <Activity className="h-5 w-5" />
          </div>
          <div>
            <h1 className="admin-title">Service Health</h1>
            <p className="admin-subtitle">
            Live status of all services registered in Consul
          </p>
          </div>
        </div>
        <button
          onClick={load}
          className="admin-btn-secondary"
        >
          <RefreshCcw className="h-4 w-4" />
          Refresh
        </button>
      </div>

      {error && (
        <div className="flex items-center gap-3 rounded-xl border border-red-200 bg-red-50 p-4 text-sm text-red-700">
          <AlertCircle className="h-5 w-5 shrink-0" />
          {error}
        </div>
      )}

      {loading ? (
        <p className="text-gray-500 text-sm">Loading…</p>
      ) : data ? (
        <>
          {/* Summary row */}
          <div className="grid grid-cols-2 sm:grid-cols-4 gap-4 mb-6">
            {[
              { label: 'Total Services',    value: data.totalServices },
              { label: 'Healthy Services',  value: data.summary?.healthyServices,   green: true  },
              { label: 'Unhealthy',         value: data.summary?.unhealthyServices, red: true    },
              { label: 'Total Instances',   value: data.summary?.totalInstances },
            ].map(({ label, value, green, red }) => (
              <div key={label} className="admin-card p-4">
                <p className={`text-2xl font-bold ${green ? 'text-green-600' : red && value > 0 ? 'text-red-500' : 'text-gray-800'}`}>
                  {value ?? '—'}
                </p>
                <p className="text-xs text-gray-500 mt-0.5">{label}</p>
              </div>
            ))}
          </div>

          {/* Per-service cards */}
          <div className="space-y-4">
            {(data.services ?? []).map((svc) => (
              <div key={svc.serviceName} className="admin-card p-5">
                <div className="flex items-center gap-3 mb-3">
                  <span className={`w-2.5 h-2.5 rounded-full shrink-0 ${svc.status === 'Healthy' ? 'bg-green-500' : 'bg-red-500'}`} />
                  <h2 className="font-semibold">{svc.serviceName}</h2>
                  <span className={`ml-auto text-xs font-medium px-2 py-0.5 rounded ${
                    svc.status === 'Healthy'
                      ? 'bg-green-100 text-green-700'
                      : 'bg-red-100 text-red-700'
                  }`}>
                    {svc.status}
                  </span>
                </div>

                <p className="text-xs text-gray-500 mb-3">
                  {svc.healthyInstances} healthy / {svc.totalInstances} total instances
                </p>

                <div className="space-y-1">
                  {(svc.instances ?? []).map((inst) => (
                    <div key={inst.serviceId}
                      className="flex items-center gap-2 text-xs text-gray-600 bg-gray-50 rounded px-3 py-1.5"
                    >
                      <span className={`w-1.5 h-1.5 rounded-full ${inst.isHealthy ? 'bg-green-500' : 'bg-red-500'}`} />
                      <span className="font-mono">{inst.url}</span>
                      <span className="ml-auto text-gray-400">{inst.serviceId}</span>
                    </div>
                  ))}
                </div>
              </div>
            ))}
          </div>

          <p className="text-xs text-gray-400 mt-4">
            Last checked: {data.timestamp ? new Date(data.timestamp).toLocaleString() : '—'}
          </p>
        </>
      ) : null}
    </div>
  );
}
