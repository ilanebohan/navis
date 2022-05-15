import 'package:flutter/material.dart';
import 'package:navis/worldstate/widgets/invasions/invasion_progress.dart';
import 'package:navis/worldstate/widgets/invasions/invasion_rewards.dart';
import 'package:navis_ui/navis_ui.dart';
import 'package:wfcd_client/entities.dart';

class InvasionWidget extends StatelessWidget {
  const InvasionWidget({super.key, required this.invasion});

  final Invasion invasion;

  Widget _buildDetails(
    BuildContext context,
    String node,
    String description,
    String eta,
  ) {
    const shadow = Shadow(offset: Offset(1, 0), blurRadius: 4);
    final textTheme = Theme.of(context).textTheme;

    final nodeStyle = textTheme.subtitle1?.copyWith(
      color: Colors.white,
      fontSize: 15,
      shadows: <Shadow>[shadow],
    );

    final infoStyle = textTheme.caption
        ?.copyWith(color: Colors.white, shadows: <Shadow>[shadow]);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(node, style: nodeStyle),
        Text('$description ($eta)', style: infoStyle),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: SkyboxCard(
        node: invasion.node,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Spacer(),
            _buildDetails(
              context,
              invasion.node,
              invasion.desc,
              invasion.eta,
            ),
            const Spacer(),
            InvasionReward(
              attacker: invasion.attacker,
              defender: invasion.defender,
              vsInfestation: invasion.vsInfestation,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
              child: InvasionProgress(
                progress: invasion.completion / 100,
                attackingFaction: invasion.attacker.factionKey,
                defendingFaction: invasion.defender.factionKey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
