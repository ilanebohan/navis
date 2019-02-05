import 'dart:async';
import 'package:flutter/material.dart';
import 'package:navis/utils/crashlytics.dart';

import 'app.dart';

Future<void> main() async {
  final exception = ExceptionService();

  runZoned<Future<void>>(() async => runApp(Navis()),
      onError: (error, stackTrace) async =>
          await exception.reportErrorAndStackTrace(error, stackTrace));
}
