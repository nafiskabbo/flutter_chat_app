import 'package:chat/config/gen/assets.gen.dart';
import 'package:chat/config/themes/styles.dart';
import 'package:chat/core/utils/view_utils.dart';
import 'package:chat/core/widgets/image_view.dart';
import 'package:flutter/material.dart';

class ErrorView extends StatelessWidget {
  final String error;

  const ErrorView({super.key, required this.error});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ImageView(
          imagePath: Assets.imagesErrorView,
          width: context.width - 100,
        ),
        gapH16,
        Text(
          error,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: context.errorColor,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ).withPadding(px16),
      ],
    ).center();
  }
}
