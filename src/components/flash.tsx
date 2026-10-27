export function Flash({ error, ok }: { error?: string; ok?: string }) {
  if (!error && !ok) return null;
  const bad = !!error;
  return (
    <div role={bad ? 'alert' : 'status'} className={`mb-4 rounded-lg border px-4 py-3 text-sm ${bad ? 'border-red-200 bg-red-50 text-red-800' : 'border-emerald-200 bg-emerald-50 text-emerald-800'}`}>
      {bad ? '⛔ ' : '✓ '}{error ?? ok}
    </div>
  );
}
