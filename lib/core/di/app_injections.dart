import 'dart:async';

import 'package:get_it/get_it.dart';
import 'package:chat/config/routes/app_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final getIt = GetIt.instance;

Future<void> initAppInjections() async {
  AppRouter.instance;
  await Supabase.initialize(
    url: 'https://hcnaygikkvbwojwymeyi.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImhjbmF5Z2lra3Zid29qd3ltZXlpIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MjgzNzE2MzEsImV4cCI6MjA0Mzk0NzYzMX0.nSA-5Lef0KWyamiSmZXxx9oTge483Nh9jdofmVys3Cw',
  );
}
