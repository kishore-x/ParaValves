// Docker/self-host uses the standalone server; Vercel builds its own output.
// Set BUILD_TARGET=docker (the Dockerfile does) to emit .next/standalone.
const isDocker = process.env.BUILD_TARGET === 'docker';

/** @type {import('next').NextConfig} */
const nextConfig = {
  ...(isDocker ? { output: 'standalone' } : {}),
  reactStrictMode: true,
  poweredByHeader: false,
  serverExternalPackages: ['pg', 'pdfkit', 'nodemailer', '@electric-sql/pglite'],
  // pdfkit ships .afm metric files that aren't detected by static analysis —
  // include them so PDF generation works on serverless (Vercel) too.
  outputFileTracingIncludes: {
    // In-memory demo DB (PGlite) loads its WASM/extension bundles from disk at runtime.
    '/**': ['./node_modules/@electric-sql/pglite/dist/**'],
    '/api/invoices/**': ['./node_modules/pdfkit/js/data/**'],
    '/api/quotes/**': ['./node_modules/pdfkit/js/data/**'],
  },
  async headers() {
    // CSP is set per-request (with a nonce) in middleware.ts. These are the
    // static, non-nonce security headers.
    return [
      {
        source: '/:path*',
        headers: [
          { key: 'X-Content-Type-Options', value: 'nosniff' },
          { key: 'X-Frame-Options', value: 'DENY' },
          { key: 'Referrer-Policy', value: 'strict-origin-when-cross-origin' },
          { key: 'Permissions-Policy', value: 'camera=(), microphone=(), geolocation=()' },
          { key: 'Cross-Origin-Opener-Policy', value: 'same-origin' },
          { key: 'X-DNS-Prefetch-Control', value: 'off' },
        ],
      },
    ];
  },
};
export default nextConfig;
