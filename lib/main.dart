import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:worship_connect/wc_core/worship_connect.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

  runApp(
    const ProviderScope(
      child: WorshipConnect(),
    ),
  );
}

// TODO code cleanup
