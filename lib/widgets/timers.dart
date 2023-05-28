import 'package:flutter/material.dart';
//import 'package:path_provider/path_provider.dart';

import 'dart:async';

class Timers extends StatefulWidget {
  const Timers({Key? key}) : super(key: key);

  @override
  _TimersState createState() => _TimersState();
}

class _TimersState extends State<Timers> {
  // Declare variables for the timer duration and the timer object
  Duration _duration = const Duration(hours: 0, minutes: 20, seconds: 0);
  Timer? _timer;

  // Initialize the timer in the initState method
  @override
  void initState() {
    super.initState();
    // Start the timer when the widget is initialized
    _startTimer();
  }

  // Dispose the timer in the dispose method
  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  // Define a method to start the timer
  void _startTimer() {
    // Cancel any existing timer before creating a new one
    _timer?.cancel();
    // Create a new timer object that ticks every second
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      // Update the state with the new duration
      setState(() {
        // If the duration is not zero, subtract one second from it
        if (_duration.inSeconds > 0) {
          _duration = Duration(seconds: _duration.inSeconds - 1);
        } else {
          // Otherwise, cancel the timer and reset the duration
          debugPrint('''end duration''');
          timer.cancel();
        }
      });
    });
  }

  TextEditingController _hoursController = TextEditingController(text: '0');
  TextEditingController _minutesController = TextEditingController(text: '20');
  TextEditingController _secondsController = TextEditingController(text: '0');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Display the remaining time in the center of the circle
            Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                child: Text(
                  '${_duration.inHours.toString().padLeft(2, '0')}:${_duration.inMinutes.remainder(60).toString().padLeft(2, '0')}:${_duration.inSeconds.remainder(60).toString().padLeft(2, '0')}',
                  style: TextStyle(
                      fontSize: 32,
                      color: _duration == Duration.zero
                          ? Colors.red
                          : (_duration < Duration(minutes: 5)
                              ? Colors.orange
                              : Colors.black)),
                )),
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    int hours = int.tryParse(_hoursController.text) ?? 0;
                    int minutes = int.tryParse(_minutesController.text) ?? 0;
                    int seconds = int.tryParse(_secondsController.text) ?? 0;

                    return AlertDialog(
                      title: const Text('Set Countdown Duration'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextField(
                            keyboardType: TextInputType.number,
                            controller: _hoursController,
                            onChanged: (value) {
                              hours = int.tryParse(value) ?? 0;
                            },
                            decoration: const InputDecoration(
                              labelText: 'Hours',
                            ),
                          ),
                          TextField(
                            keyboardType: TextInputType.number,
                            controller: _minutesController,
                            onChanged: (value) {
                              minutes = int.tryParse(value) ?? 0;
                            },
                            decoration: const InputDecoration(
                              labelText: 'Minutes',
                            ),
                          ),
                          TextField(
                            keyboardType: TextInputType.number,
                            controller: _secondsController,
                            onChanged: (value) {
                              seconds = int.tryParse(value) ?? 0;
                            },
                            decoration: const InputDecoration(
                              labelText: 'Seconds',
                            ),
                          ),
                        ],
                      ),
                      actions: [
                        // Add a cancel button to the actions of the AlertDialog widget
                        ElevatedButton(
                          onPressed: () {
                            // Pop the dialog without changing anything
                            Navigator.of(context).pop();
                          },
                          child: const Text('Cancel'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              // Update the duration with the user input values
                              _duration = Duration(
                                hours: hours,
                                minutes: minutes,
                                seconds: seconds,
                              );
                            });
                            // Pop the dialog and start the timer with the new duration
                            Navigator.of(context).pop();
                            _startTimer();
                          },
                          child: const Text('Start'),
                        ),
                      ],
                      actionsAlignment: MainAxisAlignment.spaceBetween,
                    );
                  },
                );
              },
              child: const Text('New Countdown'),
            ),
          ],
        ),
      ),
    );
  }
}
