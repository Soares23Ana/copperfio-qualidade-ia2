import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:projeto_integrado/views/home/splash_intro_page.dart';
import 'package:projeto_integrado/viewmodels/dashboard_viewmodel.dart';
import 'package:projeto_integrado/viewmodels/feedbacks_viewmodel.dart';
import 'package:projeto_integrado/viewmodels/alertas_viewmodel.dart';
import 'package:projeto_integrado/viewmodels/chamados_viewmodel.dart';
import 'package:projeto_integrado/viewmodels/chat_viewmodel.dart';

void main() {
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
