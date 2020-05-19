import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sentry/sentry.dart';
import 'package:flutter/services.dart';
import 'app.dart' as App;


const sentryDSN = 'https://03af678dd10041d1babef9e30701aeb3@o365156.ingest.sentry.io/5207600';
final SentryClient sentry = SentryClient(dsn: sentryDSN);

void main() async {
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp
  ]);
  FlutterError.onError = (FlutterErrorDetails details) {
    Zone.current.handleUncaughtError(details.exception, details.stack);
  };
  runZoned( () {
    runApp(App.App());
  }, onError: (error, stackTrace) {
    App.App.reportError(error, stackTrace);
  });
}