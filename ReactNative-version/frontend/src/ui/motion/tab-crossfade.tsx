import type { ReactNode } from 'react';
import Animated, { FadeOut, SlideInLeft, SlideInRight } from 'react-native-reanimated';
import { shellTabs, type ShellTab } from '../../app/routes';
import { durationTab, motionDuration } from './constants';
import { useReduceMotion } from './use-reduce-motion';

export function TabCrossfade({
  tab,
  prevTab,
  children,
}: {
  tab: ShellTab;
  prevTab: ShellTab | null;
  children: ReactNode;
}) {
  const reduceMotion = useReduceMotion();
  const duration = motionDuration(durationTab, reduceMotion);
  const nextIndex = shellTabs.indexOf(tab);
  const prevIndex = prevTab != null ? shellTabs.indexOf(prevTab) : nextIndex;
  const slideFromRight = nextIndex >= prevIndex;

  if (reduceMotion) {
    return <>{children}</>;
  }

  const entering = slideFromRight
    ? SlideInRight.duration(duration)
    : SlideInLeft.duration(duration);

  return (
    <Animated.View
      key={tab}
      style={{ flex: 1 }}
      entering={entering}
      exiting={FadeOut.duration(motionDuration(120, reduceMotion))}
    >
      {children}
    </Animated.View>
  );
}
