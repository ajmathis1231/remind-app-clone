import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ComposeScreen extends StatefulWidget {
  final String classId;

  const ComposeScreen({super.key, required this.classId});

  @override
  State<ComposeScreen> createState() => _ComposeScreenState();
}

class _ComposeScreenState extends State<ComposeScreen> {
  final _supabase = Supabase.instance.client;
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();
  bool _sendEmail = true;
  bool _sendSMS = false;
  bool _isSending = false;

  @override
  void dispose() {
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _sendMessage() async {
    if (_subjectController.text.isEmpty || _messageController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    setState(() => _isSending = true);

    try {
      // First store the message in the database
      await _supabase.from('messages').insert({
        'class_id': widget.classId,
        'teacher_id': _supabase.auth.currentUser!.id,
        'subject': _subjectController.text,
        'content': _messageController.text,
        'email': _sendEmail ? 'yes' : 'no',
        'sms': _sendSMS ? 'yes' : 'no',
      });

      // If email is selected, send it via the existing resend-email function
      if (_sendEmail) {
        final response = await _supabase.functions.invoke(
          'resend-email',
          body: {
            'subject': _subjectController.text,
            'content': _messageController.text,
            'classId': widget.classId,
          },
        );

        // Check if the response has data and was successful
        if (response.status != 200) {
          throw 'Failed to send email: ${response.data}';
        }
      }



      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Message sent successfully!')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error sending message: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSending = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Compose Message'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _subjectController,
              decoration: const InputDecoration(
                labelText: 'Subject',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _messageController,
              decoration: const InputDecoration(
                labelText: 'Message',
                border: OutlineInputBorder(),
              ),
              maxLines: 5,
            ),
            const SizedBox(height: 16),
            CheckboxListTile(
              title: const Text('Send via Email'),
              value: _sendEmail,
              onChanged: (value) => setState(() => _sendEmail = value!),
            ),
            CheckboxListTile(
              title: const Text('Send via SMS'),
              value: _sendSMS,
              onChanged: (value) => setState(() => _sendSMS = value!),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isSending ? null : _sendMessage,
              child: _isSending
                  ? const CircularProgressIndicator()
                  : const Text('Send Message'),
            ),
          ],
        ),
      ),
    );
  }
}