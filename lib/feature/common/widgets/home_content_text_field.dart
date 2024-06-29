import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:roflit/feature/common/themes/text.dart';

class HomeContentTextField extends HookWidget {
  final TextEditingController controller;
  final String hint;
  final TextStyle? hintStyle;
  final bool obscureText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final int maxLength;
  final int? minLength;
  final void Function(String)? onSubmitted;

  const HomeContentTextField({
    required this.controller,
    required this.hint,
    this.hintStyle,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.onSubmitted,
    this.maxLength = 32,
    this.minLength,
    super.key,
  });

  Widget? suffixIconButton(ValueNotifier<bool> obscure) {
    if (suffixIcon == null) return null;
    return InkWell(
      onTap: () {
        obscure.value = !obscure.value;
      },
      child: AnimatedOpacity(
        opacity: obscure.value ? 1 : 0.5,
        duration: const Duration(milliseconds: 200),
        child: suffixIcon,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final obscure = useState(obscureText);

    return TextField(
      controller: controller,
      maxLength: maxLength,
      maxLines: 1,
      style: appTheme.textTheme.title2.onDark1,
      textAlign: TextAlign.center,
      obscureText: obscure.value,
      onSubmitted: onSubmitted,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        prefixIcon: prefixIcon,
        suffixIcon: suffixIconButton(obscure),
        focusedBorder: InputBorder.none,
        enabledBorder: InputBorder.none,
        errorBorder: InputBorder.none,
        disabledBorder: InputBorder.none,
        border: InputBorder.none,
        counterText: '',
        hintText: hint,
        hintStyle: hintStyle ?? appTheme.textTheme.title2.onDark1,
      ),
    );
  }
}
