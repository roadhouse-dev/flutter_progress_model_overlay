library flutterprogressmodeloverlay;

import 'dart:ui';

import 'package:flutter/material.dart';

class ProgressOverlayIndicator extends StatelessWidget {
  final bool showProgressIndicator;
  final Widget child;

  const ProgressOverlayIndicator(
      {Key key, this.showProgressIndicator, this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        child,
        if (showProgressIndicator) ProgressModelOverlay(),
      ],
    );
  }
}

class ProgressModelOverlay extends StatefulWidget {
  @override
  _ProgressModelOverlayState createState() => _ProgressModelOverlayState();
}

class _ProgressModelOverlayState extends State<ProgressModelOverlay>
    with TickerProviderStateMixin {
  AnimationController _animationController;
  Animation<double> _blurAnimation;
  Animation<double> _barrierAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
        value: 0, duration: Duration(milliseconds: 300), vsync: this);

    _blurAnimation =
        Tween<double>(begin: 0, end: 3.0).animate(_animationController);
    _barrierAnimation =
    Tween<double>(begin: 0, end: 0.6).animate(_animationController)
      ..addListener(() {
        setState(() {});
      });

    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: AbsorbPointer(
        child: Stack(
          children: <Widget>[
            Opacity(
              opacity: _barrierAnimation.value,
              child: ModalBarrier(
                color: Colors.black,
              ),
            ),
            BackdropFilter(
              filter: ImageFilter.blur(
                sigmaY: _blurAnimation.value,
                sigmaX: _blurAnimation.value,
              ),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}