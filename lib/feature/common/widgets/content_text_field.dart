import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:roflit/feature/common/themes/colors.dart';
import 'package:roflit/feature/common/themes/text.dart';

class ContentTextField extends HookWidget {
  final TextEditingController controller;
  final TextAlign? textAlign;
  final String hint;
  final TextStyle? style;
  final TextStyle? hintStyle;
  final bool obscureText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final int maxLength;
  final int? minLength;
  final void Function(String)? onSubmitted;
  final void Function(String)? onChanged;
  final double? cursorWidth;
  final Color? cursorColor;
  final List<TextInputFormatter> filterInputFormatters;

  const ContentTextField({
    required this.controller,
    required this.hint,
    this.textAlign,
    this.style,
    this.hintStyle,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.onChanged,
    this.onSubmitted,
    this.maxLength = 32,
    this.minLength,
    this.cursorWidth,
    this.cursorColor,
    this.filterInputFormatters = const [],
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
      style: style ?? appTheme.textTheme.title2.onDark1,
      textAlign: textAlign ?? TextAlign.center,
      obscureText: obscure.value,
      onSubmitted: onSubmitted,
      keyboardType: TextInputType.text,
      onChanged: onChanged,
      cursorWidth: cursorWidth ?? 2,
      cursorColor: cursorColor ?? const Color(AppColors.borderLineOnDart0),
      inputFormatters: filterInputFormatters,
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
