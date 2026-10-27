import { test, expect } from '@playwright/test';

test('kanban drag persists the stage change', async ({ page }) => {
  const errors: string[] = [];
  page.on('console', (m) => { if (m.type() === 'error') errors.push(m.text().slice(0, 200)); });

  await page.goto('/login');
  await page.fill('input[name="email"]', 'admin@paravalves.com');
  await page.fill('input[name="password"]', 'admin123');
  await page.getByRole('button', { name: 'Sign in' }).click();
  await page.waitForURL('**/dashboard');

  await page.goto('/leads/board');
  const card = page.locator('[draggable="true"]').filter({ hasText: 'Coastal Power' });
  await expect(card).toBeVisible();

  const qualifiedCol = page.locator('div.w-64').filter({ hasText: 'QUALIFIED' }).first();
  await card.dragTo(qualifiedCol);
  await page.waitForTimeout(2500);

  // any error toast?
  const toast = page.locator('div.bg-danger');
  if (await toast.count()) console.log('TOAST:', await toast.first().textContent());
  console.log('CONSOLE ERRORS:', errors.filter(e => !e.includes('hydrat')).slice(0, 3));

  // reload — the real test of persistence
  await page.reload();
  const qualifiedAfter = page.locator('div.w-64').filter({ hasText: 'QUALIFIED' }).first();
  await expect(qualifiedAfter).toContainText('Coastal Power');
});
