import "package:flutter/material.dart";

class CircleAnimation extends StatefulWidget {
  final Widget child;
  CircleAnimation(this.child);
  @override
  _CircleAnimationState createState() => _CircleAnimationState();
}

class _CircleAnimationState extends State<CircleAnimation> with SingleTickerProviderStateMixin{
  AnimationController controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 5000));
    controller.forward();
    controller.repeat();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: Tween(begin: 0.0, end: 1.0).animate(controller),
      child: widget.child,
    );
  }
}