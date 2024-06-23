import 'package:e_com/core/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddressTextfield extends StatelessWidget {
  const AddressTextfield({
    super.key,
    required this.hinText,
    required this.title,
    this.isPhone = false,
    this.keyboardType,
  });

  final String hinText;
  final String title;
  final bool isPhone;
  final TextInputType? keyboardType;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: context.textTheme.bodyLarge,
          ),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                textAlign: TextAlign.right,
                keyboardType:
                    keyboardType ?? (isPhone ? TextInputType.number : null),
                inputFormatters: isPhone
                    ? [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(11),
                      ]
                    : null,
                decoration: InputDecoration(
                  hintText: hinText,
                  filled: false,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.all(18),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
