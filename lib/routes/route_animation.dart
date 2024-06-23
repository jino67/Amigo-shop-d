import 'package:flutter/material.dart';

class AnimatePageRoute<T> extends Page<T> {
  const AnimatePageRoute({
    required this.child,
    this.fullscreen = false,
    super.name,
    super.key,
  });

  final Widget Function(Animation<double> animation) child;
  final bool fullscreen;

  static final _curve = CurveTween(curve: Curves.easeInOutCubic);
  static const _duration = Duration(milliseconds: 600);

  @override
  Route<T> createRoute(BuildContext context) {
    return PageRouteBuilder(
      settings: this,
      fullscreenDialog: fullscreen,
      transitionDuration: _duration,
      reverseTransitionDuration: _duration,
      pageBuilder: (__, animation, _) => child(animation),
      transitionsBuilder: (__, animation, _, child) =>
          _kTransition(animation, child),
    );
  }

  Animation<Offset> _position(Animation<double> animation) =>
      Tween<Offset>(begin: const Offset(0, .5), end: Offset.zero)
          .chain(_curve)
          .animate(animation);

  FadeTransition _kTransition(Animation<double> animation, Widget child) {
    return FadeTransition(
      opacity: _curve.animate(animation),
      child: SlideTransition(
        position: _position(animation),
        child: child,
      ),
    );
  }
}
