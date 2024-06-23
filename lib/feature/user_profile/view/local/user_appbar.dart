import 'package:e_com/core/core.dart';
import 'package:e_com/models/user_content/user_profile_model.dart';
import 'package:e_com/routes/go_route_name.dart';
import 'package:e_com/widgets/widgets.dart';
import 'package:flutter/material.dart';

class UserAppbar extends StatelessWidget {
  const UserAppbar({
    super.key,
    required this.user,
  });

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
        color: context.colorTheme.surface,
        boxShadow: [
          BoxShadow(
            blurRadius: 5,
            color: context.colorTheme.secondaryContainer.withOpacity(0.04),
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HeroWidget(
                  tag: user.image,
                  child: Container(
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: context.colorTheme.primary.withOpacity(0.05),
                      border: Border.all(
                          width: 0, color: context.colorTheme.primary),
                    ),
                    child: HostedImage(
                      user.image,
                      enablePreviewing: true,
                      fit: BoxFit.cover,
                      height: 100,
                      width: 100,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.name,
                      style: context.textTheme.titleLarge,
                    ),
                    if (user.email.isNotEmpty)
                      Text(
                        user.email,
                        style: context.textTheme.bodyLarge!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    if (user.phone.isNotEmpty)
                      Text(
                        user.phone,
                        style: context.textTheme.bodyLarge!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    Row(
                      children: [
                        OutlinedButton(
                          onPressed: () {
                            RouteNames.wishlist.goNamed(context);
                          },
                          child: Text(
                            Translator.wishlist(context),
                          ),
                        ),
                        const SizedBox(width: 10),
                        OutlinedButton(
                          onPressed: () {
                            RouteNames.carts.goNamed(context);
                          },
                          child: Text(
                            Translator.cart(context),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
