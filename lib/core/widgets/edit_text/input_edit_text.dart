import 'package:chat/config/themes/decoration_styles.dart';
import 'package:chat/config/themes/styles.dart';
import 'package:chat/config/themes/text_styles.dart';
import 'package:chat/config/themes/theme_colors.dart';
import 'package:chat/core/utils/view_utils.dart';
import 'package:chat/core/widgets/image_view.dart';
import 'package:flutter/material.dart';
import 'package:chat/main.dart';

class InputEditText extends StatelessWidget {
  const InputEditText({
    super.key,
    required this.controller,
    this.label,
    this.inputType,
    this.isOutlineBorder = true,
    this.readOnly = false,
    this.isDense = false,
    this.validationLabel,
    this.prefixLabel,
    this.prefixIcon,
    this.maxLines = 1,
    this.style,
    this.onValueSaved,
    this.onValueChanged,
    this.onTap,
  });

  final TextEditingController controller;
  final String? label;
  final TextInputType? inputType;
  final bool isOutlineBorder;
  final bool readOnly;
  final bool isDense;
  final String? validationLabel;
  final String? prefixLabel;
  final dynamic prefixIcon;
  final int? maxLines;
  final TextStyle? style;
  final void Function(String?)? onValueSaved;
  final void Function(String?)? onValueChanged;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: inputType,
      readOnly: readOnly,
      maxLines: maxLines,
      decoration: InputDecoration(
        border: isOutlineBorder
            ? DecorationStyles.editTextBorder
            : DecorationStyles.editTextUnderlineBorder,
        filled: !isOutlineBorder,
        fillColor: context.onSecondaryContainerColor,
        isDense: isDense,
        labelText: label,
        labelStyle: TextStyles.labelTextStyle,
        prefixText: prefixLabel,
        prefixStyle: TextStyles.labelTextStyle,
        prefixIcon: (prefixIcon != null)
            ? ImageView(
                imagePath: prefixIcon!,
                color: ThemeColors.lightGray,
              ).withPadding(p8)
            : null,
      ),
      style: style ?? TextStyles.titleTextStyle(context),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return validationLabel ?? label;
        }
        return null;
      },
      onChanged: (onValueChanged == null)
          ? null
          : (text) {
              logger.d(text);
              onValueChanged?.call(text);
            },
      onSaved: (onValueSaved == null)
          ? null
          : (text) {
              logger.d(text);
              onValueSaved?.call(text);
            },
      onTap: onTap,
    );
  }
}
