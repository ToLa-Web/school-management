'use client';
import { useAuth } from '@/lib/auth';

export default function TeacherLayout({ children }) {
  useAuth([1]); // Only Teacher
  return <>{children}</>;
}
