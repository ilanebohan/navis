import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:navis/features/worldstate/data/models/event_info.dart';
import 'package:navis/features/worldstate/domain/entities/event_info.dart';

class EventInfoParser {
  const EventInfoParser._(this._eventInfo);

  final Map<String, EventInfo> _eventInfo;

  static const _emptyEvent = EventInfo(
    keyArt: 'https://i.imgur.com/CNrsc7V.png',
    howTos: [],
  );

  static EventInfoParser _instance;

  static Future<EventInfoParser> loadEventData() async {
    if (_instance != null) return _instance;

    final asset = await rootBundle.loadString('assets/event_info.json');
    final info = (json.decode(asset) as Map<String, dynamic>)
        .map<String, EventInfo>((name, dynamic info) => MapEntry(
            name, EventInfoModel.fromJson(info as Map<String, dynamic>)));

    return EventInfoParser._(info);
  }

  EventInfo getEventInfo(String eventName) {
    final info = _eventInfo[eventName.split(':').last.trim()];

    if (info != null) return info;

    return _emptyEvent;
  }
}
