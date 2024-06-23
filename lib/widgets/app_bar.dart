import 'package:e_com/core/core.dart';
import 'package:flutter/material.dart';

class _PreferredAppBarSize extends Size {
  const _PreferredAppBarSize(this.toolbarHeight, this.bottomHeight)
      : super.fromHeight(
          (toolbarHeight ?? (bottomHeight == null ? kToolbarHeight : 94)) +
              (bottomHeight ?? 0),
        );

  final double? toolbarHeight;
  final double? bottomHeight;
}

class KAppBar extends StatelessWidget implements PreferredSizeWidget {
  KAppBar({
    super.key,
    this.title,
    this.actions,
    this.bottom,
    this.leading,
    this.leadingWidth,
    this.toolbarHeight,
    this.color,
  })  : showLeading = leading != null,
        preferredSize =
            _PreferredAppBarSize(toolbarHeight, bottom?.preferredSize.height);

  final Widget? title;
  final List<Widget>? actions;
  final bool showLeading;
  final PreferredSizeWidget? bottom;
  final Widget? leading;
  final double? leadingWidth;
  final double? toolbarHeight;
  final Color? color;
  @override
  final Size preferredSize;

  @override
  Widget build(BuildContext context) {
    double defLeadingWidth = showLeading ? 70 : 0;
    return AppBar(
      elevation: 0,
      backgroundColor: color,
      automaticallyImplyLeading: false,
      leadingWidth: leadingWidth ?? defLeadingWidth,
      leading: showLeading ? leading : null,
      title: title,
      actions: actions,
      bottom: bottom,
    );
  }
}

class AppBarTextField extends StatelessWidget implements PreferredSizeWidget {
  const AppBarTextField({
    super.key,
    this.controller,
    this.suffix,
    this.onSubmit,
    this.onChanged,
    this.showFieldSuffix = true,
    this.color,
    this.hint = '',
    this.borderRadius,
    this.useShadow = true,
    this.filled = false,
    this.isDense,
    this.focusNode,
  }) : preferredSize = const Size.fromHeight(kToolbarHeight);

  final TextEditingController? controller;
  final Widget? suffix;
  final bool showFieldSuffix;
  final String hint;
  final Function()? onSubmit;
  final Function(String text)? onChanged;
  final Color? color;
  final BorderRadiusGeometry? borderRadius;
  final bool useShadow;
  final bool filled;
  final bool? isDense;
  final FocusNode? focusNode;

  @override
  final Size preferredSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: borderRadius ??
            const BorderRadius.vertical(bottom: Corners.medRadius),
        color: color ?? context.colorTheme.surface,
        boxShadow: useShadow
            ? null
            : [
                BoxShadow(
                  blurRadius: 5,
                  color: context.colorTheme.secondaryContainer.withOpacity(0.2),
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: Padding(
        padding:
            const EdgeInsets.symmetric(horizontal: 18).copyWith(bottom: 18),
        child: Row(
          children: [
            Flexible(
              child: TextField(
                controller: controller,
                focusNode: focusNode,
                textInputAction: TextInputAction.search,
                onSubmitted: (v) => onSubmit?.call(),
                onChanged: onChanged,
                decoration: InputDecoration(
                  isDense: isDense,
                  filled: filled,
                  suffixIcon: showFieldSuffix
                      ? IconButton(
                          onPressed: onSubmit,
                          icon: const Icon(Icons.search_outlined),
                        )
                      : null,
                  hintText: hint,
                ),
              ),
            ),
            if (suffix != null)
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: suffix!,
              ),
          ],
        ),
      ),
    );
  }
}
