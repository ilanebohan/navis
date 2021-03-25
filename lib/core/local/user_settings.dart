import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:logging/logging.dart';
import 'package:path_provider/path_provider.dart';
import 'package:wfcd_client/wfcd_client.dart';

import '../../constants/storage_keys.dart';

class Usersettings with ChangeNotifier {
  Usersettings(this._box);

  final Box<dynamic> _box;

  static Usersettings _instance;

  static final _logger = Logger('Usersettings');

  static Future<Usersettings> initUsersettings() async {
    _logger.info('Initializing Usersettings Hive');
    final directory = await getApplicationDocumentsDirectory();
    Hive.init(directory.path);

    final box = await Hive.openBox<dynamic>('user_settings')
        .catchError((Object error, StackTrace stack) {
      _logger.severe('Unable to open Usersettings Hive box', error, stack);
    });

    return _instance ??= Usersettings(box);
  }

  GamePlatforms get platform {
    final value = _box.get(SettingsKeys.platformKey) as String;

    if (value != null) {
      return GamePlatformsX.fromString(value);
    }

    return null;
  }

  set platform(GamePlatforms value) {
    _logger.info('setting new platform ${value.asString}');
    _box.put(SettingsKeys.platformKey, value.asString);
    notifyListeners();
  }

  ThemeMode get theme {
    final value = _box.get(SettingsKeys.theme) as String;

    if (value == null) return ThemeMode.system;

    return ThemeMode.values.firstWhere(
      (element) => element.toString().contains(value),
      orElse: () => ThemeMode.system,
    );
  }

  set theme(ThemeMode mode) {
    _box.put(SettingsKeys.theme, mode.toString().split('.').last);
    notifyListeners();
  }

  bool get backkey => getToggle(SettingsKeys.backKey);

  set backkey(bool value) => setToggle(SettingsKeys.backKey, value);

  bool getToggle(String key) {
    return _box.get(key, defaultValue: false) as bool;
  }

  void setToggle(String key, bool value) {
    _box.put(key, value);
    notifyListeners();
  }
}
