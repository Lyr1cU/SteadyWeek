import { PlaceholderRoute } from '../../ui/placeholder-route';

export function CloseDayScreen({ onBack }: { onBack: () => void }) {
  return (
    <PlaceholderRoute
      title="Close day"
      subtitle="Will call evaluateDay + XP. Logic already lives in src/logic/."
      onBack={onBack}
    />
  );
}
