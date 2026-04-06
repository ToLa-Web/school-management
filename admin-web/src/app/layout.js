import './globals.css';

export const metadata = {
  title: 'School Admin',
  description: 'School Management Admin Panel',
};

export default function RootLayout({ children }) {
  return (
    <html lang="en">
      <body className="min-h-screen bg-[var(--app-bg)] text-[var(--app-text)] antialiased">
        {children}
      </body>
    </html>
  );
}
