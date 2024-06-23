import 'package:badges/badges.dart' as badges;
import 'package:e_com/core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_fonts/google_fonts.dart';

import 'nav_destination.dart';

class NavButton extends HookWidget {
  const NavButton({
    super.key,
    required this.destination,
    required this.index,
    required this.onPressed,
    required this.selectedIndex,
    required this.count,
  });

  final KNavDestination destination;
  final int index;
  final int selectedIndex;
  final void Function()? onPressed;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: destination.focused
          ? const EdgeInsets.symmetric(horizontal: 12).copyWith(bottom: 10)
          : const EdgeInsets.symmetric(horizontal: 5, vertical: 15),
      child: MaterialButton(
        elevation: destination.focused ? 0 : null,
        splashColor: context.colorTheme.primary.withOpacity(.3),
        shape: destination.focused
            ? const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(15),
                ),
              )
            : const StadiumBorder(),
        height: double.maxFinite,
        padding: destination.focused
            ? const EdgeInsets.only(top: 2)
            : EdgeInsets.zero,
        color: destination.focused ? context.colorTheme.primary : null,
        onPressed: onPressed,
        child: destination.focused
            ? CircleAvatar(
                radius: 25,
                backgroundColor: context.colorTheme.surfaceTint,
                child: Icon(
                  destination.icon,
                  color: context.colorTheme.primary,
                ),
              )
            : badges.Badge(
                showBadge: index == 3,
                badgeContent: Text(
                  count.toString(),
                  style: context.textTheme.bodyLarge!
                      .copyWith(color: context.colorTheme.background),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      selectedIndex == index
                          ? destination.selectedIcon
                          : destination.icon,
                      size: 25,
                      color: selectedIndex == index
                          ? context.colorTheme.primary
                          : context.colorTheme.outline,
                    ),
                    Text(
                      destination.text,
                      maxLines: 1,
                      style: GoogleFonts.saira(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: selectedIndex == index
                            ? context.colorTheme.onBackground
                            : context.colorTheme.outline,
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
