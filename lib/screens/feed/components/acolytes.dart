import 'package:flutter/material.dart';
import 'package:navis/blocs/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:navis/models/export.dart';

import 'package:navis/components/layout.dart';

class Acolytes extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final state = BlocProvider.of<WorldstateBloc>(context);

    return BlocBuilder(
      bloc: state,
      builder: (context, state) {
        if (state is WorldstateLoaded) {
          final enemies = state.worldState.persistentEnemies;

          return Tiles(
              title: 'Acolytes',
              child: Column(
                children: enemies.map((e) => AcolyteProfile(enemy: e)).toList(),
              ));
        }
      },
    );
  }
}

class AcolyteProfile extends StatelessWidget {
  const AcolyteProfile({@required this.enemy});

  final PersistentEnemie enemy;

  Color _healthColor(num health) {
    if (health > 50.0)
      return Colors.green;
    else if (health <= 50.0 && health >= 10.0)
      return Colors.orange[700];
    else
      return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    const color = Colors.white;

    return Container(
        margin: const EdgeInsets.only(top: 4.0),
        child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
          RowItem(
              text: 'Acolyte: ${enemy.agentType} | lvl: ${enemy.rank}',
              child: StaticBox.text(
                  size: 15,
                  text:
                      'Health: ${(enemy.healthPercent * 100).toStringAsFixed(2)}%',
                  color: _healthColor(enemy.healthPercent * 100))),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                if (enemy.lastDiscoveredAt.isNotEmpty)
                  StaticBox(
                    color: enemy.isDiscovered ? Colors.red[800] : Colors.grey,
                    child: Row(children: <Widget>[
                      enemy.isDiscovered
                          ? const Icon(Icons.gps_fixed, color: color)
                          : const Icon(Icons.gps_not_fixed, color: color),
                      const SizedBox(width: 4),
                      Text(enemy.lastDiscoveredAt,
                          style: const TextStyle(color: color))
                    ]),
                  ),
                StaticBox.text(
                  color: enemy.isDiscovered
                      ? Colors.red[800]
                      : Colors.blueAccent[400],
                  size: 15,
                  text:
                      '${enemy.isDiscovered ? 'Found' : 'Last seen'}: ${enemy.lastDiscoveredTime.difference(DateTime.now()).inMinutes.abs()}m ago',
                )
              ]),
        ]));
  }
}
