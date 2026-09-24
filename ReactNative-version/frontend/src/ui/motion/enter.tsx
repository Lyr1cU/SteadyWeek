import type { ReactNode } from 'react';
import { type StyleProp, type ViewStyle } from 'react-native';
import Animated, { FadeIn, FadeInDown, FadeInUp, ZoomIn } from 'react-native-reanimated';
import { durationModal, durationTab, motionDuration } from './constants';
import { useReduceMotion } from './use-reduce-motion';

type EnterProps = {
  children?: ReactNode;
  style?: StyleProp<ViewStyle>;
};

export function FadeInView({
  children,
  style,
  ms = 180,
}: EnterProps & { ms?: number }) {
  const reduceMotion = useReduceMotion();
  return (
    <Animated.View
      style={style}
      entering={reduceMotion ? undefined : FadeIn.duration(motionDuration(ms, reduceMotion))}
    >
      {children}
    </Animated.View>
  );
}

export function FadeInUpView({ children, style }: EnterProps) {
  const reduceMotion = useReduceMotion();
  return (
    <Animated.View
      style={style}
      entering={
        reduceMotion ? undefined : FadeInUp.duration(motionDuration(durationTab, reduceMotion))
      }
    >
      {children}
    </Animated.View>
  );
}

export function FadeInDownView({ children, style }: EnterProps) {
  const reduceMotion = useReduceMotion();
  return (
    <Animated.View
      style={style}
      entering={
        reduceMotion ? undefined : FadeInDown.duration(motionDuration(durationModal, reduceMotion))
      }
    >
      {children}
    </Animated.View>
  );
}

export function ZoomInView({ children, style }: EnterProps) {
  const reduceMotion = useReduceMotion();
  return (
    <Animated.View
      style={style}
      entering={
        reduceMotion ? undefined : ZoomIn.duration(motionDuration(durationModal, reduceMotion))
      }
    >
      {children}
    </Animated.View>
  );
}
