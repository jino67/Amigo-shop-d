import 'package:e_com/core/core.dart';
import 'package:e_com/models/models.dart';
import 'package:flutter/material.dart';

class ListViewWithFooter extends StatelessWidget {
  const ListViewWithFooter({
    super.key,
    this.pagination,
    this.onNext,
    this.onPrevious,
    required this.itemBuilder,
    this.emptyListWidget,
    this.itemCount,
    this.shrinkWrap = false,
    this.physics,
  });

  final PaginationInfo? pagination;
  final Function()? onNext;
  final Function()? onPrevious;
  final Widget? Function(BuildContext, int) itemBuilder;
  final Widget? emptyListWidget;
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
        if (itemCount == 0)
          SliverToBoxAdapter(
            child: emptyListWidget ??
                Center(
                  child: Text(Translator.nothingToShow(context)),
                ),
          )
        else
          SliverList.builder(
            itemBuilder: itemBuilder,
            itemCount: itemCount,
          ),
        const SliverToBoxAdapter(child: SizedBox(height: 10)),
        if (itemCount != 0)
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
                      icon: const Icon(Icons.arrow_back_ios_new_rounded,
                          size: 20),
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
        const SliverToBoxAdapter(child: SizedBox(height: 10)),
      ],
    );
  }
}
