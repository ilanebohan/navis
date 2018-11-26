import 'dart:async';

import 'package:flutter/material.dart';
import 'package:navis/blocs/provider.dart';
import 'package:navis/blocs/theming.dart';

class ThemeChoice extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = BlocProvider.of<ThemeBloc>(context);

    return Column(children: <Widget>[
      Padding(
          padding: EdgeInsets.only(top: 8.0, left: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text('Appearance',
                  style: TextStyle(
                    color: Theme.of(context).textTheme.caption.color,
                    fontWeight: FontWeight.bold,
                    fontSize: 15.0,
                  ))
            ],
          )),
      ListTile(
          title: Text('Theme'),
          subtitle: Text(Theme.of(context).brightness == Brightness.dark
              ? 'Dark'
              : 'Light'),
          onTap: () => showOptions(context, theme))
    ]);
  }
}

Future<Null> showOptions(BuildContext context, ThemeBloc theme) {
  final accentColor = Theme.of(context).accentColor;
  final groupValue = Theme.of(context).brightness;

  return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return StreamBuilder<ThemeData>(
            initialData: theme.defaultTheme,
            stream: theme.themeDataStream,
            builder: (BuildContext context, AsyncSnapshot<ThemeData> snapshot) {
              return SimpleDialog(
                  contentPadding: EdgeInsets.zero,
                  title: Text('Select Theme'),
                  children: <Widget>[
                    RadioListTile<Brightness>(
                        title: Text('Dark'),
                        activeColor: accentColor,
                        value: Brightness.dark,
                        groupValue: groupValue,
                        onChanged: (newTheme) {
                          theme.setTheme(newTheme);
                          Navigator.pop(context);
                        }),
                    RadioListTile<Brightness>(
                        title: Text('Light'),
                        activeColor: accentColor,
                        value: Brightness.light,
                        groupValue: groupValue,
                        onChanged: (newTheme) {
                          theme.setTheme(newTheme);
                          Navigator.pop(context);
                        }),
                    ButtonTheme.bar(
                        child: ButtonBar(children: <Widget>[
                      FlatButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text('Cancel',
                              style: TextStyle(
                                  color:
                                      Theme.of(context).textTheme.body1.color)))
                    ]))
                  ]);
            });
      });
}
