import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TeacherDashboard extends StatefulWidget {
  const TeacherDashboard({super.key});
  @override State<TeacherDashboard> createState() => _TeacherDashboardState();
}

class _TeacherDashboardState extends State<TeacherDashboard> {
  final supabase = Supabase.instance.client;
  List<Map> classes = [];

  @override void initState() {
    super.initState();
    loadClasses();
  }

  void loadClasses() async {
    final data = await supabase.from('classes').select();
    setState(() => classes = data);
  }

  void createClass() async {
    final code = const Uuid().v4().substring(0, 6).toUpperCase();
    await supabase.from('classes').insert({'name': 'New Class', 'code': code});
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
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ComposeScreen(classId: cls['id']))),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: createClass,
        child: const Icon(Icons.add),
      ),
    );
  }
}
