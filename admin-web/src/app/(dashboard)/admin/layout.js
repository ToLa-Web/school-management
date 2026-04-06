'use client';
import { useAuth } from '@/lib/auth';

export default function AdminLayout({ children }) {
  useAuth([4]); // Only Admin
  return <>{children}</>;
}
