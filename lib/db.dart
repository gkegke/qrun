import 'dart:io';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

Future<Map<String, dynamic>> checkConfigFile(String appDocPath) async {
  // Create a folder object for qrun_config
  Directory configFolder = Directory('$appDocPath/qrun_config');

  // Check if the folder exists
  bool folderExists = await configFolder.exists();

  // If the folder does not exist, copy it from the app's assets
  if (!folderExists) {
    // Create a folder object for the default_config folder in the app's assets
    debugPrint('''
      appDocPath: $appDocPath
      targetFolder: ${appDocPath}qrun_config
    ''');

    Directory targetFolder = Directory('${appDocPath}qrun_config');

    targetFolder.createSync();

    // copy 'default_config' to users computer
    await _copyDefaultConfigFolder(targetFolder);
  }

  // Create a file object for runners.json
  File configFile = File('${appDocPath}qrun_config/runners.json');

  // If the file exists, read its contents and parse it as JSON
  String contents = await configFile.readAsString();
  Map<String, dynamic> data = jsonDecode(contents);

  return data;
}

Future<void> _copyDefaultConfigFolder(Directory targetFolder) async {
  String manifestContent =
      await rootBundle.loadString('lib/default_config/manifest.json');

  Map<String, dynamic> files =
      jsonDecode(manifestContent) as Map<String, dynamic>;

  // Copy each file to the config folder using the copyFile method
  for (var file in files.entries) {
    debugPrint('''
      file in manifest: ${file.key}
      target: ${targetFolder.path}/${file.value.substring(19)}
    ''');

    ByteData data = await rootBundle.load(file.value);
    File destFile = File('${targetFolder.path}/${file.value.substring(19)}');

    destFile.createSync(recursive: true);

    await destFile.writeAsBytes(data.buffer.asUint8List());
  }
}
