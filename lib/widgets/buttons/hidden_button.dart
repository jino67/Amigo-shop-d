import 'dart:async';

import 'package:e_com/core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class HiddenButton extends HookWidget {
  const HiddenButton({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final timer = useState<Timer?>(null);
    void clear() {
      timer.value?.cancel();
      timer.value = null;
    }

    return GestureDetector(
      onTapDown: (details) {
        timer.value = Timer.periodic(
          1.seconds,
          (timer) {
            if (timer.tick == 5) {
              HapticFeedback.heavyImpact();
              talk.goToLogView(context);
            }
          },
        );
      },
      onTapUp: (details) => clear(),
      onTapCancel: () => clear(),
      onTap: () => clear(),
      child: child,
    );
  }
}
