import 'dart:async';

import 'package:flutter/material.dart';
import 'package:stts/stts.dart';

void main() {
  runApp(const STTDemoApp());
}

class STTDemoApp extends StatelessWidget {
  const STTDemoApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'STT DEMO',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const STTDemo(),
    );
  }
}

class STTDemo extends StatefulWidget {
  const STTDemo({super.key});

  @override
  State<STTDemo> createState() => _STTDemoState();
}

class _STTDemoState extends State<STTDemo> {
  final stt = Stt();
  StreamSubscription<SttState>? sub;

  bool autoRetry = false;

  String partialText = "";
  String finalText = "";

  start() async {
    final perm = await stt.hasPermission();
    if (!perm) return;
    sub = stt.onStateChanged.listen(
      (speechState) {
        if (speechState == SttState.stop) {
          if (autoRetry) {
            stt.start();
          } else {
            print('STT STOP');
          }
        } else {
          if (!autoRetry) {
            print('STT START');
          }
        }
      },
      onError: (err) {
        print('SPEECH ERROR: $err');
      },
    );
    stt.onResultChanged.listen((result) {
      if (result.isFinal) {
        finalText = "$finalText ${result.text}";
        partialText = finalText;
      } else {
        partialText = "$finalText ${result.text}";
      }
      setState(() {});
    });
    stt.start();
    setState(() {
      partialText = "";
      finalText = "";
      autoRetry = true;
    });
  }

  stop() {
    setState(() {
      autoRetry = false;
      partialText = "";
    });
    stt.stop();
    sub?.cancel();
    stt.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("RUNNING: $autoRetry"),
            ElevatedButton(onPressed: start, child: Text('START')),
            SizedBox(height: 10),
            ElevatedButton(onPressed: stop, child: Text('STOP')),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.all(20),
              child: Text(
                partialText,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20),
              ),
            ),
            Container(
              padding: EdgeInsets.all(20),
              child: Text(
                finalText,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 10),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
