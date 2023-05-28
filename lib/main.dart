import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

import 'widgets/themes.dart';
import 'widgets/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Must add this line.

  await windowManager.ensureInitialized();

  WindowOptions windowOptions = const WindowOptions(
    size: Size(300, 500),
    backgroundColor: Colors.transparent,
    //skipTaskbar: true,
  );

  await windowManager.setSize(Size(300, 500)); // Set the desired size here

  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
    //await windowManager.setPosition(const Offset(50, 50));
    await windowManager.setPosition(const Offset(50, 50));
  });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'qrun',
      theme: BaseTheme.light(),
      home: const Routes(),
    );
  }
}
