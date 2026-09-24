import type { ReactNode } from 'react';
import { useCallback, useRef, useState } from 'react';
import {
  Modal,
  Pressable,
  StyleSheet,
  Text,
  useWindowDimensions,
  View,
  type LayoutRectangle,
} from 'react-native';
import { FadeInView, ZoomInView } from './motion/enter';
import { theme } from './theme';

const MENU_BG = 'rgba(37, 32, 56, 0.97)';
const MENU_RIM = 'rgba(231, 223, 255, 0.55)';

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
  const { width: windowWidth } = useWindowDimensions();
  const anchorRef = useRef<View>(null);
  const [open, setOpen] = useState(false);
  const [anchor, setAnchor] = useState<LayoutRectangle | null>(null);

  const openMenu = useCallback(() => {
    anchorRef.current?.measureInWindow((x, y, width, height) => {
      setAnchor({ x, y, width, height });
      setOpen(true);
    });
  }, []);

  const close = useCallback(() => setOpen(false), []);

  const runItem = (item: ChromeMenuItem) => {
    close();
    item.onPress();
  };

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
      <Modal visible={open} transparent animationType="none" onRequestClose={close}>
        <View style={styles.modalRoot}>
          <FadeInView ms={140} style={styles.backdropHost}>
            <Pressable style={styles.backdrop} onPress={close} accessibilityLabel="Close menu" />
          </FadeInView>
          {anchor ? (
            <ZoomInView style={[styles.panel, { top: panelTop, left: panelLeft, width: panelWidth }]}>
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
            </ZoomInView>
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
