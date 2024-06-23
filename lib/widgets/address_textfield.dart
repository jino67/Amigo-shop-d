import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class KTextField extends StatelessWidget {
  const KTextField({
    super.key,
    required this.hinText,
    required this.title,
    required this.name,
    this.controller,
    this.isPhone = false,
    this.keyboardType,
    this.textInputAction,
    this.validator,
    this.onSubmitted,
    this.onChanged,
    this.autofillHints = const [],
  });

  final String hinText;
  final String title;
  final String name;
  final bool isPhone;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final String? Function(String?)? validator;
  final void Function(String? value)? onSubmitted;
  final void Function(String? value)? onChanged;
  final Iterable<String>? autofillHints;

  @override
  Widget build(BuildContext context) {
    return FormBuilderTextField(
      name: name,
      onChanged: onChanged,
      validator: validator,
      // initialValue: controller?.text,

      autofillHints: autofillHints,
      onSubmitted: onSubmitted,
      textInputAction: textInputAction,
      controller: controller,

      // onChanged: (v) {
      //   field.didChange(v);
      // },
      keyboardType: keyboardType ?? (isPhone ? TextInputType.phone : null),
      inputFormatters: [
        if (isPhone) LengthLimitingTextInputFormatter(14),
      ],
      decoration: InputDecoration(
        hintText: hinText,
        // contentPadding: const EdgeInsets.all(18),
      ),
    );
  }
}
