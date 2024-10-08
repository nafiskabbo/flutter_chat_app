import 'package:flutter/material.dart';
import 'package:chat/config/themes/styles.dart';
import 'package:chat/config/themes/theme_colors.dart';
import 'package:chat/core/utils/common_utils.dart';
import 'package:chat/core/utils/view_utils.dart';

class RadioButtonListView<T> extends StatelessWidget {
  final List<T> list;
  final T groupValue;
  final bool showRoundedBorder;
  final Widget itemPadding;
  final ScrollPhysics? physics;
  final String Function(T) getItemLabel;
  final String? Function(T)? getItemSubtitle;
  final String? Function(int, T)? getItemSubtitle2;
  final void Function(T?)? onChanged;

  const RadioButtonListView({
    super.key,
    required this.list,
    required this.groupValue,
    required this.getItemLabel,
    this.getItemSubtitle,
    this.getItemSubtitle2,
    this.showRoundedBorder = true,
    this.itemPadding = gapH8,
    this.physics,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: list.length,
      padding: py16,
      shrinkWrap: true,
      physics: physics,
      separatorBuilder: (context, index) => itemPadding,
      itemBuilder: (context, index) {
        final item = list[index];
        return Material(
          type: MaterialType.transparency,
          child: RadioListTile<T>(
            value: item,
            groupValue: groupValue,
            title: Text(
              getItemLabel(item),
              style: TextStyle(
                fontSize: 16,
                color: context.onSurfaceColor,
              ),
            ),
            subtitle: ((getItemSubtitle == null || getItemSubtitle!(item) == null) &&
                    getItemSubtitle2 == null)
                ? null
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (getItemSubtitle?.call(item) != null)
                        Text(
                          getItemSubtitle!(item)!,
                          style: const TextStyle(
                            fontSize: 12,
                            color: ThemeColors.darkGray,
                          ),
                        ),
                      if (getItemSubtitle2?.call(index, item) != null)
                        Text(
                          getItemSubtitle2!(index, item)!,
                          style: TextStyle(
                            fontSize: 14,
                            color: context.onSurfaceColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                    ],
                  ),
            visualDensity: VisualDensity.compact,
            shape: showRoundedBorder
                ? 48.roundedBorder(
                    side: BorderSide(
                      color: context.primaryColor.withOpacity(.3),
                      width: 2,
                    ),
                  )
                : null,
            onChanged: onChanged,
          ),
        );
      },
    );
  }
}
