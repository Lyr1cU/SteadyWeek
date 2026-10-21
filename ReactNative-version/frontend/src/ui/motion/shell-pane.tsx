import { createContext, useContext, useEffect, useRef, useState, type ReactNode } from 'react';
import { StyleSheet } from 'react-native';
import Animated, { Easing, useAnimatedStyle, useSharedValue, withTiming } from 'react-native-reanimated';
import { durationTab, motionDuration } from './constants';
import { useReduceMotion } from './use-reduce-motion';

const PANE_EASE = Easing.out(Easing.cubic);
const ShellEnterContext = createContext(-1);

/**
 * -1 while this visit should show a placeholder.
 * A positive value means the real screen may mount and play its entrance once.
 */
export function useShellEnterKey(): number {
  return useContext(ShellEnterContext);
}

/** Keeps a tab mounted while hidden. Each visit holds a placeholder, then reveals once. */
export function ShellPane({
  active,
  direction,
  children,
}: {
  active: boolean;
  /** 1 = from the right, -1 = from the left. */
  direction: 1 | -1;
  children: ReactNode;
}) {
  const reduceMotion = useReduceMotion();
  const [enterKey, setEnterKey] = useState(-1);
  const wasActive = useRef(false);
  const opacity = useSharedValue(active ? 1 : 0);
  const shift = useSharedValue(0);

  if (wasActive.current !== active) {
    wasActive.current = active;
    opacity.value = active ? 1 : 0;
    if (active) {
      shift.value = direction * 28;
      if (enterKey !== -1) {
        setEnterKey(-1);
      }
    }
  }

  const reduceMotionRef = useRef(reduceMotion);
  reduceMotionRef.current = reduceMotion;

  useEffect(() => {
    if (!active) {
      return;
    }
    const frame = requestAnimationFrame(() => {
      setEnterKey((value) => (value < 0 ? 1 : value + 1));
    });
    if (!reduceMotionRef.current) {
      shift.value = withTiming(0, {
        duration: motionDuration(durationTab, false),
        easing: PANE_EASE,
      });
    } else {
      shift.value = 0;
    }
    return () => cancelAnimationFrame(frame);
  }, [active, shift]);

  const motion = useAnimatedStyle(() => ({
    opacity: opacity.value,
    transform: [{ translateX: shift.value }],
  }));

  return (
    <Animated.View
      style={[styles.pane, motion, { zIndex: active ? 1 : 0 }]}
      pointerEvents={active ? 'auto' : 'none'}
      accessibilityElementsHidden={!active}
      importantForAccessibility={active ? 'auto' : 'no-hide-descendants'}
    >
      <ShellEnterContext.Provider value={enterKey}>{children}</ShellEnterContext.Provider>
    </Animated.View>
  );
}

const styles = StyleSheet.create({
  pane: {
    ...StyleSheet.absoluteFill,
  },
});
