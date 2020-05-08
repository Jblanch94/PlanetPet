import 'dart:async';
import 'package:flutter/material.dart';
import 'package:planet_pet/screens/home.dart';
import 'package:sentry/sentry.dart';

const sentryDSN = 'https://03af678dd10041d1babef9e30701aeb3@o365156.ingest.sentry.io/5207600';
final SentryClient sentry = SentryClient(dsn: sentryDSN);

class App extends StatefulWidget {
  static Future<void> reportError(dynamic error, dynamic stackTrace) async {
    // if (Foundation.kDebugMode) {
    //   print(stackTrace);
    //   return;
    // }

    

    final SentryResponse response = await sentry.captureException(
      exception: error,
      stackTrace: stackTrace
    );
    if (response.isSuccessful) {
      print('Sentry ID: ${response.eventId}');
    } else {
      print('Failed to report to Sentry: ${response.error}');
    }
  }

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {

  bool darkMode;

  @override 
  void initState() {
    super.initState();
    darkMode = false;
  }

  void toggleTheme(bool value) {
    setState(() {
      darkMode = !darkMode;
    });
  }
  @override
  Widget build(BuildContext context) {
    // throw StateError('Generic Test Error');

    return MaterialApp(
      home: Home(darkMode: darkMode, toggleTheme: toggleTheme),
      theme: darkMode ? ThemeData.dark() : ThemeData.light()
    );
  }
}