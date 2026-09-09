import 'package:flutter/material.dart';

import 'package:life_balance/ui/motion.dart';

/// Subtle scale on pointer press; does not handle [onTap] — wrap around
/// [ButtonStyleButton], [InkWell], etc. so their gestures remain unchanged.
class PressableScale extends StatefulWidget {
  const PressableScale({
    super.key,
    required this.child,
    this.pressedScale = kPressedScale,
  });

  final Widget child;
  final double pressedScale;

  @override
  State<PressableScale> createState() => _PressableScaleState();
}

class _PressableScaleState extends State<PressableScale> {
  bool _pressed = false;

  void _setPressed(bool value) {
    if (_pressed == value) return;
    setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    final disable = MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    final duration = pressScaleDuration(context);
    final targetScale = (!disable && _pressed) ? widget.pressedScale : 1.0;

    return Listener(
      onPointerDown: (_) => _setPressed(true),
      onPointerUp: (_) => _setPressed(false),
      onPointerCancel: (_) => _setPressed(false),
      child: AnimatedScale(
        scale: targetScale,
        duration: duration,
        curve: _pressed ? kPressCurve : kReleaseCurve,
        child: widget.child,
      ),
    );
  }
}
