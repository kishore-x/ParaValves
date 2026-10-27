/**
 * Real industrial photos (royalty-free, stored in /public/images) used across the
 * dashboard — hero, list thumbnails, action cards, sidebar card.
 */
const SRC = {
  hero: '/images/hero.jpg',
  'card-quote': '/images/card-quote.jpg',
  'card-drawings': '/images/card-drawings.jpg',
  'card-inventory': '/images/card-inventory.jpg',
  valve: '/images/thumb-valve.jpg',
  sparks: '/images/thumb-sparks.jpg',
  blueprint: '/images/thumb-blueprint.jpg',
  warehouse: '/images/thumb-warehouse.jpg',
  plant: '/images/thumb-plant.jpg',
} as const;

export type PhotoName = keyof typeof SRC;

export function Photo({ name, className = '', alt = '' }: { name: PhotoName; className?: string; alt?: string }) {
  // eslint-disable-next-line @next/next/no-img-element
  return <img src={SRC[name]} alt={alt} loading="lazy" decoding="async" className={`object-cover ${className}`} />;
}
