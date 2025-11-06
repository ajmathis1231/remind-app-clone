import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ComposeScreen extends StatelessWidget {
  final String classId;
  const ComposeScreen({required this.classId, super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = TextEditingController();
    return Scaffold(
      appBar: AppBar(title: const Text('Send Message')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          TextField(controller: ctrl, decoration: const InputDecoration(hintText: 'Message')),
          ElevatedButton(
            onPressed: () async {
              await Supabase.instance.client.from('messages').insert({
                'class_id': classId,
                'text': ctrl.text,
                'sms': true,
                'email': true,
              });
              Navigator.pop(context);
            },
            child: const Text('Blast → Push + Email + SMS'),
          ),
        ]),
      ),
    );
  }
}
