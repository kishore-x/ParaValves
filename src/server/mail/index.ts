import 'server-only';
import { query, type TxClient } from '@/server/db';
import { env } from '@/server/env';

export interface MailInput {
  orgId?: string | null;
  to: string;
  subject: string;
  event: string;
  body: string;
}

/**
 * Email abstraction. MAIL_DRIVER=log (default) records to email_log and console;
 * MAIL_DRIVER=smtp sends via nodemailer. Every send is logged with status.
 */
export async function sendMail(input: MailInput, client?: TxClient): Promise<void> {
  const runner = client ?? { query: (t: string, p: unknown[]) => query(t, p) };
  const logId = await recordQueued(runner, input);

  if (env.MAIL_DRIVER === 'smtp' && process.env.SMTP_HOST) {
    try {
      const nodemailer = await import('nodemailer');
      const transport = nodemailer.createTransport({
        host: process.env.SMTP_HOST,
        port: process.env.SMTP_PORT?.trim() ? Number(process.env.SMTP_PORT) : 587,
        secure: (process.env.SMTP_SECURE ?? 'false') === 'true',
        auth: process.env.SMTP_USER ? { user: process.env.SMTP_USER, pass: process.env.SMTP_PASS } : undefined,
      });
      await transport.sendMail({ from: process.env.MAIL_FROM ?? 'no-reply@paravalves.com', to: input.to, subject: input.subject, text: input.body });
      await mark(runner, logId, 'sent', null);
    } catch (e) {
      await mark(runner, logId, 'failed', (e as Error).message);
    }
    return;
  }
  // log driver
  console.log(`[mail:log] → ${input.to} | ${input.subject}`);
  await mark(runner, logId, 'sent', null);
}

async function recordQueued(runner: { query: (t: string, p: unknown[]) => Promise<unknown> }, input: MailInput): Promise<number> {
  const rows = (await runner.query(
    `insert into email_log (org_id, recipient, subject, event, status) values ($1,$2,$3,$4,'queued') returning id`,
    [input.orgId ?? null, input.to, input.subject, input.event],
  )) as { id: number }[];
  return rows[0]!.id;
}
async function mark(runner: { query: (t: string, p: unknown[]) => Promise<unknown> }, id: number, status: string, error: string | null) {
  await runner.query(`update email_log set status=$1, error=$2, sent_at=case when $1='sent' then now() else sent_at end where id=$3`, [status, error, id]);
}

// ── templates ──────────────────────────────────────────────────────────────
export const templates = {
  quoteSent: (num: string, company: string, total: string) => ({
    subject: `Quotation ${num} from Paravalves`,
    body: `Dear ${company},\n\nPlease find our quotation ${num} for a total of ${total}.\nThis quote is valid as per the terms stated in the document.\n\nRegards,\nParavalves — When everything flows, everything works.`,
  }),
  orderConfirmed: (num: string, company: string) => ({
    subject: `Order ${num} confirmed`,
    body: `Dear ${company},\n\nYour order ${num} has been confirmed and is now in progress. We will keep you updated at each stage.\n\nRegards,\nParavalves`,
  }),
  invoiceIssued: (num: string, company: string, total: string, due: string) => ({
    subject: `Invoice ${num} from Paravalves`,
    body: `Dear ${company},\n\nInvoice ${num} for ${total} has been issued. Payment is due by ${due}.\n\nRegards,\nParavalves Accounts`,
  }),
  poSent: (num: string, supplier: string) => ({
    subject: `Purchase Order ${num} from Paravalves`,
    body: `Dear ${supplier},\n\nPlease find our purchase order ${num}. Kindly confirm acceptance and expected dispatch date.\n\nRegards,\nParavalves Procurement`,
  }),
  paymentReminder: (num: string, company: string, balance: string) => ({
    subject: `Payment reminder — Invoice ${num}`,
    body: `Dear ${company},\n\nThis is a reminder that invoice ${num} has an outstanding balance of ${balance}. Please arrange payment at your earliest convenience.\n\nRegards,\nParavalves Accounts`,
  }),
};
