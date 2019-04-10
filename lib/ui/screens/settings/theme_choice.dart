import 'package:flutter/material.dart';

import 'package:navis/ui/widgets/dialogs.dart';

class ThemeChoice extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bool brightness = Theme.of(context).brightness == Brightness.dark;

    return Container(
        child: Column(children: <Widget>[
      Container(
          padding: const EdgeInsets.only(top: 10.0, left: 8.0),
          alignment: Alignment.centerLeft,
          child: Text('Appearance',
              style:
                  Theme.of(context).textTheme.subtitle.copyWith(fontSize: 15))),
      ListTile(
          title: const Text('Theme'),
          subtitle: Text(brightness ? 'Dark' : 'Light'),
          onTap: () => BaseThemePickerDialog.showBaseThemePicker(context)),
      //Divider(color: Theme.of(context).accentColor),
      ListTile(
          title: const Text('Primary Color'),
          subtitle: const Text('Most visible color'),
          onTap: () => ColorPickerDialog.selectPrimary(context)),
      ListTile(
          title: const Text('Accent Color'),
          subtitle: const Text('Color used to tint certaint text elements'),
          onTap: () => ColorPickerDialog.selectAccent(context))
    ]));
  }
}
