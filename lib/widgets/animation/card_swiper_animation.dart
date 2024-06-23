import 'dart:math';

import 'package:flutter/material.dart';

class CardSwipeAnimation extends StatefulWidget {
  const CardSwipeAnimation({super.key, required this.children});

  final List<Widget> children;
  @override
  State<CardSwipeAnimation> createState() => _CardSwipeAnimationState();
}

class _CardSwipeAnimationState extends State<CardSwipeAnimation> {
  late PageController _pageController;
  final int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController =
        PageController(initialPage: _currentIndex, viewportFraction: 0.8);
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 0.95,
      child: PageView.builder(
        clipBehavior: Clip.none,
        itemCount: widget.children.length,
        physics: const ClampingScrollPhysics(),
        controller: _pageController,
        itemBuilder: (context, index) {
          return carouselView(index);
        },
      ),
    );
  }

  Widget carouselView(int index) {
    return AnimatedBuilder(
      animation: _pageController,
      builder: (context, child) {
        double value = 0.0;
        if (_pageController.position.haveDimensions) {
          value = index.toDouble() - (_pageController.page ?? 0);
          value = (value * 0.03).clamp(-1, 1);
        }
        return Transform.rotate(
          angle: pi * value,
          child: widget.children[index],
        );
      },
      child: widget.children[index],
    );
  }
}
