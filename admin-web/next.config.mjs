/** @type {import('next').NextConfig} */
const nextConfig = {
  async rewrites() {
    // Inside Docker: API_URL=http://api-gateway:8080
    // Local dev without Docker: API_URL=http://localhost:5001
    const apiBase = process.env.API_URL ?? 'http://localhost:5001';
    return [
      {
        source: '/api/:path*',
        destination: `${apiBase}/api/:path*`,
      },
    ];
  },
};

export default nextConfig;
