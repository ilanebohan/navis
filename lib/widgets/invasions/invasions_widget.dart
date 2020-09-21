import 'package:flutter/material.dart';
import 'package:navis/widgets/widgets.dart';
import 'package:warframestat_api_models/entities.dart';

import 'invasion_details.dart';
import 'invasion_reward.dart';
import 'invasions_bar.dart';

class InvasionWidget extends StatelessWidget {
  const InvasionWidget({Key key, this.invasion}) : super(key: key);

  final Invasion invasion;

  @override
  Widget build(BuildContext context) {
    return SkyboxCard(
      height: 200,
      node: invasion.node,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 24.0),
        child: Column(children: <Widget>[
          const Spacer(),
          InvasionDetails(
            node: invasion.node,
            description: invasion.desc,
            eta: invasion.eta,
          ),
          const Spacer(),
          InvasionReward(
            attacker: invasion.attacker,
            defender: invasion.defender,
            vsInfestation: invasion.vsInfestation,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
            child: InvasionBar(
              attackingFaction: invasion.attacker.factionKey,
              defendingFaction: invasion.defender.factionKey,
              progress: invasion.completion.toDouble() / 100,
            ),
          ),
        ]),
      ),
    );
  }
}
