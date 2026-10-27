import { describe, it, expect } from 'vitest';
import { canTransition, ORDER, LEAD } from '../src/server/workflow/machines';

describe('state machines', () => {
  it('allows valid order transitions', () => {
    expect(canTransition(ORDER, 'CONFIRMED', 'ENGINEERING')).toBe(true);
    expect(canTransition(ORDER, 'ENGINEERING', 'DELIVERY')).toBe(false);
  });
  it('blocks invalid lead jumps', () => {
    expect(canTransition(LEAD, 'NEW', 'WON')).toBe(false);
    expect(canTransition(LEAD, 'QUOTATION', 'WON')).toBe(true);
  });
});
