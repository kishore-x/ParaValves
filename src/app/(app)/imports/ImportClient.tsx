'use client';
import { useState, useTransition } from 'react';
import { Card, CardHeader, Button, Table, Th, Td, inputCls, Badge, EmptyState } from '@/components/ui';
import { Icon } from '@/components/icons';
import { previewAction, commitAction } from './actions';
import type { ImportEntity, PreviewResult } from '@/server/domain/imports';

const SAMPLES: Record<ImportEntity, string> = {
  companies: 'name,country,state_code,city,gstin,is_supplier\nOrient Valves,IN,27,Pune,27AAAAA0000A1Z5,no\nApex Castings,IN,29,Hubli,,yes',
  products: 'product_code,name,uom,material,hsn_sac,tax_rate,selling_price,standard_cost\nPV-CV-040,Check Valve 40mm SS316,NOS,SS316,84818090,18,1800,1000\nPV-BF-100,Butterfly Valve 100mm,NOS,CF8M,84818090,18,7200,4100',
  contacts: 'company_name,name,email,phone,designation\nABC Industries,Priya Nair,priya@abc.com,+91 90000 00000,Engineer',
};

export function ImportClient() {
  const [entity, setEntity] = useState<ImportEntity>('companies');
  const [csv, setCsv] = useState('');
  const [preview, setPreview] = useState<PreviewResult | null>(null);
  const [result, setResult] = useState<{ imported: number; skipped: number } | null>(null);
  const [pending, start] = useTransition();
  const [error, setError] = useState('');

  const onFile = (f: File) => { const r = new FileReader(); r.onload = () => setCsv(String(r.result)); r.readAsText(f); };
  const runPreview = () => { setError(''); setResult(null); start(async () => { try { setPreview(await previewAction(entity, csv)); } catch (e) { setError((e as Error).message); } }); };
  const runCommit = () => { setError(''); start(async () => { try { const r = await commitAction(entity, csv); setResult(r); setPreview(null); setCsv(''); } catch (e) { setError((e as Error).message); } }); };

  return (
    <div className="space-y-5">
      <Card>
        <CardHeader title="1 · Choose data & upload" subtitle="Paste CSV or upload a .csv file. Nothing is saved until you confirm." />
        <div className="space-y-4 p-5">
          <div className="flex flex-wrap items-center gap-2">
            {(['companies', 'products', 'contacts'] as ImportEntity[]).map((e) => (
              <button key={e} onClick={() => { setEntity(e); setPreview(null); setResult(null); }}
                className={`rounded-lg border px-3 py-1.5 text-sm capitalize ${entity === e ? 'border-brand bg-brand-wash text-brand' : 'border-line text-muted hover:text-ink'}`}>{e}</button>
            ))}
            <button onClick={() => setCsv(SAMPLES[entity])} className="ml-auto text-xs font-medium text-brand hover:underline">Load sample CSV</button>
          </div>
          <textarea value={csv} onChange={(e) => setCsv(e.target.value)} rows={7} placeholder={`Paste ${entity} CSV here…`} className={`${inputCls} h-auto py-2 font-mono text-xs`} />
          <div className="flex items-center gap-3">
            <label className="cursor-pointer">
              <span className="inline-flex h-9 items-center gap-1.5 rounded-lg border border-line px-3.5 text-sm text-ink hover:bg-bg"><Icon name="file" size={15} /> Upload .csv</span>
              <input type="file" accept=".csv,text/csv" className="hidden" onChange={(e) => e.target.files?.[0] && onFile(e.target.files[0])} />
            </label>
            <Button onClick={runPreview} disabled={!csv.trim() || pending}>{pending ? 'Validating…' : 'Validate & Preview'}</Button>
          </div>
          {error && <p className="rounded-lg bg-danger-wash px-3 py-2 text-sm text-danger">{error}</p>}
        </div>
      </Card>

      {result && (
        <Card>
          <div className="flex items-center gap-3 p-5">
            <div className="flex h-10 w-10 items-center justify-center rounded-full bg-ok-wash text-ok"><Icon name="check" size={20} /></div>
            <div><p className="font-medium text-ink">Import complete</p><p className="text-sm text-muted">{result.imported} imported · {result.skipped} skipped</p></div>
          </div>
        </Card>
      )}

      {preview && (
        <Card>
          <CardHeader
            title="2 · Preview & confirm"
            subtitle={`${preview.okCount} valid · ${preview.errorCount} with issues`}
            action={<Button onClick={runCommit} disabled={preview.okCount === 0 || pending} icon="check">{pending ? 'Importing…' : `Import ${preview.okCount} rows`}</Button>}
          />
          {preview.rows.length === 0 ? <EmptyState title="No rows found" /> : (
            <Table>
              <thead><tr><Th>#</Th>{preview.headers.map((h) => <Th key={h}>{h}</Th>)}<Th>Status</Th></tr></thead>
              <tbody>
                {preview.rows.map((r) => (
                  <tr key={r.row} className={r.ok ? '' : 'bg-danger-wash/40'}>
                    <Td className="text-faint">{r.row}</Td>
                    {preview.headers.map((h) => <Td key={h} className="max-w-[160px] truncate">{r.data[h] || '—'}</Td>)}
                    <Td>{r.ok ? <Badge tone="ok">OK</Badge> : <span title={r.errors.join('; ')}><Badge tone="danger">{r.errors[0]}</Badge></span>}</Td>
                  </tr>
                ))}
              </tbody>
            </Table>
          )}
        </Card>
      )}
    </div>
  );
}
