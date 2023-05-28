import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class ReadMe extends StatefulWidget {
  const ReadMe({Key? key}) : super(key: key);

  @override
  State<ReadMe> createState() => _ReadMeState();
}

class _ReadMeState extends State<ReadMe> {
  final TextEditingController _controller = TextEditingController();
  String filePath = '';

  @override
  void initState() {
    super.initState();
    _controller.text = '''
This is a editable text box.

You can type anything here and it will be saved and loaded.

It's simple, but it's meant to be for simple things. Check out
the Kanban for more serious stuff.

example usage,

### IMPORTANT

 - go through flashcards when you have time
 - exercise
 - listen to music when struggling to concentrate

# main

 - work on qrun

     '''; // Set your desired default text here
    _loadFromFile();
  }

  Future<void> _getFilePath() async {
    final appDocumentDir = await getApplicationDocumentsDirectory();
    final qrunConfigDir = Directory('${appDocumentDir.path}/qrun_config');
    if (!qrunConfigDir.existsSync()) {
      qrunConfigDir.createSync();
    }
    setState(() {
      filePath = '${qrunConfigDir.path}/readme.txt';
    });
  }

  Future<void> _saveToFile() async {
    if (filePath.isEmpty) {
      await _getFilePath();
    }
    final file = File(filePath);
    await file.writeAsString(_controller.text);
  }

  void _loadFromFile() async {
    await _getFilePath();
    final file = File(filePath);
    if (file.existsSync()) {
      final text = await file.readAsString();
      setState(() {
        _controller.text = text;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'QUICK REMINDERS',
              style: TextStyle(
                fontSize: 10.0,
                color: Colors.black,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        TextField(
          controller: _controller,
          maxLines: null,
          decoration: const InputDecoration(
            hintText: 'Enter some text',
            filled: true,
            fillColor: Colors.black,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.zero,
            ),
          ),
          onChanged: (_) => _saveToFile(),
          style: const TextStyle(color: Colors.white),
        ),
      ],
    );
  }
}
