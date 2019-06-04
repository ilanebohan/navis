import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart' as custom;
import 'package:url_launcher/url_launcher.dart';

import '../global_keys.dart';

const String warframeTwitch = 'twitch://open?stream=warframe';

Future<void> launchLink(BuildContext context, String link,
    {bool isStream = false}) async {
  try {
    if (isStream) {
      if (await canLaunch(warframeTwitch))
        await launch('twitch://open?stream=warframe');
      else
        launchLink(context, link, isStream: false);
    } else
      await custom.launch(link,
          option: custom.CustomTabsOption(
              toolbarColor: Theme.of(context).primaryColor,
              enableDefaultShare: true,
              enableUrlBarHiding: true,
              showPageTitle: true,
              animation: custom.CustomTabsAnimation.slideIn(),
              extraCustomTabs: const <String>[
                'org.mozilla.firefox',
                'com.microsoft.emmx'
              ]));
  } catch (err) {
    scaffold.currentState.showSnackBar(SnackBar(
        duration: const Duration(seconds: 5),
        content: link.isEmpty
            ? const Text('No valid link provided by API')
            : const Text('No App compatible detected to open link')));
  }
}
