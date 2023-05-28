import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class Kanban extends StatefulWidget {
  const Kanban({Key? key}) : super(key: key);

  @override
  State<Kanban> createState() => _KanbanState();
}

class _KanbanState extends State<Kanban> {
  final TextEditingController _todoController = TextEditingController();
  final TextEditingController _inProgressController = TextEditingController();
  final TextEditingController _testingController = TextEditingController();
  final TextEditingController _doneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _openFiles();
  }

  Future<void> _openFiles() async {
    final appDocumentDir = await getApplicationDocumentsDirectory();
    final qrunConfigDir = Directory('${appDocumentDir.path}qrun_config');
    await qrunConfigDir.create(
        recursive: true); // Create the directory if it doesn't exist

    final todoFile = File('${qrunConfigDir.path}/todo.txt');
    final inProgressFile = File('${qrunConfigDir.path}/inProgress.txt');
    final testingFile = File('${qrunConfigDir.path}/testing.txt');
    final doneFile = File('${qrunConfigDir.path}/done.txt');

    if (await todoFile.exists()) {
      _todoController.text = await todoFile.readAsString();
    } else {
      _todoController.text = '''

## priority

 - buy birthday cake (remember he likes chocolate)
 - finish of qrun

## nice to do

 - fix some bugs in flashc 

''';
    }

    if (await inProgressFile.exists()) {
      _inProgressController.text = await inProgressFile.readAsString();
    } else {
      _inProgressController.text = '''

## working on

 - implement new feature for qrun
 - write unit tests for flashc

## blocked by
 
 - waiting for feedback from client

 - need more data for testing
''';
    }

    if (await testingFile.exists()) {
      _testingController.text = await testingFile.readAsString();
    } else {
      _testingController.text = '''

## ready for testing

 - qrun v1.2
 - flashc v0.9

## testing results

 - qrun passed all tests
 - flashc failed on test case 7

''';
    }

    if (await doneFile.exists()) {
      _doneController.text = await doneFile.readAsString();
    } else {
      _doneController.text = '''

## recently done

qrun v1.1
flashc v0.8

## feedback

 - client satisfied with qrun
 - flashc needs more improvement 

## done

 - 

''';
    }
  }

  Future<void> _saveToFile(
      TextEditingController controller, String filename) async {
    final appDocumentDir = await getApplicationDocumentsDirectory();
    final qrunConfigDir = Directory('${appDocumentDir.path}qrun_config');
    await qrunConfigDir.create(
        recursive: true); // Create the directory if it doesn't exist

    final file = File('${qrunConfigDir.path}/$filename');
    await file.writeAsString(controller.text);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: const TabBar(
          tabs: [
            Tab(text: 'To Do'),
            Tab(text: 'Doing'),
            Tab(text: 'Testing'),
            Tab(text: 'Done'),
          ],
          labelColor: Colors.white,
          labelStyle: TextStyle(fontWeight: FontWeight.bold),
          labelPadding: EdgeInsets.symmetric(horizontal: 5),
          unselectedLabelColor: Colors.grey,
        ),
        body: TabBarView(
          children: [
            CustomTextField(
              controller: _todoController,
              onChanged: (value) {
                // Save changes to file
                _saveToFile(_todoController, 'todo.txt');
              },
            ), // To Do

            CustomTextField(
              controller: _inProgressController,
              onChanged: (value) {
                // Save changes to file
                _saveToFile(_inProgressController, 'inProgress.txt');
              },
            ), // In Progress

            CustomTextField(
              controller: _testingController,
              onChanged: (value) {
                // Save changes to file
                _saveToFile(_testingController, 'testing.txt');
              },
            ), // Testing

            CustomTextField(
              controller: _doneController,
              onChanged: (value) {
                // Save changes to file
                _saveToFile(_doneController, 'done.txt');
              },
            ), // Done
          ],
        ),
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const CustomTextField({
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minHeight: 300),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        maxLines: null,
        decoration: const InputDecoration(
          hintText: 'Enter some text',
          filled: true,
          fillColor: Colors.black,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.zero,
          ),
        ),
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}
