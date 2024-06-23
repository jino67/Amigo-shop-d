import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../animated_onboard.dart';

/// A IntroScreen Class.
class IntroScreenOnboarding extends StatefulWidget {
  final List<Introduction>? introductionList;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final TextStyle? skipTextStyle;

  /// Callback on Skip Button Pressed
  final Function()? onTapSkipButton;
  const IntroScreenOnboarding({
    Key? key,
    this.introductionList,
    this.backgroundColor,
    this.foregroundColor,
    this.skipTextStyle = const TextStyle(fontSize: 20),
    this.onTapSkipButton,
  }) : super(key: key);

  @override
  State<IntroScreenOnboarding> createState() => _IntroScreenOnboardingState();
}

class _IntroScreenOnboardingState extends State<IntroScreenOnboarding> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;
  double progressPercent = 0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Material(
        child: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light,
          child: Container(
            color: widget.backgroundColor ??
                Theme.of(context).colorScheme.background,
            child: Column(
              children: [
                Container(
                  alignment: Alignment.topRight,
                  child: TextButton(
                    onPressed: widget.onTapSkipButton,
                    child: Text(
                      'Skip',
                      style: widget.skipTextStyle,
                    ),
                  ),
                ),
                SizedBox(
                  height: 550.0,
                  child: PageView(
                    physics: const ClampingScrollPhysics(),
                    controller: _pageController,
                    onPageChanged: (int page) {
                      setState(() {
                        _currentPage = page;
                      });
                    },
                    children: widget.introductionList!,
                  ),
                ),
                const Spacer(),
                _customProgress(),
                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _customProgress() {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: 80,
          height: 80,
          child: CircleProgressBar(
            backgroundColor: Colors.white,
            foregroundColor:
                widget.foregroundColor ?? Theme.of(context).primaryColor,
            value: ((_currentPage + 1) * 1.0 / widget.introductionList!.length),
          ),
        ),
        Container(
          height: 55,
          width: 55,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: (widget.foregroundColor ?? Theme.of(context).primaryColor),
          ),
          child: IconButton(
            onPressed: () {
              _currentPage != widget.introductionList!.length - 1
                  ? _pageController.nextPage(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.ease,
                    )
                  : widget.onTapSkipButton!();
            },
            icon: const Icon(
              Icons.arrow_forward_ios,
              color: Colors.white,
              size: 15,
            ),
          ),
        )
      ],
    );
  }
}
