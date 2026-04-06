'use client';
import { useAuth } from '@/lib/auth';

export default function StudentLayout({ children }) {
  useAuth([2]); // Only Student
  return <>{children}</>;
}
