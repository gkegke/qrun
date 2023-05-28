import 'dart:io';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import '../db.dart';

class Runners extends StatefulWidget {
  const Runners({super.key});

  @override
  State<Runners> createState() => _RunnersState();
}

class _RunnersState extends State<Runners> {
  String? appDocPath;
  Map<String, dynamic>? configData;
  int displayedRunnersCount = 3;
  String filter = '';

  // A function to get the config file data and update the state
  Future<void> getConfigData() async {
    // Call the checkConfigFile function and assign the result to configData

    Directory appDocDir = await getApplicationDocumentsDirectory();

    appDocPath = appDocDir.path;
    configData = await checkConfigFile(appDocPath!);

    // Get the documents directory path
    // Update the state to trigger a rebuild
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    // Call the getConfigData function when the widget is initialized
    getConfigData();
  }

  void showMoreRunners() {
    setState(() {
      displayedRunnersCount += 10;
    });
  }

  void runPythonFile(String fileName, String arguments) {
    // Run the Python file in the background with the specified arguments
    Process.start(
        'python3',
        ['${appDocPath}qrun_config/runners/${fileName}']
          ..addAll(arguments.split(' ')));
  }

  @override
  Widget build(BuildContext context) {
    if (configData == null || appDocPath == null) {
      return const Center(child: CircularProgressIndicator());
    } else {
      final runners = configData!['runners'];
      final runnersCount = runners.length;
      List<dynamic> runnersToShow;

      if (filter.length != 0) {
        runnersToShow = runners
            .where((runner) => (runner['title']
                .toLowerCase()
                .contains(filter.toLowerCase())) as bool)
            .toList();

        runnersToShow = runnersToShow.length > displayedRunnersCount
            ? runnersToShow.sublist(0, runnersCount)
            : runnersToShow;
      } else {
        runnersToShow = runners.length > displayedRunnersCount
            ? runners.sublist(0, displayedRunnersCount)
            : runners;
      }

      final remainingRunners = runners.length - displayedRunnersCount;

      debugPrint('''
        filter: ${filter.length}
        runnersCount: ${runnersCount}
        displayedRunnersCount: ${displayedRunnersCount}
      ''');

      return Container(
        constraints: const BoxConstraints(minHeight: 150),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Row(
                  children: [
                    const Text(
                      'RUNNERS',
                      style: TextStyle(
                        fontSize: 10.0,
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(width: 10.0),
                    Expanded(
                      child: TextField(
                        onChanged: (value) {
                          setState(() {
                            filter = value.toLowerCase();
                          });
                        },
                        decoration: const InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 5.0),
                          hintText: 'Search for runner',
                        ),
                        style: const TextStyle(
                          fontSize: 10.0,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Wrap(
                alignment: WrapAlignment.start,
                spacing: 10.0,
                runSpacing: 10.0,
                children: runnersToShow.map<Widget>((runner) {
                  return InkWell(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text(runner['title']),
                            content: Text(runner['description']),
                            actions: [
                              TextButton(
                                child: const Text('Run'),
                                onPressed: () {
                                  runPythonFile(
                                    runner['runner'],
                                    runner['arguments'],
                                  );
                                  Navigator.pop(context);
                                },
                              ),
                              TextButton(
                                child: const Text('Cancel'),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Image.asset(
                            '${appDocPath}qrun_config/icons/${runner['icon']}',
                            width: 75,
                            height: 75,
                          ),
                        ),
                        Text(
                          runner['title'].length > 10
                              ? runner['title'].substring(0, 10)
                              : runner['title'],
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
              if (filter.isEmpty && remainingRunners > 0)
                TextButton(
                  onPressed: showMoreRunners,
                  child: Text('Show More (${remainingRunners.toString()})'),
                ),
            ],
          ),
        ),
      );
    }
  }
}
