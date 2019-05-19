import 'package:flutter/material.dart';
import 'package:navis/blocs/bloc.dart';
import 'package:navis/models/export.dart';
import 'package:navis/utils/factionutils.dart';
import 'package:navis/components/layout.dart';
import 'package:navis/components/animations.dart';

class Sorties extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final wstate = BlocProvider.of<WorldstateBloc>(context);

    return Tiles(
        child: BlocBuilder(
            bloc: wstate,
            builder: (context, state) {
              if (state is WorldstateLoaded) {
                final sortie = state.worldState.sortie;

                if (sortie?.variants?.isNotEmpty ?? false) {
                  final title = ListTile(
                    leading: FactionIcon(sortie.faction, size: 45),
                    title: Text(sortie.boss),
                    subtitle: Text(sortie.faction),
                    trailing: Container(
                        padding: const EdgeInsets.all(4.0),
                        child: CountdownBox(expiry: sortie.expiry)),
                  );

                  return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        title,
                        for (Variants v in sortie.variants) _BuildMissions(v)
                      ]);
                }

                return Container(
                    height: 200,
                    width: 250,
                    child: const Center(
                        child: Text(
                      'Server is rotating sorties',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20),
                    )));
              }
            }));
  }
}

class _BuildMissions extends StatelessWidget {
  const _BuildMissions(this.variants);

  final Variants variants;

  @override
  Widget build(BuildContext context) {
    final info = Theme.of(context).textTheme.subhead;
    final description =
        Theme.of(context).textTheme.caption.copyWith(fontSize: 13);

    return Container(
      padding: const EdgeInsets.only(bottom: 4.0),
      margin: const EdgeInsets.only(bottom: 4.0, right: 4.0, left: 4.0),
      child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('${variants.missionType} - ${variants.node}', style: info),
            Text(variants.modifierDescription, style: description),
          ]),
    );
  }
}
