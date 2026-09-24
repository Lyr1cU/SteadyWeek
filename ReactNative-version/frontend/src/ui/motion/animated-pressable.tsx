import type { ReactNode } from 'react';
import { Pressable, type PressableProps, type StyleProp, type ViewStyle } from 'react-native';
import Animated, {
  useAnimatedStyle,
  useSharedValue,
  withTiming,
} from 'react-native-reanimated';
import { durationPress, motionDuration, pressOpacity, pressScale } from './constants';
import { useReduceMotion } from './use-reduce-motion';

const AnimatedPressableRoot = Animated.createAnimatedComponent(Pressable);

type AnimatedPressableProps = Omit<PressableProps, 'style'> & {
  style?: StyleProp<ViewStyle>;
  children?: ReactNode;
};

export function AnimatedPressable({ children, style, disabled, ...rest }: AnimatedPressableProps) {
  const reduceMotion = useReduceMotion();
  const scale = useSharedValue(1);
  const opacity = useSharedValue(1);
  const dur = motionDuration(durationPress, reduceMotion);

  const animatedStyle = useAnimatedStyle(() => ({
    transform: [{ scale: scale.value }],
    opacity: opacity.value,
  }));

  return (
    <AnimatedPressableRoot
      {...rest}
      disabled={disabled}
      style={[style, animatedStyle]}
      onPressIn={(e) => {
        if (!disabled) {
          scale.value = withTiming(pressScale, { duration: dur });
          opacity.value = withTiming(pressOpacity, { duration: dur });
        }
        rest.onPressIn?.(e);
      }}
      onPressOut={(e) => {
        scale.value = withTiming(1, { duration: dur });
        opacity.value = withTiming(1, { duration: dur });
        rest.onPressOut?.(e);
      }}
    >
      {children}
    </AnimatedPressableRoot>
  );
}
