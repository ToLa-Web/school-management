import './globals.css';
import Sidebar from '@/components/Sidebar';

export const metadata = {
  title: 'School Admin',
  description: 'School Management Admin Panel',
};

export default function RootLayout({ children }) {
  return (
    <html lang="en">
      <body className="flex h-screen overflow-hidden bg-slate-50 text-slate-800 antialiased">
        <Sidebar />
        <main className="flex-1 overflow-y-auto">
          <div className="w-full h-full">{children}</div>
        </main>
      </body>
    </html>
  );
}
