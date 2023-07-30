import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DefaultTextField extends StatelessWidget {
  final ValueChanged<String>? onChanged;
  final String? label;
  final double? width;
  final double? height;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final bool obscureText;
  final FocusNode? focusNode;
  final VoidCallback? onTap;
  final bool enabled;
  final int? maxLines;
  final TextInputType keyboardType;
  final String? initialValue;
  final bool disabled;
  const DefaultTextField(
      {super.key,
      this.onChanged,
      this.enabled = true,
      this.disabled = false,
      this.label,
      this.keyboardType = TextInputType.text,
      this.maxLines,
      this.focusNode,
      this.initialValue,
      this.onTap,
      this.width,
      this.obscureText = false,
      this.height,
      this.controller,
      this.validator});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      focusNode: focusNode,
      readOnly: !enabled,
      enabled: !disabled,
      maxLines: maxLines ?? 1,
      decoration: InputDecoration(
        labelText: label,
        filled: disabled,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.r),
            borderSide: BorderSide(color: Theme.of(context).primaryColor)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: BorderSide(
              color: Theme.of(context).colorScheme.primary.withOpacity(.5)),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: const BorderSide(color: Colors.red),
        ),
        errorStyle: const TextStyle(color: Colors.red),
        labelStyle: TextStyle(
            color: Theme.of(context).colorScheme.primary.withOpacity(.44)),
        contentPadding: EdgeInsets.symmetric(horizontal: 21.w, vertical: 15.h),
      ),
      controller: controller,
      obscureText: obscureText,
      initialValue: initialValue,
      validator: validator,
      onChanged: onChanged,
      onTap: onTap,
      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
          color: Theme.of(context).colorScheme.primary.withOpacity(.9)),
      inputFormatters: [
        if (keyboardType == TextInputType.number)
          FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
      ],
    );
  }
}
