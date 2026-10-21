import type { ReactNode } from 'react';
import { useCallback, useEffect, useRef, useState } from 'react';
import {
  Modal,
  Pressable,
  StyleSheet,
  Text,
  useWindowDimensions,
  View,
  type LayoutRectangle,
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
import { theme } from './theme';

const MENU_BG = 'rgba(37, 32, 56, 0.97)';
const MENU_RIM = 'rgba(231, 223, 255, 0.55)';
const MENU_EASE_OUT = Easing.out(Easing.cubic);

export type ChromeMenuItem = {
  key: string;
  label: string;
  icon: ReactNode;
  onPress: () => void;
};

type ChromeContextMenuProps = {
  items: ChromeMenuItem[];
  trigger: (open: () => void) => ReactNode;
};

export function ChromeContextMenu({ items, trigger }: ChromeContextMenuProps) {
  const reduceMotion = useReduceMotion();
  const { width: windowWidth } = useWindowDimensions();
  const anchorRef = useRef<View>(null);
  const [visible, setVisible] = useState(false);
  const [anchor, setAnchor] = useState<LayoutRectangle | null>(null);
  const closingRef = useRef(false);

  const backdropOpacity = useSharedValue(0);
  const panelOpacity = useSharedValue(0);
  const panelScale = useSharedValue(0.92);
  const panelShiftY = useSharedValue(-8);

  const enterDur = motionDuration(durationModal, reduceMotion);
  const exitDur = motionDuration(180, reduceMotion);

  const finishClose = useCallback(() => {
    closingRef.current = false;
    setVisible(false);
    setAnchor(null);
  }, []);

  const playEnter = useCallback(() => {
    backdropOpacity.value = 0;
    panelOpacity.value = 0;
    panelScale.value = 0.92;
    panelShiftY.value = -8;
    backdropOpacity.value = withTiming(1, { duration: enterDur, easing: MENU_EASE_OUT });
    panelOpacity.value = withTiming(1, { duration: enterDur, easing: MENU_EASE_OUT });
    panelScale.value = withTiming(1, { duration: enterDur, easing: MENU_EASE_OUT });
    panelShiftY.value = withTiming(0, { duration: enterDur, easing: MENU_EASE_OUT });
  }, [backdropOpacity, enterDur, panelOpacity, panelScale, panelShiftY]);

  const playExit = useCallback(
    (onDone?: () => void) => {
      if (reduceMotion) {
        finishClose();
        onDone?.();
        return;
      }
      backdropOpacity.value = withTiming(0, { duration: exitDur, easing: MENU_EASE_OUT });
      panelOpacity.value = withTiming(0, { duration: exitDur, easing: MENU_EASE_OUT });
      panelScale.value = withTiming(0.94, { duration: exitDur, easing: MENU_EASE_OUT });
      panelShiftY.value = withTiming(-6, { duration: exitDur, easing: MENU_EASE_OUT }, (finished) => {
        if (finished) {
          runOnJS(finishClose)();
          if (onDone) {
            runOnJS(onDone)();
          }
        }
      });
    },
    [
      backdropOpacity,
      exitDur,
      finishClose,
      panelOpacity,
      panelScale,
      panelShiftY,
      reduceMotion,
    ],
  );

  useEffect(() => {
    if (visible && anchor) {
      playEnter();
    }
  }, [visible, anchor, playEnter]);

  const openMenu = useCallback(() => {
    if (closingRef.current) {
      return;
    }
    anchorRef.current?.measureInWindow((x, y, width, height) => {
      setAnchor({ x, y, width, height });
      setVisible(true);
    });
  }, []);

  const close = useCallback(() => {
    if (!visible || closingRef.current) {
      return;
    }
    closingRef.current = true;
    playExit();
  }, [playExit, visible]);

  const runItem = (item: ChromeMenuItem) => {
    if (closingRef.current) {
      return;
    }
    closingRef.current = true;
    playExit(item.onPress);
  };

  const backdropStyle = useAnimatedStyle(() => ({
    opacity: backdropOpacity.value,
  }));

  const panelMotionStyle = useAnimatedStyle(() => ({
    opacity: panelOpacity.value,
    transform: [{ scale: panelScale.value }, { translateY: panelShiftY.value }],
  }));

  const panelWidth = 248;
  const panelLeft =
    anchor != null
      ? Math.max(12, Math.min(anchor.x + anchor.width - panelWidth, windowWidth - panelWidth - 12))
      : 24;
  const panelTop = anchor != null ? anchor.y + anchor.height + 6 : 0;

  return (
    <>
      <View ref={anchorRef} collapsable={false}>
        {trigger(openMenu)}
      </View>
      <Modal visible={visible} transparent animationType="none" onRequestClose={close}>
        <View style={styles.modalRoot}>
          <Animated.View style={[styles.backdropHost, backdropStyle]}>
            <Pressable style={styles.backdrop} onPress={close} accessibilityLabel="Close menu" />
          </Animated.View>
          {anchor ? (
            <Animated.View
              style={[
                styles.panel,
                panelMotionStyle,
                { top: panelTop, left: panelLeft, width: panelWidth },
              ]}
            >
              {items.map((item) => (
                <Pressable
                  key={item.key}
                  style={({ pressed }) => [styles.item, pressed && styles.itemPressed]}
                  onPress={() => runItem(item)}
                >
                  <View style={styles.itemIcon}>{item.icon}</View>
                  <Text style={styles.itemLabel}>{item.label}</Text>
                </Pressable>
              ))}
            </Animated.View>
          ) : null}
        </View>
      </Modal>
    </>
  );
}

const styles = StyleSheet.create({
  modalRoot: {
    flex: 1,
  },
  backdropHost: {
    ...StyleSheet.absoluteFill,
  },
  backdrop: {
    ...StyleSheet.absoluteFill,
    backgroundColor: 'rgba(8, 7, 12, 0.35)',
  },
  panel: {
    position: 'absolute',
    backgroundColor: MENU_BG,
    borderRadius: 16,
    borderWidth: 1.5,
    borderColor: MENU_RIM,
    paddingVertical: 6,
    shadowColor: theme.colors.accent,
    shadowOffset: { width: 0, height: 8 },
    shadowOpacity: 0.35,
    shadowRadius: 16,
    elevation: 14,
  },
  item: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 12,
    paddingHorizontal: 14,
    paddingVertical: 12,
  },
  itemPressed: {
    backgroundColor: 'rgba(202, 184, 255, 0.08)',
  },
  itemIcon: {
    width: 24,
    alignItems: 'center',
  },
  itemLabel: {
    flex: 1,
    fontSize: 16,
    fontWeight: '500',
    color: theme.colors.text,
    letterSpacing: 0.15,
  },
});
