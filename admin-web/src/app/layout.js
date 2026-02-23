import './globals.css';
import Sidebar from '@/components/Sidebar';

export const metadata = {
  title: 'School Admin',
  description: 'School Management Admin Panel',
};

export default function RootLayout({ children }) {
  return (
    <html lang="en">
      <body className="flex h-screen bg-gray-100 text-gray-800">
        <Sidebar />
        <main className="flex-1 overflow-y-auto p-8">{children}</main>
      </body>
    </html>
  );
}
