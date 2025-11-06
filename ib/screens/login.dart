import 'package:flutter/material.dart';
import 'teacher_dashboard.dart';
import 'student_feed.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Remind Clone', style: Theme.of(context).textTheme.headline3),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const TeacherDashboard())),
              child: const Text('I’m a Teacher'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const StudentFeed())),
              child: const Text('I’m a Student / Parent'),
            ),
          ],
        ),
      ),
    );
  }
}
