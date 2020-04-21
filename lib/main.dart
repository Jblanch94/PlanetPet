import 'dart:async';
import 'package:flutter/material.dart';
import 'package:planet_pet/app.dart';
import 'package:sentry/sentry.dart';
import 'app.dart' as App;



final SentryClient sentry = SentryClient(dsn: sentryDSN);

void main() {
  FlutterError.onError = (FlutterErrorDetails details) {
    Zone.current.handleUncaughtError(details.exception, details.stack);
  };
  runZoned( () {
    runApp(App.App());
  }, onError: (error, stackTrace) {
    App.App.reportError(error, stackTrace);
  });
}