import 'package:flutter/material.dart';
import 'package:wfcd_client/entities.dart';

import '../widgets/acolyte_profile/profile_widgets.dart';

class AcolyteProfile extends StatelessWidget {
  const AcolyteProfile({Key key, this.enemy}) : super(key: key);

  final PersistentEnemy enemy;

  static const route = '/acolyte_profile';

  @override
  Widget build(BuildContext context) {
    final acolyte =
        ModalRoute.of(context).settings.arguments as PersistentEnemy;

    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          AcolyteAppBar(
            acolyteName: acolyte.agentType,
            region: acolyte.lastDiscoveredAt,
          ),
          SliverList(
              delegate: SliverChildListDelegate.fixed(<Widget>[
            AcolyteStatus(
              health: acolyte.healthPercent * 100,
              rank: acolyte.rank,
              location: acolyte.lastDiscoveredAt,
              lastDiscoveredTime: acolyte.lastDiscoveredTime,
              isDiscovered: acolyte.isDiscovered,
            )
          ]))
        ],
      ),
    );
  }
}
