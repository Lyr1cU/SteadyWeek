import { PlaceholderRoute } from '../../ui/placeholder-route';

export function ShopScreen({ onBack }: { onBack: () => void }) {
  return (
    <PlaceholderRoute
      title="Shop"
      subtitle="Store soon · XP cosmetics only. No IAP."
      onBack={onBack}
    />
  );
}
