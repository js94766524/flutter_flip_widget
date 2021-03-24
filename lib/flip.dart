library flip;

import 'dart:math';
import 'package:flutter/widgets.dart';

class Flip extends StatefulWidget {
  final Widget firstChild;
  final Widget secondChild;
  final FlipController controller;
  final Duration flipDuration;
  final Axis flipDirection;

  const Flip({
    Key? key,
    required this.controller,
    required this.firstChild,
    required this.secondChild,
    this.flipDuration = const Duration(milliseconds: 300),
    this.flipDirection = Axis.horizontal,
  }) : super(key: key);

  @override
  _FlipState createState() => _FlipState();
}

class _FlipState extends State<Flip> with SingleTickerProviderStateMixin {
  late AnimationController flipAnimation;
  late bool isFront;

  @override
  void initState() {
    isFront = widget.controller.value;
    flipAnimation = AnimationController(
        value: isFront ? 0 : 1, vsync: this, duration: widget.flipDuration);
    flipAnimation.addListener(_listenAnimationController);
    widget.controller.addListener(_listenFlipController);
    super.initState();
  }

  @override
  void dispose() {
    flipAnimation.removeListener(_listenAnimationController);
    flipAnimation.dispose();
    widget.controller.removeListener(_listenFlipController);
    super.dispose();
  }

  void _listenFlipController() {
    if (widget.controller.isFront) {
      flipAnimation.reverse();
    } else {
      flipAnimation.forward();
    }
  }

  void _listenAnimationController() {
    if (isFront && flipAnimation.value > 0.5) {
      setState(() {
        isFront = false;
      });
    } else if (!isFront && flipAnimation.value < 0.5) {
      setState(() {
        isFront = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var child = AnimatedBuilder(
      animation: flipAnimation,
      builder: (context, child) {
        return Transform(
          transform: _buildAnimatedMatrix4(flipAnimation.value),
          alignment: Alignment.center,
          child: child,
        );
      },
      child: IndexedStack(
        index: isFront ? 0 : 1,
        alignment: Alignment.center,
        children: <Widget>[
          widget.firstChild,
          Transform(
              transform: _buildSecondChildMatrix4(),
              alignment: Alignment.center,
              child: widget.secondChild)
        ],
      ),
    );
    return child;
  }

  Matrix4 _buildSecondChildMatrix4() {
    if (widget.flipDirection == Axis.horizontal) {
      return Matrix4.identity()..rotateY(pi);
    } else {
      return Matrix4.identity()..rotateX(pi);
    }
  }

  Matrix4 _buildAnimatedMatrix4(double value) {
    final matrix = Matrix4.identity()..setEntry(3, 2, 0.002);
    if (widget.flipDirection == Axis.horizontal) {
      matrix.rotateY(value * pi);
    } else {
      matrix.rotateX(value * pi);
    }
    return matrix;
  }
}

class FlipController extends ValueNotifier<bool> {
  FlipController({bool isFront = true}) : super(isFront);

  bool get isFront => value;

  set isFront(v) => value = v;

  void flip() {
    value = !value;
  }
}
