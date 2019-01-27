import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:navis/blocs/provider.dart';
import 'package:navis/blocs/worldstate_bloc.dart';
import 'package:navis/models/export.dart';

import 'package:navis/ui/widgets/cards.dart';
import 'package:navis/ui/widgets/row_item.dart';
import 'package:navis/ui/widgets/static_box.dart';
import 'package:navis/ui/widgets/countdown.dart';

class AlertTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final alert = BlocProvider.of<WorldstateBloc>(context);

    return Tiles(
        title: 'Alerts',
        child: Column(children: <Widget>[
          StreamBuilder(
              initialData: WorldstateBloc.initworldstate,
              stream: alert.worldstate,
              builder:
                  (BuildContext context, AsyncSnapshot<WorldState> snapshot) {
                List<Widget> allAlerts = snapshot.data.alerts
                    .map((alert) => _BuildAlerts(alert: alert))
                    .toList();

                return allAlerts.isEmpty
                    ? Center(child: Text('No alerts at this time'))
                    : Column(children: allAlerts);
              })
        ]));
  }
}

class _BuildAlerts extends StatelessWidget {
  final Alerts alert;

  _BuildAlerts({@required this.alert});

  void _addIcons(bool status, Widget icon, List<Widget> icons) {
    if (status) icons.insert(0, icon);
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> icons = [];

    final _nightmareIcon = SvgPicture.asset('assets/general/nightmare.svg',
        color: Colors.red, height: 25, width: 25);

    final _archwingIcon = SvgPicture.asset('assets/general/archwing.svg',
        color: Colors.blue, height: 25, width: 25);

    _addIcons(alert.mission.archwingRequired, _archwingIcon, icons);

    _addIcons(alert.mission.nightmare, _nightmareIcon, icons);

    return Container(
      padding: EdgeInsets.only(bottom: 8.0, top: 5.0),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            RowItem(
              icons: icons,
              text: alert.mission.node,
              child: alert.mission.reward.itemString.isEmpty
                  ? Container()
                  : StaticBox(
                      padding: EdgeInsets.zero,
                      color: Colors.blueAccent[400],
                      child: Text(
                        alert.mission.reward.itemString,
                        style: Theme.of(context).textTheme.body2,
                      )),
            ),
            RowItem(
                text:
                    '${alert.mission.type} (${alert.mission.faction}) | Level: ${alert.mission.minEnemyLevel} - ${alert.mission.maxEnemyLevel} | ${alert.mission.reward.credits}cr',
                caption: true,
                child: CountdownBox(expiry: alert.expiry)),
          ]),
    );
  }
}
