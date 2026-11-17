import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:ontime/firebase_options.dart';

import 'theme/app_theme.dart';
import 'screens/home_screen.dart';
import 'services/notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await NotificationService.initialize();

  runApp(const OnTimeApp());
}

// ============================================================
// 앱 기본 설정
// ============================================================

class OnTimeApp extends StatelessWidget {
  const OnTimeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: OnTimeTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      title: 'OnTime',
      home: const HomeScreen(),
    );
  }
}
