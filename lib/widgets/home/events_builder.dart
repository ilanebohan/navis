import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:navis/blocs/bloc.dart';
import 'package:navis/global_keys.dart';
import 'package:navis/utils/worldstate_utils.dart';
import 'package:navis/widgets/widgets.dart';

import 'events_widget.dart';

class EventBuilder extends StatelessWidget {
  const EventBuilder({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Tiles(
      child: PageStorage(
        key: eventsKey,
        bucket: eventsBucket,
        child: BlocBuilder<WorldstateBloc, WorldStates>(
            condition: (WorldStates previous, WorldStates current) {
          return compareIds(
            previous.worldstate?.events,
            current.worldstate?.events,
          );
        }, builder: (BuildContext context, WorldStates state) {
          final events = state.worldstate?.events ?? [];

          return Carousel(
            height: 300,
            dotCount: events.length,
            enableIndicator: events.length > 1,
            children: events.map((e) => EventWidget(event: e)).toList(),
          );
        }),
      ),
    );
  }
}
