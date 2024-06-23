import 'package:carousel_slider/carousel_slider.dart';
import 'package:e_com/core/core.dart';
import 'package:e_com/widgets/app_image.dart';
import 'package:flutter/material.dart';
import 'package:e_com/models/models.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class ImageSlider extends HookConsumerWidget {
  const ImageSlider({
    super.key,
    required this.banners,
  });
  final List<BannersData> banners;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = useState(0);
    return Stack(
      children: [
        CarouselSlider.builder(
          itemCount: banners.length,
          options: CarouselOptions(
            onPageChanged: (index, reason) => currentIndex.value = index,
            autoPlayCurve: Curves.easeInExpo,
            height: context.onMobile ? 185 : 360,
            viewportFraction: 1,
            initialPage: 0,
            autoPlay: true,
          ),
          itemBuilder: (context, index, realIndex) {
            final banner = banners[index];
            return Padding(
              padding: defaultPadding,
              child: ClipRRect(
                borderRadius: defaultRadius,
                child: HostedImage(
                  banner.bgImage,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
            );
          },
        ),
        Positioned(
          bottom: 10,
          right: 40,
          child: AnimatedSmoothIndicator(
            activeIndex: currentIndex.value,
            count: banners.length,
            effect: CustomizableEffect(
              dotDecoration: DotDecoration(
                height: 8,
                width: 8,
                color: context.colorTheme.primary.withOpacity(.5),
                borderRadius: defaultRadius,
              ),
              activeDotDecoration: DotDecoration(
                height: 8,
                width: 20,
                color: context.colorTheme.primary,
                borderRadius: defaultRadius,
              ),
              spacing: 6,
            ),
          ),
        ),
      ],
    );
  }
}
