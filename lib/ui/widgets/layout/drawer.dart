import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:package_info/package_info.dart';

import '../styles/platform_choices.dart';

const legalese =
    'Warframe and the Warframe logo are registered trademarks of Digital Extremes Ltd. Cephalon Navis is not affiliated with Digital Extremes Ltd. in any way.';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({this.currentIndex, this.children});

  final List<DrawerItem> children;
  final int currentIndex;

  Widget _buildDrawerItem(DrawerItem item) {
    if (item.children == null || item.children.isEmpty)
      return ListTile(
        leading: item.icon,
        title: Text(item.title),
        onTap: item.callback,
        selected: currentIndex == children.indexOf(item),
      );

    return ExpansionTile(
      leading: item.icon,
      title: Text(item.title),
      children: item.children.map(_buildDrawerItem).toList(),
    );
  }

  Widget _appIcon() => Container(
        decoration: BoxDecoration(
            border: Border.all(color: Colors.white),
            color: Colors.white,
            borderRadius: BorderRadius.circular(60.0)),
        child: SvgPicture.asset(
          'assets/general/nightmare.svg',
          height: 60,
          width: 60,
          color: const Color.fromRGBO(26, 80, 144, .9),
        ),
      );

  Widget body() => Expanded(
      child: ListView(
          padding: EdgeInsets.zero,
          children: children.map(_buildDrawerItem).toList()));

  Widget aboutTile() => FutureBuilder<PackageInfo>(
      future: PackageInfo.fromPlatform(),
      builder: (_, snapshot) {
        return AboutListTile(
          icon: const Icon(Icons.info),
          applicationIcon: _appIcon(),
          applicationName: 'Cephalon Navis',
          applicationVersion: snapshot.data?.version ?? '',
          applicationLegalese: legalese,
        );
      });

  Widget settings(BuildContext context) => ListTile(
        leading: const Icon(Icons.settings),
        title: const Text('Settings'),
        onTap: () {
          Navigator.of(context).pop();
          Navigator.of(context).pushNamed('/Settings');
        },
      );

  @override
  Widget build(BuildContext context) {
    final List<Widget> _items = []
      ..insert(0, Container(height: 76, color: Theme.of(context).accentColor))
      ..add(body())
      ..add(const PlatformChoice())
      ..add(settings(context));
    //..add(aboutTile());

    return Drawer(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center, children: _items));
  }
}

class DrawerItem {
  const DrawerItem({this.icon, this.title, this.children, this.callback});

  final Icon icon;
  final String title;
  final List<DrawerItem> children;
  final VoidCallback callback;
}
