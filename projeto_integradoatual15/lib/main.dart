import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';
import 'package:projeto_integrado/features/splash/view/splash_intro_page.dart';
import 'package:projeto_integrado/features/dashboard/viewmodel/dashboard_viewmodel.dart';
import 'package:projeto_integrado/features/dashboard/viewmodel/feedbacks_viewmodel.dart';
import 'package:projeto_integrado/features/dashboard/viewmodel/alertas_viewmodel.dart';
import 'package:projeto_integrado/features/chamados/viewmodel/chamados_viewmodel.dart';
import 'package:projeto_integrado/features/chat/viewmodel/chat_viewmodel.dart';
import 'package:projeto_integrado/core/favorites_provider.dart';
import 'package:projeto_integrado/core/theme_provider.dart';
import 'package:projeto_integrado/services/notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.dumpErrorToConsole(details);
  };

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    // Firebase app already initialized (happens on Android)
    debugPrint('Firebase already initialized: $e');
  }

  try {
    await NotificationService().initialize();
  } catch (e) {
    debugPrint('Error initializing notifications: $e');
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => DashboardViewModel()),
        ChangeNotifierProvider(create: (_) => FeedbacksViewModel()),
        ChangeNotifierProvider(create: (_) => AlertasViewModel()),
        ChangeNotifierProvider(create: (_) => ChamadosViewModel()),
        ChangeNotifierProvider(create: (_) => ChatViewModel()),
        ChangeNotifierProvider(create: (_) => FavoritesProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'P1 - Desenvolvimento Mobile',
          debugShowCheckedModeBanner: false,
          theme: themeProvider.currentTheme,
          home: const SplashIntroPage(),
        );
      },
    );
  }
}
