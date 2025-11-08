import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'compose.dart';

class TeacherDashboard extends StatefulWidget {
  const TeacherDashboard({super.key});
  @override
  State<TeacherDashboard> createState() => _TeacherDashboardState();
}

class _TeacherDashboardState extends State<TeacherDashboard> {
  final supabase = Supabase.instance.client;
  List<Map> classes = [];
  final TextEditingController _classNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadClasses();
  }

  @override
  void dispose() {
    _classNameController.dispose();
    super.dispose();
  }

  void loadClasses() async {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    final data = await supabase
        .from('classes')
        .select()
        .eq('teacher_id', user.id);  // This will only fetch classes for the current teacher
    setState(() => classes = data);
  }

  Future<void> showCreateClassDialog() async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Create New Class'),
          content: TextField(
            controller: _classNameController,
            decoration: const InputDecoration(
              labelText: 'Class Name',
              hintText: 'Enter class name',
            ),
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _classNameController.clear();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (_classNameController.text.isNotEmpty) {
                  createClass(_classNameController.text);
                  Navigator.pop(context);
                  _classNameController.clear();
                }
              },
              child: const Text('Create'),
            ),
          ],
        );
      },
    );
  }

  void createClass(String className) async {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    final code = const Uuid().v4().substring(0, 6).toUpperCase();
    await supabase.from('classes').insert({
      'name': className,
      'code': code,
      'teacher_id': user.id,  // Add this line to associate the class with the teacher
    });
    loadClasses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Teacher Dashboard')),
      body: ListView.builder(
        itemCount: classes.length,
        itemBuilder: (c, i) {
          final cls = classes[i];
          return ListTile(
            title: Text(cls['name']),
            subtitle: Text('Code: ${cls['code']}'),
            trailing: QrImageView(data: cls['code'], size: 80),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ComposeScreen(classId: cls['id']),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: showCreateClassDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}