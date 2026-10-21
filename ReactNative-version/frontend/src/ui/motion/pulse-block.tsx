import { useEffect } from 'react';
import { type StyleProp, type ViewStyle } from 'react-native';
import Animated, {
  Easing,
  useAnimatedStyle,
  useSharedValue,
  withRepeat,
  withTiming,
} from 'react-native-reanimated';
import { useReduceMotion } from './use-reduce-motion';

const PULSE_EASE = Easing.inOut(Easing.quad);

/** Soft opacity pulse for placeholder blocks. Stays still when motion is reduced. */
export function PulseBlock({ style }: { style?: StyleProp<ViewStyle> }) {
  const reduceMotion = useReduceMotion();
  const opacity = useSharedValue(reduceMotion ? 0.45 : 0.35);

  useEffect(() => {
    if (reduceMotion) {
      opacity.value = 0.45;
      return;
    }
    opacity.value = withRepeat(withTiming(0.72, { duration: 700, easing: PULSE_EASE }), -1, true);
  }, [opacity, reduceMotion]);

  const animated = useAnimatedStyle(() => ({ opacity: opacity.value }));

  return <Animated.View style={[style, animated]} />;
}
