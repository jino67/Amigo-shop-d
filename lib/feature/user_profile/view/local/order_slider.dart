import 'package:carousel_slider/carousel_slider.dart';
import 'package:e_com/core/core.dart';
import 'package:e_com/models/user_content/user_dash_model.dart';
import 'package:e_com/routes/go_route_name.dart';
import 'package:e_com/widgets/app_image.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class OrderSliderView extends ConsumerWidget {
  const OrderSliderView({
    super.key,
    required this.userDash,
  });

  final UserDashModel userDash;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: context.colorTheme.secondaryContainer.withOpacity(0.05),
        borderRadius: BorderRadius.circular(5),
      ),
      child: CarouselSlider.builder(
        itemCount: userDash.orders.listData.length,
        options: CarouselOptions(
          height: context.onMobile ? 112 : 200,
          viewportFraction: 1,
          initialPage: 0,
          autoPlay: true,
        ),
        itemBuilder: (context, index, _) {
          return Container(
            margin: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 10,
            ),
            decoration: BoxDecoration(
              border: Border.all(width: 0, color: context.colorTheme.primary),
              borderRadius: defaultRadius,
            ),
            child: InkWell(
              onTap: () {
                RouteNames.orderDetails.pushNamed(
                  context,
                  query: {'id': userDash.orders.listData[index].orderId},
                );
              },
              child: Padding(
                padding: defaultPaddingAll,
                child: Row(
                  children: [
                    const SizedBox(width: 10),
                    ClipRRect(
                      borderRadius: defaultRadius,
                      child: HostedImage(
                        height: context.onMobile ? 70 : 120,
                        width: context.onMobile ? 70 : 120,
                        userDash.orders.listData[index].orderDetails.firstOrNull
                                ?.product?.featuredImage ??
                            '',
                      ),
                    ),
                    const SizedBox(width: 10),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                userDash.orders.listData[index].status.title,
                                style: context.onMobile
                                    ? context.textTheme.bodyLarge!.copyWith(
                                        fontWeight: FontWeight.bold,
                                      )
                                    : context.textTheme.headlineSmall,
                              ),
                              Text(
                                userDash.orders.listData[index].orderDate
                                    .formatDate(context, 'dd MMM yyyy'),
                                style: context.onMobile
                                    ? context.textTheme.bodyMedium
                                    : context.textTheme.titleLarge,
                              )
                            ],
                          ),
                          Text(
                            'Your package has been ${userDash.orders.listData[index].status.name}.',
                            style: context.onMobile
                                ? context.textTheme.bodyMedium
                                : context.textTheme.titleLarge,
                          ),
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(text: Translator.tapTo(context)),
                                TextSpan(
                                  text: Translator.seeDetails(context),
                                  style: TextStyle(
                                    color: context.colorTheme.primary,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
