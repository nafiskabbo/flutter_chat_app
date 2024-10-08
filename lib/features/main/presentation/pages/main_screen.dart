import 'package:flutter/material.dart';
import 'package:chat/config/themes/theme_colors.dart';
import 'package:chat/core/utils/view_utils.dart';
import 'package:chat/core/widgets/image_view.dart';
import 'package:chat/features/main/domain/utils/navigation_bar_items.dart';
import 'package:go_router/go_router.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key, required this.child});

  final StatefulNavigationShell child;

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: widget.child,
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Divider(color: context.secondaryColor, height: 0),
          NavigationBar(
            indicatorColor: context.primaryColor.withOpacity(.25),
            elevation: 16,
            selectedIndex: widget.child.currentIndex,
            onDestinationSelected: (index) {
              widget.child.goBranch(
                index,
                initialLocation: index == widget.child.currentIndex,
              );
              setState(() {});
            },
            destinations: NavigationBarItems.values.map((item) {
              return NavigationDestination(
                icon: ImageView(imagePath: item.icon, color: ThemeColors.darkGray),
                label: item.label,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
