import { NextResponse, type NextRequest } from 'next/server';

/**
 * Per-request nonce-based CSP.
 * - Production: strict — script-src 'self' 'nonce-…' 'strict-dynamic', NO unsafe-eval/inline.
 * - Development: Next's HMR/runtime needs eval + inline + ws, so we relax there only.
 * Next.js reads the nonce from this header and stamps it on its own <script> tags.
 */
export function middleware(req: NextRequest) {
  const isDev = process.env.NODE_ENV !== 'production';
  // Edge-runtime safe (no Buffer): Web Crypto + btoa, works on Vercel Edge & Node.
  const nonce = btoa(crypto.randomUUID());

  const scriptSrc = isDev
    ? "script-src 'self' 'unsafe-inline' 'unsafe-eval'"
    : `script-src 'self' 'nonce-${nonce}' 'strict-dynamic'`;
  const connectSrc = isDev ? "connect-src 'self' ws: wss:" : "connect-src 'self'";

  // Only upgrade insecure requests when actually served over HTTPS — on plain
  // http:// (local prod smoke tests, internal networks) it rewrites same-host
  // URLs to https and breaks them.
  const isHttps = req.headers.get('x-forwarded-proto') === 'https' || req.nextUrl.protocol === 'https:';

  const csp = [
    "default-src 'self'",
    scriptSrc,
    "style-src 'self' 'unsafe-inline'",
    "img-src 'self' data: blob:",
    "font-src 'self' data:",
    connectSrc,
    "frame-ancestors 'none'",
    "object-src 'none'",
    "base-uri 'self'",
    "form-action 'self'",
    ...(isHttps ? ['upgrade-insecure-requests'] : []),
  ].join('; ');

  const requestHeaders = new Headers(req.headers);
  requestHeaders.set('x-nonce', nonce);
  requestHeaders.set('content-security-policy', csp);

  const res = NextResponse.next({ request: { headers: requestHeaders } });
  res.headers.set('content-security-policy', csp);
  return res;
}

export const config = {
  // apply to all routes except static assets & the image optimizer
  matcher: [{ source: '/((?!_next/static|_next/image|favicon.ico).*)' }],
};
