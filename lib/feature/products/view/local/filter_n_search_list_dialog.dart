import 'package:auto_animated_list/auto_animated_list.dart';
import 'package:e_com/core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class FilterNSearchListDialog<T> extends HookConsumerWidget {
  const FilterNSearchListDialog({
    super.key,
    required this.listData,
    required this.labelBuilder,
    required this.onConfirm,
    required this.title,
    this.hinText = '',
  });

  final List<T> listData;
  final String title;
  final String hinText;
  final Function(T data) onConfirm;
  final String Function(T data) labelBuilder;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchCtrl = useTextEditingController();
    final stateData = useState(listData);

    searchList() {
      if (searchCtrl.text.isEmpty) return stateData.value = listData;

      stateData.value = listData.where((element) {
        return labelBuilder(element)
            .toLowerCase()
            .replaceAll(' ', '')
            .contains(searchCtrl.text.toLowerCase().replaceAll(' ', ''));
      }).toList();
    }

    return Dialog(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: context.height * 0.7),
        child: SingleChildScrollView(
          physics: defaultScrollPhysics,
          padding: const EdgeInsets.all(15),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Text(
                    title,
                    style: context.textTheme.titleLarge,
                  ),
                  const Spacer(),
                  IconButton.outlined(
                    onPressed: () {
                      searchCtrl.clear();
                      stateData.value = listData;
                      context.pop();
                    },
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: searchCtrl,
                      onChanged: (value) => searchList(),
                      onSubmitted: (value) => searchList(),
                      decoration: InputDecoration(
                        hintText: hinText,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  IconButton(
                    style: IconButton.styleFrom(
                      backgroundColor: context.colorTheme.secondaryContainer,
                      foregroundColor: context.colorTheme.onSecondaryContainer,
                      iconSize: 30,
                      fixedSize: const Size(60, 60),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () => searchList(),
                    icon: const Icon(Icons.search, size: 30),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              AutoAnimatedList<T>(
                shrinkWrap: true,
                items: stateData.value,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, data, index, animation) {
                  return SizeFadeTransition(
                    animation: animation,
                    child: ListTile(
                      onTap: () {
                        onConfirm(data);
                        context.pop();
                      },
                      dense: true,
                      title: Text(
                        labelBuilder(data),
                        style: context.textTheme.titleMedium,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
