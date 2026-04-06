import Sidebar from '@/components/Sidebar';

export default function DashboardLayout({ children }) {
  return (
    <div className="flex min-h-screen w-full flex-col bg-[var(--app-bg)] lg:flex-row">
      <Sidebar />
      <main className="min-w-0 flex-1 overflow-y-auto bg-transparent">
        <div className="min-h-full px-4 pb-8 pt-4 sm:px-6 lg:px-8 lg:pb-10 lg:pt-8">
          <div className="mx-auto w-full max-w-7xl">{children}</div>
        </div>
      </main>
    </div>
  );
}
