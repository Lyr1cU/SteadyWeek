import type { ReactNode } from 'react';
import { StyleSheet, View } from 'react-native';
import Animated, { SlideInLeft, SlideInRight, SlideOutLeft, SlideOutRight } from 'react-native-reanimated';
import { durationScreen, motionDuration } from './constants';
import { useReduceMotion } from './use-reduce-motion';

export function RouteSlide({
  routeKey,
  direction,
  children,
}: {
  routeKey: string;
  direction: 'push' | 'pop';
  children: ReactNode;
}) {
  const reduceMotion = useReduceMotion();
  const duration = motionDuration(durationScreen, reduceMotion);

  if (reduceMotion) {
    return <View style={styles.fill}>{children}</View>;
  }

  const entering =
    direction === 'push' ? SlideInRight.duration(duration) : SlideInLeft.duration(duration);
  const exiting =
    direction === 'push'
      ? SlideOutLeft.duration(motionDuration(220, reduceMotion))
      : SlideOutRight.duration(motionDuration(220, reduceMotion));

  return (
    <View style={styles.fill}>
      <Animated.View key={routeKey} style={styles.layer} entering={entering} exiting={exiting}>
        {children}
      </Animated.View>
    </View>
  );
}

const styles = StyleSheet.create({
  fill: { flex: 1 },
  layer: { ...StyleSheet.absoluteFill },
});
