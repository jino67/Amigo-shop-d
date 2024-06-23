import 'dart:async';

import 'package:e_com/core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

enum MassageType {
  info,
  error,
  loading,
  success;

  (IconData, Color) get iconConfig => switch (this) {
        info => (Icons.info_outline_rounded, Colors.blue),
        error => (Icons.cancel_rounded, Colors.red),
        success => (Icons.check_rounded, Colors.green),
        loading => (Icons.check_rounded, Colors.green)
      };
}

class SFMessage {
  SFMessage._();

  static final key = GlobalKey<ScaffoldMessengerState>();

  static void showLoading(
    String? msg, {
    void Function()? onDismiss,
  }) {
    if (msg == null) return;

    final snackBar = _snakeBuilder(
      msg,
      type: MassageType.loading,
      duration: 10.seconds,
    );

    return _show(snackBar);
  }

  static void showInfo(
    String? info, {
    Duration? duration,
    void Function()? onDismiss,
  }) {
    if (info == null) return;

    final snackBar = _snakeBuilder(
      info,
      type: MassageType.info,
      duration: _kDifDuration,
    );

    return _show(snackBar);
  }

  static void showSuccess(
    String? massage, {
    void Function()? onDismiss,
  }) {
    if (massage == null) return;

    final snackBar = _snakeBuilder(
      massage,
      type: MassageType.success,
      duration: _kDifDuration,
    );

    return _show(snackBar);
  }

  static void showError(
    Object? error, {
    void Function()? onDismiss,
  }) {
    if (error == null) return;
    var msg = error.toString();
    if (error is Failure) msg = error.message;

    final snackBar = _snakeBuilder(
      msg,
      type: MassageType.error,
      duration: _kDifDuration,
    );

    _show(snackBar);
  }

  static SnackBar _snakeBuilder(
    String info, {
    required MassageType type,
    required Duration duration,
  }) {
    var ctx = key.currentContext;

    final snackBar = SnackBar(
      content: _SnackWidget(
        info,
        type: type,
        duration: duration,
      ),
      duration: duration + Times.fast,
      clipBehavior: Clip.none,
      behavior: SnackBarBehavior.floating,
      padding: EdgeInsets.zero,
      margin: EdgeInsets.only(
        bottom: ctx!.height - ctx.mq.viewPadding.bottom,
        top: ctx.mq.viewPadding.top + kBottomNavigationBarHeight,
        left: 10,
        right: ctx.width * .1,
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
    );
    return snackBar;
  }

  static final _kDifDuration = 4.seconds;

  static void remove() {
    final keyState = key.currentState;
    if (keyState == null) return;

    keyState
      ..hideCurrentSnackBar()
      ..removeCurrentSnackBar();
  }

  static void _show(SnackBar snackBar) {
    final keyState = key.currentState;
    if (keyState == null) return;

    keyState
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }
}

class _SnackWidget extends HookConsumerWidget {
  const _SnackWidget(
    this.data, {
    required this.type,
    required this.duration,
  });
  final MassageType type;
  final String data;
  final Duration duration;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ctrl = useAnimationController(duration: Times.fast);
    final beginOffset = useState(const Offset(-1, 0));

    useEffect(() {
      ctrl.forward().then((value) {
        beginOffset.value = const Offset(1, 0);
      });
      Timer(duration, () {
        if (context.mounted) ctrl.reverse();
      });
      return null;
    }, const []);

    return SlideTransition(
      position: Tween<Offset>(begin: beginOffset.value, end: Offset.zero)
          .animate(CurvedAnimation(parent: ctrl, curve: Curves.easeInOutCubic)),
      child: Container(
        clipBehavior: Clip.none,
        constraints: const BoxConstraints(minHeight: 50),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: context.colorTheme.secondary.withOpacity(.2),
              blurRadius: 10,
              offset: const Offset(0, 0),
            ),
          ],
          color: context.colorTheme.surface,
          borderRadius: Corners.medBorder,
        ),
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        child: Row(
          children: [
            if (type == MassageType.loading)
              const SizedBox.square(
                dimension: 20,
                child: CircularProgressIndicator(),
              )
            else
              Icon(type.iconConfig.$1, color: type.iconConfig.$2),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  data,
                  style: context.textTheme.bodyMedium,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
