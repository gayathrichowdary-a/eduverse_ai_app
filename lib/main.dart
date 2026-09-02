import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'screens/authentication/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://vhinpqngeownrpjnsuay.supabase.co',
    anonKey: 'sb_publishable_BDYE5Y74y2J_2FhJkEykEw_YnKto2fR',
  );

  runApp(const EduVerseAI());
}

class EduVerseAI extends StatelessWidget {
  const EduVerseAI({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'EduVerse AI',

      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFEF3340),
        ),
        useMaterial3: true,
      ),

      home: const SplashScreen(),
    );
  }
}