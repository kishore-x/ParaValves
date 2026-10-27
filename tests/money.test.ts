import { describe, it, expect } from 'vitest';
import { computeLine, computeTotals } from '../src/lib/money';

describe('money engine', () => {
  it('computes a line with discount and tax deterministically', () => {
    const l = computeLine({ quantity: 15, unit_price: 2100, discount_pct: 10, tax_rate: 18 });
    // gross 31500, discount 3150, taxable 28350, tax 5103, total 33453
    expect(l.gross).toBe(31500);
    expect(l.discount).toBe(3150);
    expect(l.taxable).toBe(28350);
    expect(l.tax).toBe(5103);
    expect(l.total).toBe(33453);
  });
  it('sums document totals', () => {
    const t = computeTotals([
      { quantity: 2, unit_price: 100, tax_rate: 18 },
      { quantity: 1, unit_price: 50, tax_rate: 18 },
    ]);
    expect(t.subtotal).toBe(250);
    expect(t.tax_total).toBe(45);
    expect(t.grand_total).toBe(295);
  });
  it('never loses precision on thirds', () => {
    const l = computeLine({ quantity: 3, unit_price: 33.33, tax_rate: 0 });
    expect(l.total).toBe(99.99);
  });
});
