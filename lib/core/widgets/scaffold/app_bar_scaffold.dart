import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:chat/core/utils/view_utils.dart';

class AppBarScaffold extends StatelessWidget {
  final String pageTitle;
  final EdgeInsetsDirectional padding;
  final Widget? child;
  final List<Widget>? children;
  final List<Widget>? appBarActions;
  final bool useScrollView;
  final bool showScrollbar;
  final bool automaticallyImplyLeading;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final Widget? floatingActionButton;

  const AppBarScaffold({
    super.key,
    required this.pageTitle,
    this.padding = EdgeInsetsDirectional.zero,
    this.child,
    this.children,
    this.appBarActions,
    this.useScrollView = false,
    this.showScrollbar = false,
    this.automaticallyImplyLeading = true,
    this.floatingActionButtonLocation,
    this.floatingActionButton,
  });

  @override
  Widget build(BuildContext context) {
    // final isDarkTheme = context.isDarkMode;

    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: context.primaryColor,
          statusBarBrightness: Brightness.light,
          statusBarIconBrightness: Brightness.light,
          systemNavigationBarIconBrightness: Brightness.light,
          // statusBarBrightness: isDarkTheme ? Brightness.dark : Brightness.light,
          // statusBarIconBrightness: isDarkTheme ? Brightness.dark : Brightness.light,
          // systemNavigationBarIconBrightness: isDarkTheme ? Brightness.dark : Brightness.light,
        ),
        backgroundColor: context.surfaceColor,
        foregroundColor: context.onTertiaryColor,
        title: Text(pageTitle),
        actions: appBarActions,
        scrolledUnderElevation: 0.0,
        automaticallyImplyLeading: automaticallyImplyLeading,
      ),
      body: useScrollView
          ? showScrollbar
              ? CupertinoScrollbar(child: _buildScrollView())
              : _buildScrollView()
          : (_buildViewsContainer()),
      floatingActionButtonLocation: floatingActionButtonLocation,
      floatingActionButton: floatingActionButton,
    );
  }

  Widget _buildScrollView() => SingleChildScrollView(child: _buildViewsContainer());

  Widget _buildViewsContainer() => (child ??
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children!,
          ))
      .withPadding(padding);
}
