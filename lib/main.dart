import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:navis/app.dart';
import 'package:navis/blocs/bloc.dart';
import 'package:navis/services/repository.dart';
import 'package:navis/services/storage/cache_storage.service.dart';
import 'package:navis/services/storage/persistent_storage.service.dart';
import 'package:package_info/package_info.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

  HydratedBloc.storage = await HydratedStorage.build();

  runZonedGuarded(startApp, FirebaseCrashlytics.instance.recordError);

  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
}

Future<void> startApp() async {
  final cache = CacheStorageService();
  final persistent = PersistentStorageService();

  await cache.startInstance();
  await persistent.startInstance();

  final repository =
      Repository(persistent, cache, await PackageInfo.fromPlatform());

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<NavigationBloc>(create: (_) => NavigationBloc()),
        BlocProvider<SearchBloc>(create: (_) => SearchBloc(repository)),
        BlocProvider<WorldstateBloc>(
          create: (context) {
            return WorldstateBloc(
              api: Repository.warframestat,
              persistent: persistent,
              cache: cache,
            );
          },
        ),
      ],
      child: Navis(repository),
    ),
  );
}
