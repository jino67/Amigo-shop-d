// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:e_com/core/extensions/context_extension.dart';
import 'package:flutter/material.dart';

class CounterButton extends StatelessWidget {
  const CounterButton({
    super.key,
    required this.count,
    this.userBorder = false,
  });

  final int count;
  final bool userBorder;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: userBorder ? const EdgeInsets.all(8) : null,
      decoration: userBorder
          ? BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                color: context.colorTheme.primary.withOpacity(.3),
              ),
            )
          : null,
      child: Row(
        children: [
          Container(
            height: 30,
            width: 30,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: context.colorTheme.surfaceVariant,
            ),
            child: const Icon(Icons.remove),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text('$count', style: context.textTheme.titleLarge),
          ),
          Container(
            height: 30,
            width: 30,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: context.colorTheme.surfaceVariant,
            ),
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
