import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'screens/VerificationPendingScreen.dart';
import 'screens/student_login.dart';
import 'screens/teacher_login.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
      url: 'https://dhxudkeopzminirznkon.supabase.co',
      anonKey: 'sb_publishable_uxEEPU4pOkfyGqhVXqcSVg_wgbK3Rgg',
      debug: true
  );
  runApp(const RemindApp());
}



class RemindApp extends StatefulWidget {
  const RemindApp({super.key});

  @override
  State<RemindApp> createState() => _RemindAppState();
}

class _RemindAppState extends State<RemindApp> {
  @override
  void initState() {
    super.initState();
    Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      final AuthChangeEvent event = data.event;
      final Session? session = data.session;

      print('Auth State Change: $event');
      if (session != null) {
        print('User ID: ${session.user.id}');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Remind Clone',
      theme: ThemeData(primarySwatch: Colors.purple),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/teacher-login': (context) => const TeacherLoginScreen(),
        '/student-login': (context) => const StudentLoginScreen(),
        '/verification-pending': (context) => const VerificationPendingScreen(),
      },
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome to Remind'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/teacher-login');
              },
                child: const Text('I am a Teacher'),
              ),

            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/student-login');
              },
              child: const Text('I am a Student/Parent'),
            ),
          ],
        ),
      ),
    );
  }
}