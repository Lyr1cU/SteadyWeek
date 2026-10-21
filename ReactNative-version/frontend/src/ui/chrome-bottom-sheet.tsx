import type { ReactNode } from 'react';
import { useCallback, useEffect, useRef, useState } from 'react';
import {
  Modal,
  Pressable,
  StyleSheet,
  View,
  type StyleProp,
  type ViewStyle,
} from 'react-native';
import Animated, {
  Easing,
  runOnJS,
  useAnimatedStyle,
  useSharedValue,
  withTiming,
} from 'react-native-reanimated';
import { durationModal, motionDuration } from './motion/constants';
import { useReduceMotion } from './motion/use-reduce-motion';

const MODAL_EASE_OUT = Easing.out(Easing.cubic);
const MODAL_EASE_IN = Easing.in(Easing.cubic);

type ChromeBottomSheetProps = {
  visible: boolean;
  onClose: () => void;
  children: ReactNode;
  sheetStyle?: StyleProp<ViewStyle>;
  backdropLabel?: string;
};

export function ChromeBottomSheet({
  visible,
  onClose,
  children,
  sheetStyle,
  backdropLabel = 'Close',
}: ChromeBottomSheetProps) {
  const reduceMotion = useReduceMotion();
  const [mounted, setMounted] = useState(false);
  const exitingRef = useRef(false);

  const backdropOpacity = useSharedValue(0);
  const sheetTranslateY = useSharedValue(420);

  const enterDur = motionDuration(durationModal, reduceMotion);
  const exitDur = motionDuration(200, reduceMotion);

  const finishUnmount = useCallback(() => {
    exitingRef.current = false;
    setMounted(false);
  }, []);

  const playEnter = useCallback(() => {
    backdropOpacity.value = 0;
    sheetTranslateY.value = 420;
    backdropOpacity.value = withTiming(1, { duration: enterDur, easing: MODAL_EASE_OUT });
    sheetTranslateY.value = withTiming(0, { duration: enterDur, easing: MODAL_EASE_OUT });
  }, [backdropOpacity, enterDur, sheetTranslateY]);

  const playExit = useCallback(
    (after?: () => void) => {
      if (reduceMotion) {
        finishUnmount();
        after?.();
        return;
      }
      backdropOpacity.value = withTiming(0, { duration: exitDur, easing: MODAL_EASE_IN });
      sheetTranslateY.value = withTiming(
        420,
        { duration: exitDur, easing: MODAL_EASE_IN },
        (finished) => {
          if (finished) {
            runOnJS(finishUnmount)();
            if (after) {
              runOnJS(after)();
            }
          }
        },
      );
    },
    [backdropOpacity, exitDur, finishUnmount, reduceMotion, sheetTranslateY],
  );

  useEffect(() => {
    if (visible) {
      exitingRef.current = false;
      setMounted(true);
      return;
    }
    if (mounted && !exitingRef.current) {
      exitingRef.current = true;
      playExit();
    }
  }, [visible, mounted, playExit]);

  useEffect(() => {
    if (mounted && visible) {
      playEnter();
    }
  }, [mounted, visible, playEnter]);

  const requestClose = () => {
    if (!mounted || exitingRef.current) {
      return;
    }
    onClose();
  };

  const backdropStyle = useAnimatedStyle(() => ({
    opacity: backdropOpacity.value,
  }));

  const sheetMotionStyle = useAnimatedStyle(() => ({
    transform: [{ translateY: sheetTranslateY.value }],
  }));

  if (!mounted) {
    return null;
  }

  return (
    <Modal visible={mounted} transparent animationType="none" onRequestClose={requestClose}>
      <View style={styles.root}>
        <Animated.View style={[styles.backdropHost, backdropStyle]}>
          <Pressable
            style={styles.backdropTap}
            onPress={requestClose}
            accessibilityLabel={backdropLabel}
          />
        </Animated.View>
        <Animated.View style={[styles.sheet, sheetMotionStyle, sheetStyle]}>{children}</Animated.View>
      </View>
    </Modal>
  );
}

const styles = StyleSheet.create({
  root: {
    flex: 1,
    justifyContent: 'flex-end',
  },
  backdropHost: {
    ...StyleSheet.absoluteFill,
    backgroundColor: 'rgba(0, 0, 0, 0.55)',
  },
  backdropTap: {
    flex: 1,
  },
  sheet: {
    maxHeight: '92%',
  },
});
