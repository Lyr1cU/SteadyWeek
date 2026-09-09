import type { ReactNode } from 'react';
import { AppBackground } from './app-background';
import { PlaceholderScreen } from './placeholder-screen';

/** Extra routes that are still placeholders (close day, shop, …). */
export function PlaceholderRoute({
  title,
  subtitle,
  onBack,
  children,
}: {
  title: string;
  subtitle: string;
  onBack?: () => void;
  children?: ReactNode;
}) {
  return (
    <AppBackground>
      <PlaceholderScreen title={title} subtitle={subtitle} onBack={onBack} />
      {children}
    </AppBackground>
  );
}
