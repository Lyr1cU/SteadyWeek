import { PlaceholderRoute } from '../../ui/placeholder-route';

export function WeeklyReportScreen({ onBack }: { onBack: () => void }) {
  return (
    <PlaceholderRoute
      title="Weekly report"
      subtitle="Aggregates + reflection notes."
      onBack={onBack}
    />
  );
}
