import { Ionicons } from '@expo/vector-icons';
import { useEffect } from 'react';
import { StyleSheet, View } from 'react-native';
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

const BORDER_IDLE = 'rgba(202, 184, 255, 0.35)';
const FILL_EMPTY = 'rgba(53, 45, 85, 0.45)';

export function CloseDayMoodStar({
  filled,
  onPress,
}: {
  filled: boolean;
  onPress: () => void;
}) {
  const reduceMotion = useReduceMotion();
  const fill = useSharedValue(filled ? 1 : 0);

  useEffect(() => {
    fill.value = withTiming(filled ? 1 : 0, {
      duration: motionDuration(180, reduceMotion),
    });
  }, [filled, fill, reduceMotion]);

  const boxStyle = useAnimatedStyle(() => ({
    backgroundColor: interpolateColor(fill.value, [0, 1], [FILL_EMPTY, theme.colors.accent]),
    borderColor: interpolateColor(fill.value, [0, 1], [BORDER_IDLE, theme.colors.accent]),
  }));

  const starStyle = useAnimatedStyle(() => ({
    opacity: interpolate(fill.value, [0, 1], [0.45, 1]),
    transform: [{ scale: interpolate(fill.value, [0, 1], [0.88, 1]) }],
  }));

  return (
    <AnimatedPressable onPress={onPress} style={styles.hit} accessibilityRole="button">
      <Animated.View style={[styles.box, boxStyle]}>
        <View style={styles.iconStack}>
          <Ionicons name="star-outline" size={22} color={theme.colors.textMuted} />
          <Animated.View style={[styles.starFilled, starStyle]}>
            <Ionicons name="star" size={22} color={theme.colors.accentOn} />
          </Animated.View>
        </View>
      </Animated.View>
    </AnimatedPressable>
  );
}

const MOOD_LEVELS = [1, 2, 3, 4, 5] as const;

export function CloseDayMoodStars({
  mood,
  onMood,
}: {
  mood: number | null;
  onMood: (m: number | null) => void;
}) {
  return (
    <View style={styles.row}>
      {MOOD_LEVELS.map((level) => (
        <CloseDayMoodStar
          key={level}
          filled={mood != null && level <= mood}
          onPress={() => onMood(mood === level ? null : level)}
        />
      ))}
    </View>
  );
}

const styles = StyleSheet.create({
  row: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    gap: 8,
  },
  hit: {
    flex: 1,
    alignItems: 'center',
  },
  box: {
    width: 44,
    height: 44,
    borderRadius: 10,
    borderWidth: 2,
    alignItems: 'center',
    justifyContent: 'center',
    overflow: 'hidden',
  },
  iconStack: {
    width: 22,
    height: 22,
    alignItems: 'center',
    justifyContent: 'center',
  },
  starFilled: {
    ...StyleSheet.absoluteFill,
    alignItems: 'center',
    justifyContent: 'center',
  },
});
