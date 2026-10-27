import { SkeletonStats, SkeletonTable, Skeleton } from '@/components/ui';

export default function Loading() {
  return (
    <div>
      <div className="mb-6 flex items-end justify-between">
        <div><Skeleton className="h-6 w-48" /><Skeleton className="mt-2 h-4 w-64" /></div>
        <Skeleton className="h-9 w-32 rounded-lg" />
      </div>
      <div className="mb-6"><SkeletonStats n={4} /></div>
      <SkeletonTable rows={7} cols={5} />
    </div>
  );
}
