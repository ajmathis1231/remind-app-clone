import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://remind-ajmathis1231.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InJlbWluZC1ham1hdGhpczEyMzEiLCJyb2xlIjoiYW5vbiIsImlhdCI6MTczMDg1NzYwMCwiZXhwIjoyMDQ2NDMzNjAwfQ.9vX8zL5kPqRj7sT2uV0wXyZaBcDeFgHiJkLmNoPqRs',
  );
  runApp(const RemindApp());
}

class RemindApp extends StatelessWidget {
  const RemindApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Remind Clone',
      theme: ThemeData(primarySwatch: Colors.purple),
      home: const LoginScreen(),
    );
  }
}
