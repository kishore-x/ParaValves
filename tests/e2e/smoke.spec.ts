import { test, expect } from '@playwright/test';

test('login and reach the dashboard', async ({ page }) => {
  await page.goto('/login');
  await expect(page.getByRole('heading', { name: 'Sign in' })).toBeVisible();
  await page.fill('input[name="email"]', 'admin@paravalves.com');
  await page.fill('input[name="password"]', 'admin123');
  await page.getByRole('button', { name: 'Sign in' }).click();
  await page.waitForURL('**/dashboard');
  await expect(page.getByText('Attention Required')).toBeVisible();
});

test('navigate to inventory shows stock intelligence', async ({ page }) => {
  await page.goto('/login');
  await page.fill('input[name="email"]', 'admin@paravalves.com');
  await page.fill('input[name="password"]', 'admin123');
  await page.getByRole('button', { name: 'Sign in' }).click();
  await page.waitForURL('**/dashboard');
  await page.goto('/inventory');
  await expect(page.getByText('Stock levels')).toBeVisible();
});

test('theme toggle switches to dark and persists', async ({ page }) => {
  await page.goto('/login');
  await page.fill('input[name="email"]', 'admin@paravalves.com');
  await page.fill('input[name="password"]', 'admin123');
  await page.getByRole('button', { name: 'Sign in' }).click();
  await page.waitForURL('**/dashboard');
  await page.getByRole('button', { name: 'Toggle theme' }).click();
  await expect(page.locator('html')).toHaveAttribute('data-theme', 'dark');
  await page.reload();
  await expect(page.locator('html')).toHaveAttribute('data-theme', 'dark');
});

test('unauthenticated user is redirected to login', async ({ page }) => {
  await page.context().clearCookies();
  await page.goto('/orders');
  await page.waitForURL('**/login');
  await expect(page.getByRole('heading', { name: 'Sign in' })).toBeVisible();
});
