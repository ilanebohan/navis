import 'package:flutter/material.dart';
import 'package:navis/utils/factionutils.dart';
import 'package:navis/blocs/bloc.dart';
import 'package:navis/models/export.dart';
import 'package:navis/ui/widgets/cards.dart';
import 'package:navis/ui/routes/maps/map.dart';
import 'package:navis/ui/routes/syndicates/syndicate_missions.dart';

class SyndicateStyle extends StatelessWidget {
  const SyndicateStyle({this.syndicate});

  final Syndicate syndicate;

  static const Color ostronsColor = Color.fromRGBO(183, 70, 36, 1.0);
  static const Color solarisColor = Color.fromRGBO(206, 162, 54, 1.0);

  @override
  Widget build(BuildContext context) {
    final dynamic factionutils =
        BlocProvider.of<WorldstateBloc>(context).factionUtils;

    final bool ostron = syndicate.name == 'Ostrons';

    return Tiles(
      color: ostron ? ostronsColor : solarisColor,
      child: InkWell(
        onTap: () => _navigateToBounties(context, syndicate),
        splashColor: Colors.transparent,
        child: Container(
          child: Row(mainAxisSize: MainAxisSize.max, children: <Widget>[
            Container(
                child: factionutils.factionIcon(syndicate.name, size: 60.0)),
            Expanded(
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                  Text(syndicate.name,
                      style: Theme.of(context)
                          .textTheme
                          .subhead
                          .copyWith(color: Colors.white)),
                  Text('Tap to see bounties',
                      style: Theme.of(context)
                          .textTheme
                          .subtitle
                          .copyWith(color: Colors.white70))
                ])),
            IconButton(
                iconSize: 30,
                icon: const Icon(Icons.map, color: Colors.white),
                onPressed: () => _navigateToMap(context, syndicate.name))
          ]),
        ),
      ),
    );
  }
}

void _navigateToMap(BuildContext context, String syndicate) {
  Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => Maps(location: _locaton(syndicate))));
}

void _navigateToBounties(BuildContext context, Syndicate syn) {
  Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => SyndicateJobs(faction: _faction(syn.name))));
}

Location _locaton(String syndicateName) {
  switch (syndicateName) {
    case 'Ostrons':
      return Location.plains;
    default:
      return Location.vallis;
  }
}

OpenWorldFactions _faction(String faction) {
  switch (faction) {
    case 'Ostrons':
      return OpenWorldFactions.cetus;
    default:
      return OpenWorldFactions.fortuna;
  }
}
