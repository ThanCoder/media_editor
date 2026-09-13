import 'package:flutter/material.dart';

class InputText extends StatelessWidget {
  const new({
    super.key,
    required this.controller,
    this.label,
    this.maxLines,
    this.errorText,
    this.onChanged,
    this.onSubmitted,
    this.suffixIcon,
    this.focusNode,
    this.hint,
    this.style,
    this.onTapOutside,
  });
  final TextEditingController controller;
  final int? maxLines;
  final Widget? label;
  final String? errorText;
  final void Function(String val)? onChanged;
  final void Function(String val)? onSubmitted;
  final Widget? suffixIcon;
  final FocusNode? focusNode;
  final Widget? hint;
  final TextStyle? style;
  final void Function(PointerDownEvent event)? onTapOutside;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      maxLines: maxLines,
      style: style,
      decoration: InputDecoration(
        label: label,
        border: OutlineInputBorder(borderRadius: .circular(6)),
        errorText: errorText,
        suffixIcon: suffixIcon,
        hint: hint,
      ),
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      onTapOutside: onTapOutside,
    );
  }
}
