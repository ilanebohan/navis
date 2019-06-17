import 'package:codable/codable.dart';
import 'package:codable/cast.dart' as cast;

class Nightwave extends Coding {
  String id, startString, tag;
  DateTime activation, expiry;
  bool active;
  num season, phase;

  List<Challenge> possibleChallenges, _activeChallenges;
  List<String> rewardTypes;

  List<Challenge> get dailyChallenges {
    final daily = _activeChallenges.where((c) => c.isDaily == true).toList();

    daily.sort((a, b) => a.expiry.compareTo(b.expiry));

    return daily;
  }

  List<Challenge> get weeklyChallenges {
    final weekly = _activeChallenges.where((c) => c.isDaily == false).toList();

    weekly.sort((a, b) {
      if (a.isElite ?? false)
        return 0;
      else
        return 1;
    });

    return weekly;
  }

  @override
  Map<String, cast.Cast> get castMap =>
      {'rewardTypes': const cast.List(cast.String)};

  @override
  void decode(KeyedArchive object) {
    super.decode(object);

    id = object.decode('id');
    activation = DateTime.parse(object.decode('activation'));
    startString = object.decode('startString');
    expiry = DateTime.parse(object.decode('expiry'));
    active = object.decode('active');
    season = object.decode('season');
    tag = object.decode('tag');
    phase = object.decode('phase');

    possibleChallenges =
        object.decodeObjects('possibleChallenges', () => Challenge());

    _activeChallenges =
        object.decodeObjects('activeChallenges', () => Challenge());

    rewardTypes = object.decode('rewardTypes');
  }

  @override
  void encode(KeyedArchive object) {
    object.encode('id', id);
    object.encode('activation', activation.toIso8601String());
    object.encode('startString', startString);
    object.encode('expiry', expiry.toIso8601String());
    object.encode('active', active);
    object.encode('season', season);
    object.encode('tag', tag);
    object.encode('phase', phase);
    object.encode('rewardTypes', rewardTypes);
  }
}

class Challenge extends Coding {
  String id, startString, desc, title;
  DateTime activation, expiry;
  bool active, isDaily, isElite;
  num reputation;

  @override
  void decode(KeyedArchive object) {
    super.decode(object);

    id = object.decode('id');
    activation = DateTime.parse(object.decode('activation'));
    startString = object.decode('startString');
    expiry = object.decode('expiry');
    active = object.decode('active');
    isDaily = object.decode('isDaily') ?? false;
    isElite = object.decode('isElite');
    title = object.decode('title');
    desc = object.decode('desc');
    reputation = object.decode('reputation');
  }

  @override
  void encode(KeyedArchive object) {
    object.encode('id', id);
    object.encode('activation', activation.toIso8601String());
    object.encode('startString', startString);
    object.encode('expiry', expiry.toIso8601String());
    object.encode('active', active);
    object.encode('isDaily', isDaily);
    object.encode('isElite', isElite);
    object.encode('title', title);
    object.encode('desc', desc);
    object.encode('reputation', reputation);
  }
}
