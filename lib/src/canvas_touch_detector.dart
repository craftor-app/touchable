// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:touchable/src/types/types.dart';

///[CanvasTouchDetector] widget detects the gestures on your [CustomPaint] widget.
///
/// Wrap your [CustomPaint] widget with [CanvasTouchDetector]
/// The [builder] function passes the [BuildContext] and expects a [CustomPaint] object as its return value.
/// The [gesturesToOverride] list must contains list of gestures you want to listen to (by default contains all types of gestures).
class CanvasTouchDetector extends StatefulWidget {
  final CustomTouchPaintBuilder builder;
  final HitTestBehavior? behavior;
  const CanvasTouchDetector({
    Key? key,
    required this.builder,
    this.behavior,
  }) : super(key: key);

  @override
  State<CanvasTouchDetector> createState() => _CanvasTouchDetectorState();
}

class _CanvasTouchDetectorState extends State<CanvasTouchDetector> {
  final StreamController<Gesture> touchController =
      StreamController.broadcast();
  StreamSubscription? streamSubscription;

  Future<void> addStreamListener(Function(Gesture) callBack) async {
    await streamSubscription?.cancel();
    streamSubscription = touchController.stream.listen(callBack);
  }

  @override
  Widget build(BuildContext context) {
    return TouchDetectionController(
      touchController,
      addStreamListener,
      child: GestureDetector(
        behavior: widget.behavior,
        onTapDown: (tapDetail) {
          touchController.add(Gesture(GestureType.onTapDown, tapDetail));
        },
        onTapUp: (tapDetail) {
          touchController.add(Gesture(GestureType.onTapUp, tapDetail));
        },
        onPanStart: (tapDetail) {
          touchController.add(Gesture(GestureType.onPanStart, tapDetail));
        },
        onPanUpdate: (tapDetail) {
          touchController.add(Gesture(GestureType.onPanUpdate, tapDetail));
        },
        onPanDown: (tapDetail) {
          touchController.add(Gesture(GestureType.onPanDown, tapDetail));
        },
        onSecondaryTapDown: (tapDetail) {
          touchController
              .add(Gesture(GestureType.onSecondaryTapDown, tapDetail));
        },
        onSecondaryTapUp: (tapDetail) {
          touchController.add(Gesture(GestureType.onSecondaryTapUp, tapDetail));
        },
        child: Builder(
          builder: (context) {
            return widget.builder(context);
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    touchController.close();
    super.dispose();
  }
}

class TouchDetectionController extends InheritedWidget {
  final StreamController<Gesture> _controller;
  final Function addListener;

  bool get hasListener => _controller.hasListener;

  StreamController<Gesture> get controller => _controller;

  const TouchDetectionController(this._controller, this.addListener,
      {super.key, required Widget child})
      : super(child: child);

  static TouchDetectionController? of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<TouchDetectionController>();

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return false;
  }
}
