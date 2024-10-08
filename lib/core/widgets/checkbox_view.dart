import 'package:chat/config/themes/theme_colors.dart';
import 'package:chat/core/utils/view_utils.dart';
import 'package:flutter/material.dart';

class CheckboxView extends StatefulWidget {
  final double? size;
  final double? iconSize;
  final Function(bool) onChange;
  final Color? backgroundColor;
  final Color? iconColor;
  final Color? borderColor;
  final IconData? icon;

  const CheckboxView({
    super.key,
    this.size,
    this.iconSize,
    required this.onChange,
    this.backgroundColor,
    this.iconColor,
    this.borderColor,
    this.icon,
  });

  @override
  State<CheckboxView> createState() => _CheckboxViewState();
}

class _CheckboxViewState extends State<CheckboxView> {
  bool _isChecked = false;

  @override
  Widget build(BuildContext context) {
    return CheckboxStatelessView(
      size: widget.size,
      iconSize: widget.iconSize,
      backgroundColor: widget.backgroundColor,
      iconColor: widget.iconColor,
      borderColor: widget.borderColor,
      icon: widget.icon,
      isChecked: _isChecked,
      onChange: (newValue) {
        widget.onChange(newValue);
        setState(() {
          _isChecked = newValue;
        });
      },
    );
  }
}

class CheckboxStatelessView extends StatelessWidget {
  final double? size;
  final double? iconSize;
  final Function(bool) onChange;
  final Color? backgroundColor;
  final Color? iconColor;
  final Color? borderColor;
  final IconData? icon;
  final bool isChecked;

  const CheckboxStatelessView({
    super.key,
    this.size,
    this.iconSize,
    required this.onChange,
    this.backgroundColor,
    this.iconColor,
    this.icon,
    this.borderColor,
    required this.isChecked,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (!isChecked) onChange(!isChecked);
      },
      child: InkWell(
        splashColor: context.primaryColor,
        child: AnimatedContainer(
          height: size ?? 28,
          width: size ?? 28,
          duration: const Duration(milliseconds: 500),
          curve: Curves.fastLinearToSlowEaseIn,
          decoration: BoxDecoration(
            borderRadius: BorderRadiusDirectional.circular(7.0),
            color: isChecked ? backgroundColor ?? context.primaryColor : Colors.transparent,
            border: Border.all(
              color: isChecked
                  ? context.onSurfaceColor.withOpacity(.9)
                  : borderColor ?? ThemeColors.lightGray,
            ),
          ),
          child: isChecked
              ? Icon(
                  icon ?? Icons.check_rounded,
                  color: iconColor ?? context.onSurfaceColor.withOpacity(.7),
                  size: iconSize ?? 16,
                )
              : null,
        ),
      ),
    );
  }
}
