import 'package:flutter/material.dart';
import 'package:custom_progressbar/custom_progressbar.dart';

/// Example app entry point.
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Custom ProgressBar Example')),
        body: Center(
            child: Center(
                child: ProgressBar(
          size: 90,
          progressColor: Colors.amber,
          progressBackgroundColor: Colors.green,
          progressStrokeWidth: 2,
          center: Image.asset(
            'assets/img.png',
          ),
        ))),
      ),
    );
  }
}
