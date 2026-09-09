import { PlaceholderRoute } from '../../ui/placeholder-route';

export function ShopScreen({ onBack }: { onBack: () => void }) {
  return (
    <PlaceholderRoute
      title="Shop"
      subtitle="XP cosmetics only. No IAP."
      onBack={onBack}
    />
  );
}
