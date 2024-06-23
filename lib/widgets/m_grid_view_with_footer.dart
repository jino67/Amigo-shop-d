import 'package:e_com/core/core.dart';
import 'package:e_com/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class MGridViewWithFooter extends StatelessWidget {
  const MGridViewWithFooter({
    super.key,
    this.pagination,
    this.onNext,
    this.onPrevious,
    required this.crossAxisCount,
    this.mainAxisSpacing,
    this.crossAxisSpacing,
    required this.builder,
    this.itemCount,
    this.shrinkWrap = false,
    this.physics,
  });

  final PaginationInfo? pagination;
  final Function()? onNext;
  final Function()? onPrevious;
  final int crossAxisCount;
  final double? mainAxisSpacing;
  final double? crossAxisSpacing;
  final Widget? Function(BuildContext, int) builder;
  final int? itemCount;
  final bool shrinkWrap;
  final ScrollPhysics? physics;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      shrinkWrap: shrinkWrap,
      clipBehavior: Clip.none,
      physics: physics,
      slivers: [
        SliverMasonryGrid(
          mainAxisSpacing: mainAxisSpacing ?? 0,
          crossAxisSpacing: crossAxisSpacing ?? 0,
          gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
          ),
          delegate: SliverChildBuilderDelegate(
            builder,
            childCount: itemCount,
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 10)),
        if (pagination != null)
          SliverToBoxAdapter(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (pagination?.prevPageUrl != null)
                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: context.colorTheme.secondary,
                    ),
                    onPressed: () => onPrevious?.call(),
                    icon:
                        const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
                    label: Text(Translator.previous(context)),
                  ),
                const SizedBox(width: 10),
                if (pagination?.nextPageUrl != null)
                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: context.colorTheme.secondary,
                    ),
                    onPressed: () => onNext?.call(),
                    icon: Text(Translator.next(context)),
                    label:
                        const Icon(Icons.arrow_forward_ios_rounded, size: 20),
                  ),
                const SizedBox(width: 10),
              ],
            ),
          ),
      ],
    );
  }
}
