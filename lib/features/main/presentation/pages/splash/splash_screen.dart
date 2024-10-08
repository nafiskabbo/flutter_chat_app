import 'package:chat/features/auth/data/auth_service.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:chat/config/gen/assets.gen.dart';
import 'package:chat/config/routes/routes.dart';
import 'package:chat/config/themes/decoration_styles.dart';
import 'package:chat/config/themes/styles.dart';
import 'package:flutter/material.dart';
import 'package:chat/core/utils/view_utils.dart';
import 'package:chat/core/widgets/image_view.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      checkAndNavigate();
    });
  }

  Future<void> checkAndNavigate() async {
    navigateUser();
  }

  void navigateUser() {
    final route = AuthService().getCurrentUser() == null ? Routes.login : Routes.profiles;

    Future.delayed(const Duration(milliseconds: 400), () {
      context.goNamed(route.name);
    });
  }

  @override
  Widget build(BuildContext context) {
    final systemBarColors = DecorationStyles.appBarSystemUiOverlayStyle(context: context);
    SystemChrome.setSystemUIOverlayStyle(systemBarColors);

    return Scaffold(
      backgroundColor: context.primaryColor,
      body: ImageView(
        imagePath: Assets.imagesIcImageNotFound,
        color: context.onSurfaceColor,
        height: 64,
        width: 64,
      ).center().withPadding(px32),
    );
  }
}
