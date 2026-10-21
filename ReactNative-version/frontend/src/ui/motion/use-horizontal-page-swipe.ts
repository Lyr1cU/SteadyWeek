import { useMemo } from 'react';
import { Gesture } from 'react-native-gesture-handler';
import { runOnJS } from 'react-native-reanimated';

const SWIPE_DISTANCE = 56;

/** Horizontal swipe that yields to vertical scrolling. Right = previous, left = next. */
export function useHorizontalPageSwipe(onPrev: () => void, onNext: () => void) {
  return useMemo(
    () =>
      Gesture.Pan()
        .activeOffsetX([-24, 24])
        .failOffsetY([-18, 18])
        .onEnd((event) => {
          if (event.translationX >= SWIPE_DISTANCE) {
            runOnJS(onPrev)();
          } else if (event.translationX <= -SWIPE_DISTANCE) {
            runOnJS(onNext)();
          }
        }),
    [onPrev, onNext],
  );
}
