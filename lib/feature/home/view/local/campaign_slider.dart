import 'package:carousel_slider/carousel_slider.dart';
import 'package:e_com/core/core.dart';
import 'package:e_com/models/models.dart';
import 'package:e_com/routes/go_route_name.dart';
import 'package:e_com/widgets/app_image.dart';
import 'package:e_com/widgets/count_down_timer.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CampaignSlider extends HookConsumerWidget {
  const CampaignSlider({
    required this.campaigns,
    super.key,
  });
  final List<CampaignModel> campaigns;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CarouselSlider.builder(
      options: CarouselOptions(
        enlargeFactor: 0,
        viewportFraction: 1,
        autoPlayCurve: Curves.easeInExpo,
        initialPage: 0,
        height: context.onMobile ? 200 : 300,
      ),
      itemCount: campaigns.length,
      itemBuilder: (context, index, realIndex) {
        final campaign = campaigns[index];
        return InkWell(
          onTap: () {
            RouteNames.campaignDetails
                .pushNamed(context, pathParams: {'id': campaign.uid});
          },
          child: Stack(
            children: [
              HostedImage(
                width: double.infinity,
                campaign.image,
                height: context.onMobile ? 200 : 300,
                fit: BoxFit.cover,
              ),
              Positioned(
                top: 5,
                right: 5,
                child: TimerCountdown(
                  color: context.colorTheme.surface,
                  duration: campaign.endTime.difference(DateTime.now()),
                ),
              ),
              Positioned(
                child: IgnorePointer(
                  child: Container(
                    height: context.onMobile ? 200 : 300,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: <Color>[
                          context.colorTheme.secondaryContainer
                              .withOpacity(0.001),
                          context.colorTheme.secondaryContainer
                              .withOpacity(0.005),
                          context.colorTheme.secondaryContainer
                              .withOpacity(0.01),
                          context.colorTheme.secondaryContainer
                              .withOpacity(0.05),
                          context.colorTheme.secondaryContainer,
                        ],
                        tileMode: TileMode.mirror,
                      ),
                    ),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: Text(
                          campaign.name,
                          style: context.textTheme.titleLarge!.copyWith(
                            color: context.colorTheme.onSecondary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
