import 'package:flutter/material.dart';

///
class ModalBottomSheetWrapper extends StatefulWidget {
  /// `scrollPhysics` are the recommended `ScrollPhysics` to be used for any
  /// scroll view inside.
  final Widget Function(BuildContext context, ScrollPhysics scrollPhysics)
      builder;

  const ModalBottomSheetWrapper({
    super.key,
    required this.builder,
  });

  @override
  State<ModalBottomSheetWrapper> createState() =>
      _ModalBottomSheetWrapperState();
}

class _ModalBottomSheetWrapperState extends State<ModalBottomSheetWrapper> {
  bool _clamp = false;

  @override
  Widget build(BuildContext context) {
    return NotificationListener(
      onNotification: (ScrollNotification notification) {
        // don't care about horizontal scrolling
        if (notification.metrics.axis != Axis.vertical) {
          return false;
        }

        // examine new value
        bool clamp = false;

        // TODO: (04/03/24) handle inverted
        final atTopEdge =
            notification.metrics.pixels == notification.metrics.minScrollExtent;

        // if scrolling starts, exactly clamp when we start to drag at the top
        if (notification is ScrollStartNotification) {
          clamp = atTopEdge;
          setState(() {
            _clamp = clamp;
          });
        }

        // if scrolling ends, exactly clamp if we end on the edge
        if (notification is ScrollEndNotification) {
          clamp = atTopEdge;
          setState(() {
            _clamp = clamp;
          });
        }

        // when we are scrolling, enable bouncing again if we dragged away from
        // the edge
        if (notification is ScrollUpdateNotification) {
          if (!atTopEdge) {
            clamp = false;
            setState(() {
              _clamp = clamp;
            });
          }
        }
        return !_clamp;
      },
      child: widget.builder(
        context,
        _clamp ? const ClampingScrollPhysics() : const BouncingScrollPhysics(),
      ),
    );
  }
}
