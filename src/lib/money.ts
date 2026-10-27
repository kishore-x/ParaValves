import Decimal from 'decimal.js';

Decimal.set({ rounding: Decimal.ROUND_HALF_UP });

export function d(v: unknown): Decimal {
  if (v === null || v === undefined || v === '') return new Decimal(0);
  return new Decimal(v as Decimal.Value);
}

export function round2(v: Decimal): number {
  return Number(v.toDecimalPlaces(2).toFixed(2));
}

export interface LineInput {
  quantity: number | string;
  unit_price: number | string;
  discount_pct?: number | string;
  tax_rate?: number | string;
}

export interface ComputedLine {
  gross: number;
  discount: number;
  taxable: number;
  tax: number;
  total: number;
}

/** Deterministic server-side line computation. Never trust browser totals. */
export function computeLine(l: LineInput): ComputedLine {
  const qty = d(l.quantity);
  const price = d(l.unit_price);
  const discPct = d(l.discount_pct ?? 0);
  const taxRate = d(l.tax_rate ?? 0);

  const gross = qty.mul(price);
  const discount = gross.mul(discPct).div(100);
  const taxable = gross.minus(discount);
  const tax = taxable.mul(taxRate).div(100);
  const total = taxable.plus(tax);

  return {
    gross: round2(gross),
    discount: round2(discount),
    taxable: round2(taxable),
    tax: round2(tax),
    total: round2(total),
  };
}

export interface DocTotals {
  subtotal: number;
  discount_total: number;
  tax_total: number;
  grand_total: number;
  lines: ComputedLine[];
}

export function computeTotals(lines: LineInput[]): DocTotals {
  const computed = lines.map(computeLine);
  const subtotal = computed.reduce((a, l) => a.plus(l.gross), new Decimal(0));
  const discount = computed.reduce((a, l) => a.plus(l.discount), new Decimal(0));
  const tax = computed.reduce((a, l) => a.plus(l.tax), new Decimal(0));
  const grand = computed.reduce((a, l) => a.plus(l.total), new Decimal(0));
  return {
    subtotal: round2(subtotal),
    discount_total: round2(discount),
    tax_total: round2(tax),
    grand_total: round2(grand),
    lines: computed,
  };
}

export function formatMoney(v: number | string, currency = 'INR'): string {
  const n = Number(v);
  const symbol = currency === 'INR' ? '₹' : currency === 'EUR' ? '€' : currency === 'USD' ? '$' : '';
  return `${symbol}${n.toLocaleString('en-IN', { minimumFractionDigits: 2, maximumFractionDigits: 2 })}`;
}
