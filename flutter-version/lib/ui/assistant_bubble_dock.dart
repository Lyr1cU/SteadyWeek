import 'dart:async';

import 'package:flutter/material.dart';

/// Speech bubble above [buddy]; the bubble hides after [hideBubbleAfter] (buddy stays).
class AssistantBubbleDock extends StatefulWidget {
  const AssistantBubbleDock({
    super.key,
    required this.bubble,
    required this.buddy,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.buddyLeftAlignShift = 0,
    this.hideBubbleAfter = const Duration(seconds: 8),
  });

  final Widget bubble;
  final Widget buddy;
  final CrossAxisAlignment crossAxisAlignment;
  final double buddyLeftAlignShift;
  final Duration hideBubbleAfter;

  @override
  State<AssistantBubbleDock> createState() => _AssistantBubbleDockState();
}

class _AssistantBubbleDockState extends State<AssistantBubbleDock> {
  bool _bubbleVisible = true;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(widget.hideBubbleAfter, () {
      if (mounted) setState(() => _bubbleVisible = false);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final align = widget.crossAxisAlignment == CrossAxisAlignment.end
        ? Alignment.topRight
        : Alignment.topLeft;

    return Column(
      crossAxisAlignment: widget.crossAxisAlignment,
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedSize(
          duration: const Duration(milliseconds: 260),
          curve: Curves.easeInOutCubic,
          alignment: align,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: widget.crossAxisAlignment,
            children: [
              if (_bubbleVisible) widget.bubble,
              if (_bubbleVisible) const SizedBox(height: 8),
            ],
          ),
        ),
        Transform.translate(
          offset: Offset(widget.buddyLeftAlignShift, 0),
          child: widget.buddy,
        ),
      ],
    );
  }
}
