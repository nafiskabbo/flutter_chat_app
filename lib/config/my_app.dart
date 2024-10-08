import 'package:flutter/material.dart';
import 'package:chat/config/routes/app_router.dart';
import 'package:chat/config/themes/themes.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Chat',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.light,
      theme: Themes.light(),
      routerConfig: AppRouter.router,
    );
  }
}
