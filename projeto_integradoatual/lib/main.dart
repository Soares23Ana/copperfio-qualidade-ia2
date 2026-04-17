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

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DashboardViewModel()),
        ChangeNotifierProvider(create: (_) => FeedbacksViewModel()),
        ChangeNotifierProvider(create: (_) => AlertasViewModel()),
        ChangeNotifierProvider(create: (_) => ChamadosViewModel()),
        ChangeNotifierProvider(create: (_) => ChatViewModel()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'P1 - Desenvolvimento Mobile',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: const SplashIntroPage(),
    );
  }
}
