import { useEffect } from 'react';
import { StyleSheet, Text } from 'react-native';
import Animated, {
  interpolate,
  interpolateColor,
  useAnimatedStyle,
  useSharedValue,
  withTiming,
} from 'react-native-reanimated';
import { AnimatedPressable } from '../../ui/motion/animated-pressable';
import { motionDuration } from '../../ui/motion/constants';
import { useReduceMotion } from '../../ui/motion/use-reduce-motion';
import { theme } from '../../ui/theme';

const BORDER_IDLE = 'rgba(202, 184, 255, 0.45)';
const FILL_EMPTY = 'rgba(53, 45, 85, 0)';

export function TodayTaskCheckbox({
  checked,
  skipped,
  onPress,
}: {
  checked: boolean;
  skipped: boolean;
  onPress: () => void;
}) {
  const reduceMotion = useReduceMotion();
  const fill = useSharedValue(checked ? 1 : 0);

  useEffect(() => {
    fill.value = withTiming(checked ? 1 : 0, {
      duration: motionDuration(180, reduceMotion),
    });
  }, [checked, fill, reduceMotion]);

  const boxStyle = useAnimatedStyle(() => {
    if (skipped) {
      return {
        backgroundColor: FILL_EMPTY,
        borderColor: theme.colors.warning,
      };
    }
    return {
      backgroundColor: interpolateColor(fill.value, [0, 1], [FILL_EMPTY, theme.colors.accent]),
      borderColor: interpolateColor(fill.value, [0, 1], [BORDER_IDLE, theme.colors.accent]),
    };
  });

  const markStyle = useAnimatedStyle(() => ({
    opacity: skipped ? 0 : fill.value,
    transform: [{ scale: interpolate(fill.value, [0, 1], [0.55, 1]) }],
  }));

  return (
    <AnimatedPressable onPress={onPress} style={styles.hit} hitSlop={8}>
      <Animated.View style={[styles.box, boxStyle]}>
        <Animated.Text style={[styles.mark, markStyle]}>✓</Animated.Text>
      </Animated.View>
    </AnimatedPressable>
  );
}

const styles = StyleSheet.create({
  hit: {
    alignItems: 'center',
    justifyContent: 'center',
  },
  box: {
    width: 26,
    height: 26,
    borderRadius: 6,
    borderWidth: 2,
    alignItems: 'center',
    justifyContent: 'center',
    overflow: 'hidden',
  },
  mark: {
    fontSize: 16,
    fontWeight: '700',
    color: theme.colors.accentOn,
    lineHeight: 18,
  },
});
