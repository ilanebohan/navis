import 'package:flutter/foundation.dart';
import 'package:navis/resources/worldstate_api_provider.dart';
import 'package:navis/utils/enums.dart';
import 'package:warframe_items_model/warframe_items_model.dart';
import 'package:worldstate_api_model/misc.dart';
import 'package:worldstate_api_model/worldstate_models.dart';

class WorldstateRepository {
  const WorldstateRepository();

  static const WorldstateApiProvider _worldstateProvider =
      WorldstateApiProvider();

  Future<Worldstate> getWorldstate(Platforms platform) async {
    return compute<Platforms, Worldstate>(
        _worldstateProvider.getWorldstate, platform);
  }

  Future<List<ItemObject>> searchItems(String searchTerm) async {
    return compute<String, List<ItemObject>>(
        _worldstateProvider.searchItems, searchTerm);
  }

  Future<List<SynthTarget>> getTargets() => _worldstateProvider.synthTargets();
}
