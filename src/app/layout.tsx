import './globals.css';
import type { Metadata } from 'next';
import type { ReactNode } from 'react';
import { headers } from 'next/headers';
import { Inter, JetBrains_Mono, Jost } from 'next/font/google';

const inter = Inter({ subsets: ['latin'], variable: '--font-sans', display: 'swap' });
const mono = JetBrains_Mono({ subsets: ['latin'], variable: '--font-mono', display: 'swap' });
// Jost — geometric sans closest to Paravalves' Avant Garde Gothic wordmark
const jost = Jost({ subsets: ['latin'], variable: '--font-brand', display: 'swap', weight: ['500', '600'] });

export const metadata: Metadata = {
  title: 'Paravalves Platform',
  description: 'Unified ERP + CRM + Engineering + Inventory + Procurement + Projects + Finance',
};

const noFlashScript = `(function(){try{var t=localStorage.getItem('pv-theme')||'light';var d=document.documentElement;if(t==='system'){d.removeAttribute('data-theme');}else{d.setAttribute('data-theme',t);}}catch(e){document.documentElement.setAttribute('data-theme','light');}})();`;

export default async function RootLayout({ children }: { children: ReactNode }) {
  const nonce = (await headers()).get('x-nonce') ?? undefined;
  return (
    <html lang="en" className={`${inter.variable} ${mono.variable} ${jost.variable}`} data-theme="light" suppressHydrationWarning>
      <head>
        {/* React strips `nonce` from the client tree for security, so the SSR'd
            value never matches on hydration — suppress that specific warning. */}
        <script nonce={nonce} suppressHydrationWarning dangerouslySetInnerHTML={{ __html: noFlashScript }} />
      </head>
      <body>{children}</body>
    </html>
  );
}
