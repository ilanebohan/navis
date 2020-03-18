import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:lumberdash/lumberdash.dart';
import 'package:navis/core/error/exceptions.dart';
import 'package:navis/core/utils/data_source_utils.dart';
import 'package:navis/core/utils/extensions.dart';
import 'package:warframe_items_model/warframe_items_model.dart';
import 'package:worldstate_api_model/misc.dart';
import 'package:worldstate_api_model/worldstate_models.dart';

abstract class WarframestatRemoteBase {
  Future<List<SynthTarget>> getSynthTargets();

  Future<Worldstate> getWorldstate(GamePlatforms platform);

  Future<List<BaseItem>> searchItems(String term);
}

enum GamePlatforms { pc, ps4, xb1, swi }

class WarframestatRemote implements WarframestatRemoteBase {
  const WarframestatRemote(this.client);

  final http.Client client;

  static const _baseUrl = 'https://api.warframestat.us';

  @override
  Future<List<SynthTarget>> getSynthTargets() async {
    final data = await _baseCaller('/synthTargets');

    return compute<String, List<SynthTarget>>(toTargets, data)
        .catchError((Object error) => logError(error));
  }

  @override
  Future<Worldstate> getWorldstate(GamePlatforms platform,
      {String locale = 'en'}) async {
    final data =
        await _baseCaller('/${platform.platformToString()}', locale: locale);

    return compute<String, Worldstate>(toWorldstate, data)
        .catchError((Object error) => logError);
  }

  @override
  Future<List<BaseItem>> searchItems(String term) async {
    final results = await _baseCaller('/items/search/${term.toLowerCase()}');

    return compute<String, List<BaseItem>>(toBaseItems, results)
        .catchError((Object error) => logError(error));
  }

  Future<String> _baseCaller(String path, {String locale}) async {
    final headers = {'Accept-Language': locale ?? 'en'};

    try {
      final response = await client.get('$_baseUrl$path', headers: headers);

      if (response.statusCode == 200) {
        return response.body;
      } else {
        logError('Error connecting to server: ${response.statusCode}');
        throw ServerException();
      }
    } on SocketException {
      throw ServerException();
    }
  }
}
