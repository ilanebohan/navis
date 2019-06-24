import 'package:flutter/material.dart';
import 'package:navis/components/layout/drawer_about.dart';
import 'drawer_options.dart';

class LotusDrawer extends StatelessWidget {
  const LotusDrawer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Drawer(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
          Container(
              height: 100,
              margin: const EdgeInsets.only(bottom: 8.0),
              decoration: BoxDecoration(color: Theme.of(context).primaryColor)),
          Expanded(child: DrawerOptions()),
          Divider(color: Theme.of(context).accentColor, height: 4.0),
          ListTile(
            leading: Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushNamed('/Settings');
            },
          ),
          const About()
        ])));
  }
}
