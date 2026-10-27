import { SkeletonStats, Skeleton, Card } from '@/components/ui';

export default function Loading() {
  return (
    <div>
      <div className="mb-6"><Skeleton className="h-7 w-56" /><Skeleton className="mt-2 h-4 w-72" /></div>
      <div className="mb-6"><SkeletonStats n={6} /></div>
      <div className="grid gap-5 lg:grid-cols-2">
        {[0, 1].map((i) => (
          <Card key={i}>
            <div className="border-b border-line px-5 py-4"><Skeleton className="h-4 w-40" /></div>
            <div className="space-y-3 p-5">
              {Array.from({ length: 5 }).map((_, r) => <Skeleton key={r} className="h-9 w-full" />)}
            </div>
          </Card>
        ))}
      </div>
    </div>
  );
}
