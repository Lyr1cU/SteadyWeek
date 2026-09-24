import type { ReactNode } from 'react';
import Animated, { FadeInDown, FadeOut } from 'react-native-reanimated';
import { durationTab, motionDuration, staggerDelay } from './constants';
import { useReduceMotion } from './use-reduce-motion';

export function StaggerFadeIn({
  index,
  children,
}: {
  index: number;
  children: ReactNode;
}) {
  const reduceMotion = useReduceMotion();
  const delay = staggerDelay(index, reduceMotion);
  const duration = motionDuration(durationTab, reduceMotion);

  if (reduceMotion) {
    return <>{children}</>;
  }

  return (
    <Animated.View
      entering={FadeInDown.duration(duration).delay(delay)}
      exiting={FadeOut.duration(motionDuration(150, reduceMotion))}
    >
      {children}
    </Animated.View>
  );
}
