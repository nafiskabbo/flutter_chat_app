import 'package:flutter/material.dart';
import 'package:chat/core/utils/common_utils.dart';
import 'package:chat/core/utils/view_utils.dart';

class FilledBorderButtonWidget extends StatelessWidget {
  final String text;
  final void Function()? onPressed;

  const FilledBorderButtonWidget({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        fixedSize: Size(context.width, 62),
        foregroundColor: context.onSurfaceColor,
        backgroundColor: context.primaryColor,
        shape: 16.roundedBorder(),
        side: BorderSide(
          width: 2.0,
          color: context.onSurfaceColor.withOpacity(.5),
        ),
        textStyle: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
          color: context.onSurfaceColor,
        ),
      ),
      onPressed: onPressed,
      child: Text(text),
    );
  }
}
