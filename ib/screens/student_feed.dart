import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class StudentFeed extends StatefulWidget {
  const StudentFeed({super.key});
  @override State<StudentFeed> createState() => _StudentFeedState();
}

class _StudentFeedState extends State<StudentFeed> {
  List<Map> messages = [];

  @override void initState() {
    super.initState();
    Supabase.instance.client.from('messages').stream(primaryKey: ['id']).listen((data) {
      setState(() => messages = data);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Classes')),
      body: Column(children: [
        SizedBox(
          height: 200,
          child: MobileScanner(onDetect: (barcode) async {
            final code = barcode.rawValue!;
            await Supabase.instance.client.from('members').insert({'class_code': code});
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Joined $code')));
          }),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: messages.length,
            itemBuilder: (c, i) => ListTile(title: Text(messages[i]['text'])),
          ),
        ),
      ]),
    );
  }
}

extension on BarcodeCapture {
  get rawValue => null;
}
