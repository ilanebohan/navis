import 'dart:async';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:logging/logging.dart';
import 'package:navis/injection_container.dart';
import 'package:wfcd_client/wfcd_client.dart';

import 'core/app.dart';
import 'core/bloc/navigation_bloc.dart';
import 'core/local/user_settings.dart';
import 'core/services/notifications.dart';
import 'features/codex/presentation/bloc/search_bloc.dart';
import 'features/worldstate/presentation/bloc/solsystem_bloc.dart';
import 'injection_container.dart' as di;

Future<void> main() async {
  Logger.root.onRecord.listen((record) {
    print('${record.level.name}: ${record.time}: ${record.message}');
  });

  WidgetsFlutterBinding.ensureInitialized();
  FlutterError.onError = Crashlytics.instance.recordFlutterError;

  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent));

  await runZoned(() async {
    BlocSupervisor.delegate = await HydratedBlocDelegate.build();

    await di.init();

    if (sl<Usersettings>().platform == null) {
      sl<Usersettings>().platform = GamePlatforms.pc;
      await sl<NotificationService>()
          .subscribeToPlatform(sl<Usersettings>().platform);
    }

    runApp(MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<NavigationBloc>()),
        BlocProvider(create: (_) => sl<SolsystemBloc>()),
        BlocProvider(create: (_) => sl<SearchBloc>())
      ],
      child: const NavisApp(),
    ));
  }, onError: Crashlytics.instance.recordError);
}
