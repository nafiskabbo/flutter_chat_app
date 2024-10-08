import 'package:chat/config/my_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:chat/core/di/app_injections.dart';

final logger = Logger(
  printer: PrettyPrinter(methodCount: 1),
);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ],
  );

  await initAppInjections();
  runApp(const MyApp());
}
