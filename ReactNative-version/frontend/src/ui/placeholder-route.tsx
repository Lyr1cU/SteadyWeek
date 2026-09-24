import type { ReactNode } from 'react';
import { PlaceholderScreen } from './placeholder-screen';
import { ScreenRoot } from './screen-root';

/** Extra routes that are still placeholders (close day, shop, …). */
export function PlaceholderRoute({
  title,
  subtitle,
  onBack,
  embedded,
  children,
}: {
  title: string;
  subtitle: string;
  onBack?: () => void;
  embedded?: boolean;
  children?: ReactNode;
}) {
  return (
    <ScreenRoot embedded={embedded}>
      <PlaceholderScreen title={title} subtitle={subtitle} onBack={onBack} />
      {children}
    </ScreenRoot>
  );
}
