import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'theme/app_theme.dart';
import 'services/supabase_service.dart';
import 'admin/admin_gate_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SupabaseService.init();
  runApp(const AyaGraphiqueApp());
}

class AyaGraphiqueApp extends StatelessWidget {
  const AyaGraphiqueApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Aya's Graphique — Illustrator & Logo Designer",
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        // Not linked from the public site — visit /#/admin directly.
        '/admin': (context) => const AdminGateScreen(),
      },
    );
  }
}
