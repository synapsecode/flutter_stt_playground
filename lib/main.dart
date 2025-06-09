import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sttdemo/speech2text.dart';
import 'package:sttdemo/stts.dart';
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
      home: STTDemo(),
    );
  }
}

enum STTPackage { stts, speech_to_text }

class STTDemo extends StatefulWidget {
  const STTDemo({super.key});

  @override
  State<STTDemo> createState() => _STTDemoState();
}

class _STTDemoState extends State<STTDemo> {
  STTPackage selectedPackage = STTPackage.stts;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Speech To Text Demos')),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      selectedPackage = STTPackage.stts;
                    });
                  },
                  child: Text('STTS Package'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      selectedPackage = STTPackage.speech_to_text;
                    });
                  },
                  child: Text('Speech2Text Package'),
                ),
              ],
            ),
            Divider(),
            SizedBox(height: 20),
            Expanded(
              child: selectedPackage == STTPackage.stts
                  ? STTSPkgDemo()
                  : Speech2Text(),
            ),
          ],
        ),
      ),
    );
  }
}
