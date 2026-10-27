import 'server-only';
import PDFDocument from 'pdfkit';

const CORAL = '#FF2C4D';
const INK = '#212529';
const MUTED = '#666666';
const LINE = '#E2DFDC';

function money(v: unknown, currency = 'INR'): string {
  const n = Number(v ?? 0);
  const sym = currency === 'INR' ? 'Rs. ' : currency === 'EUR' ? 'EUR ' : currency === 'USD' ? '$' : '';
  return `${sym}${n.toLocaleString('en-IN', { minimumFractionDigits: 2, maximumFractionDigits: 2 })}`;
}
function d(v: unknown): string { return v ? new Date(v as string).toLocaleDateString('en-GB', { day: '2-digit', month: 'short', year: 'numeric' }) : '—'; }

interface Party { name?: string; gstin?: string; address?: string; city?: string; state_code?: string; country?: string; }
interface Line { description: string; quantity: unknown; unit_price: unknown; tax_rate?: unknown; line_total: unknown; hsn_sac?: string | null; }
export interface DocData {
  kind: 'INVOICE' | 'QUOTATION';
  number: string;
  date?: unknown;
  dueDate?: unknown;
  validUntil?: unknown;
  currency?: string;
  status?: string;
  org: Party;
  party: Party;
  lines: Line[];
  subtotal: unknown;
  discountTotal?: unknown;
  taxTotal?: unknown;
  cgst?: unknown; sgst?: unknown; igst?: unknown; roundOff?: unknown;
  grandTotal: unknown;
  paidAmount?: unknown;
  isExport?: boolean;
  notes?: string | null;
  placeOfSupply?: string | null;
}

export function buildPdf(data: DocData): Promise<Buffer> {
  return new Promise((resolve, reject) => {
    const doc = new PDFDocument({ size: 'A4', margin: 48 });
    const chunks: Buffer[] = [];
    doc.on('data', (c) => chunks.push(c as Buffer));
    doc.on('end', () => resolve(Buffer.concat(chunks)));
    doc.on('error', reject);

    const cur = data.currency ?? 'INR';
    const W = doc.page.width, M = 48, right = W - M;
    const title = data.kind === 'INVOICE' ? (data.isExport ? 'EXPORT INVOICE' : 'TAX INVOICE') : 'QUOTATION';

    // ── Header ───────────────────────────────────────────────────────────
    doc.fillColor(INK).font('Helvetica-Bold').fontSize(22).text('para', M, 44, { continued: true });
    doc.fillColor(CORAL).text('v', { continued: true });
    doc.fillColor(INK).text('alves');
    doc.font('Helvetica').fontSize(8).fillColor(MUTED).text('Industrial valve manufacturers', M, 70);

    doc.font('Helvetica-Bold').fontSize(18).fillColor(CORAL).text(title, M, 44, { width: right - M, align: 'right' });
    doc.font('Helvetica').fontSize(10).fillColor(INK).text(data.number, M, 68, { width: right - M, align: 'right' });

    // ── Org / party blocks ───────────────────────────────────────────────
    let y = 104;
    doc.moveTo(M, y).lineTo(right, y).strokeColor(LINE).lineWidth(1).stroke();
    y += 14;
    const colW = (right - M - 20) / 2;
    doc.font('Helvetica-Bold').fontSize(8).fillColor(MUTED).text('FROM', M, y);
    doc.font('Helvetica-Bold').fontSize(11).fillColor(INK).text(data.org.name ?? 'Paravalves', M, y + 12);
    doc.font('Helvetica').fontSize(9).fillColor(MUTED);
    let oy = y + 28;
    if (data.org.gstin) { doc.text(`GSTIN: ${data.org.gstin}`, M, oy); oy += 12; }
    if (data.org.state_code) { doc.text(`State code: ${data.org.state_code}`, M, oy); oy += 12; }

    const bx = M + colW + 20;
    doc.font('Helvetica-Bold').fontSize(8).fillColor(MUTED).text(data.kind === 'INVOICE' ? 'BILL TO' : 'TO', bx, y);
    doc.font('Helvetica-Bold').fontSize(11).fillColor(INK).text(data.party.name ?? '—', bx, y + 12, { width: colW });
    doc.font('Helvetica').fontSize(9).fillColor(MUTED);
    let py = y + 28;
    if (data.party.gstin) { doc.text(`GSTIN: ${data.party.gstin}`, bx, py, { width: colW }); py += 12; }
    if (data.party.city || data.party.state_code) { doc.text([data.party.city, data.party.state_code].filter(Boolean).join(', '), bx, py, { width: colW }); py += 12; }

    // meta row
    y = Math.max(oy, py) + 10;
    doc.font('Helvetica').fontSize(9).fillColor(MUTED);
    const metas: [string, string][] = data.kind === 'INVOICE'
      ? [['Invoice date', d(data.date)], ['Due date', d(data.dueDate)], ['Place of supply', data.placeOfSupply ?? '—']]
      : [['Date', d(data.date)], ['Valid until', d(data.validUntil)], ['Currency', cur]];
    let mx = M;
    for (const [k, v] of metas) {
      doc.fillColor(MUTED).text(k + ':', mx, y);
      doc.fillColor(INK).text(v, mx + 70, y);
      y += 14;
    }

    // ── Line items table ─────────────────────────────────────────────────
    y += 8;
    const cols = { desc: M, qty: right - 230, rate: right - 160, tax: right - 90, total: right };
    doc.rect(M, y, right - M, 20).fill('#F6F5F4');
    doc.font('Helvetica-Bold').fontSize(8).fillColor(MUTED);
    doc.text('DESCRIPTION', cols.desc + 6, y + 6);
    doc.text('QTY', cols.qty, y + 6, { width: 40, align: 'right' });
    doc.text('RATE', cols.rate, y + 6, { width: 55, align: 'right' });
    doc.text('TAX%', cols.tax, y + 6, { width: 45, align: 'right' });
    doc.text('AMOUNT', cols.total - 70, y + 6, { width: 70, align: 'right' });
    y += 24;

    doc.font('Helvetica').fontSize(9).fillColor(INK);
    for (const l of data.lines) {
      const h = Math.max(16, doc.heightOfString(l.description, { width: cols.qty - cols.desc - 12 }));
      if (y + h > doc.page.height - 120) { doc.addPage(); y = 60; }
      doc.fillColor(INK).text(l.description, cols.desc + 6, y, { width: cols.qty - cols.desc - 12 });
      doc.text(String(Number(l.quantity)), cols.qty, y, { width: 40, align: 'right' });
      doc.text(money(l.unit_price, cur), cols.rate, y, { width: 55, align: 'right' });
      doc.text(l.tax_rate != null ? `${Number(l.tax_rate)}%` : '—', cols.tax, y, { width: 45, align: 'right' });
      doc.text(money(l.line_total, cur), cols.total - 70, y, { width: 70, align: 'right' });
      y += h + 8;
      doc.moveTo(M, y - 4).lineTo(right, y - 4).strokeColor(LINE).lineWidth(0.5).stroke();
    }

    // ── Totals ───────────────────────────────────────────────────────────
    y += 8;
    const tx = right - 200, tvx = right;
    const rowR = (label: string, val: string, bold = false) => {
      doc.font(bold ? 'Helvetica-Bold' : 'Helvetica').fontSize(bold ? 11 : 9).fillColor(bold ? INK : MUTED);
      doc.text(label, tx, y, { width: 110, align: 'left' });
      doc.fillColor(INK).text(val, tvx - 110, y, { width: 110, align: 'right' });
      y += bold ? 20 : 15;
    };
    rowR('Subtotal', money(data.subtotal, cur));
    if (Number(data.discountTotal) > 0) rowR('Discount', '- ' + money(data.discountTotal, cur));
    if (Number(data.cgst) > 0) rowR('CGST', money(data.cgst, cur));
    if (Number(data.sgst) > 0) rowR('SGST', money(data.sgst, cur));
    if (Number(data.igst) > 0) rowR('IGST', money(data.igst, cur));
    if (data.kind === 'QUOTATION' && Number(data.taxTotal) > 0) rowR('Tax', money(data.taxTotal, cur));
    if (Number(data.roundOff) !== 0 && data.roundOff != null) rowR('Round off', money(data.roundOff, cur));
    doc.moveTo(tx, y).lineTo(right, y).strokeColor(CORAL).lineWidth(1.5).stroke(); y += 6;
    rowR('Grand Total', money(data.grandTotal, cur), true);
    if (data.kind === 'INVOICE' && data.paidAmount != null) {
      rowR('Paid', money(data.paidAmount, cur));
      rowR('Balance due', money(Number(data.grandTotal) - Number(data.paidAmount), cur));
    }

    // ── Notes + footer ───────────────────────────────────────────────────
    if (data.notes) {
      y += 16; doc.font('Helvetica-Bold').fontSize(8).fillColor(MUTED).text('NOTES', M, y);
      doc.font('Helvetica').fontSize(9).fillColor(INK).text(data.notes, M, y + 12, { width: right - M - 210 });
    }
    const fy = doc.page.height - 82;
    doc.moveTo(M, fy).lineTo(right, fy).strokeColor(LINE).lineWidth(0.5).stroke();
    doc.font('Helvetica').fontSize(8).fillColor(MUTED).text(
      'Paravalves - When everything flows, everything works.  |  This is a computer-generated document.',
      M, fy + 8, { width: right - M, align: 'center', lineBreak: false });

    doc.end();
  });
}
