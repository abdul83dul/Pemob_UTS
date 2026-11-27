import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'providers/task_provider.dart';
import 'screens/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(const TugasUtsKuApp());
}

class TugasUtsKuApp extends StatefulWidget {
  const TugasUtsKuApp({super.key});

  @override
  State<TugasUtsKuApp> createState() => _TugasUtsKuAppState();
}

class _TugasUtsKuAppState extends State<TugasUtsKuApp> {
  final TaskProvider _taskProvider = TaskProvider();

  @override
  void dispose() {
    _taskProvider.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tugas UTS Ku',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF1E1B4B),
        scaffoldBackgroundColor: const Color(0xFFF3F5F9),
      ),
      home: HomeScreen(provider: _taskProvider),
    );
  }
}