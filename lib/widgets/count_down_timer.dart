import 'dart:async';

import 'package:e_com/core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class TimerCountdown extends HookConsumerWidget {
  const TimerCountdown({
    required this.duration,
    required this.color,
    super.key,
  });

  final Color color;
  final Duration duration;

  String formateDays(int timeInSeconds) {
    final days = (timeInSeconds / 86400).floor();

    return '$days';
  }

  String formateHours(int timeInSeconds) {
    final hours = ((timeInSeconds % 86400) / 3600).floor();

    return '$hours';
  }

  String formateMinutes(int timeInSeconds) {
    final minutes = ((timeInSeconds % 3600) / 60).floor();

    return ' $minutes';
  }

  String formateSeconds(int timeInSeconds) {
    final seconds = timeInSeconds % 60;

    return '$seconds';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timer = useState<Timer?>(null);

    /// Converted duration to seconds
    final seconds = useState(duration.inSeconds);

    /// Start countdown
    final startCountdown = useCallback(() {
      timer.value = Timer.periodic(1.seconds, (timer) {
        /// Cancel timer if seconds is 0
        if (seconds.value == 0) return timer.cancel();

        /// else Decrement seconds
        seconds.value--;
      });
    });

    useEffect(() {
      startCountdown();
      return timer.value?.cancel;
    }, const []);

    return Row(
      children: [
        TimeContainer(
          subTitle: 'DAY',
          color: color,
          text: Text(
            formateDays(seconds.value),
            style: context.textTheme.labelMedium!.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
        ),
        TimeContainer(
          subTitle: 'HR',
          color: color,
          text: Text(
            formateHours(seconds.value),
            style: context.textTheme.labelMedium!.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
        ),
        TimeContainer(
          subTitle: 'MIN',
          color: color,
          text: Text(
            formateMinutes(seconds.value),
            style: context.textTheme.labelMedium!.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
        ),
        TimeContainer(
          subTitle: 'SEC',
          color: color,
          text: Text(
            formateSeconds(seconds.value),
            style: context.textTheme.labelMedium!.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
        ),
      ],
    );
  }
}

class TimeContainer extends StatelessWidget {
  const TimeContainer({
    super.key,
    required this.text,
    required this.color,
    required this.subTitle,
  });

  final Color color;
  final Widget text;
  final String subTitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      width: 45,
      margin: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: color,
        borderRadius: Corners.smBorder,
        boxShadow: [
          BoxShadow(
            blurRadius: 6,
            color: context.colorTheme.primaryContainer
                .withOpacity(context.isDark ? 0.3 : 0.1),
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(3),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            text,
            const SizedBox(height: 2),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: Container(
                height: 1,
                width: double.infinity,
                color: context.colorTheme.secondaryContainer.withOpacity(0.5),
              ),
            ),
            Text(
              subTitle,
              style: context.textTheme.labelSmall,
            ),
          ],
        ),
      ),
    );
  }
}
