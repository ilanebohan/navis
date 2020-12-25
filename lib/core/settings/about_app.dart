import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_brand_icons/flutter_brand_icons.dart';
import 'package:package_info/package_info.dart';

import '../../constants/links.dart';
import '../../injection_container.dart';
import '../utils/extensions.dart';
import '../utils/helper_methods.dart';
import '../widgets/widgets.dart';

class AboutApp extends StatelessWidget {
  const AboutApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        CategoryTitle(title: context.locale.aboutCategoryTitle),
        ListTile(
          title: Text(context.locale.reportBugsTitle),
          subtitle: Text(context.locale.reportBugsDescription),
          onTap: () => launchLink(context, issuePage),
        ),
        const About()
      ],
    );
  }
}

class About extends StatelessWidget {
  const About({Key key}) : super(key: key);

  static const double _iconSize = 30.0;

  @override
  Widget build(BuildContext context) {
    final info = sl<PackageInfo>();

    final theme = Theme.of(context);
    final isDark = theme.brightness != Brightness.light;

    final aboutTextStyle = theme.textTheme.bodyText1;
    final linkStyle =
        theme.textTheme.bodyText1.copyWith(color: theme.accentColor);

    return AboutListTile(
      icon: null,
      applicationIcon: const Icon(
        NavisSysIcons.nightmare,
        size: 60,
        color: Color(0xFF1565C0),
      ),
      applicationName: 'Cephalon Navis',
      applicationVersion: info.version,
      aboutBoxChildren: <Widget>[
        const SizedBox(height: 12.0),
        RichText(
          text: TextSpan(children: <TextSpan>[
            TextSpan(
              style: aboutTextStyle,
              text: '${context.locale.homePageTitle} ',
            ),
            _LinkTextSpan(
              style: linkStyle,
              url: projectPage,
              text: projectPage,
            ),
            TextSpan(
              style: aboutTextStyle,
              text: '\n\n${context.locale.issueTrackerDescription} ',
            ),
            _LinkTextSpan(
              style: linkStyle,
              url: issuePage,
              text: context.locale.issueTrackerTitle,
            ),
            TextSpan(
              style: Theme.of(context).textTheme.caption,
              text: '\n\n${context.locale.legalese}',
            ),
            TextSpan(
              style: Theme.of(context).textTheme.caption,
              text: '${context.locale.warframeLinkTitle} ',
            ),
            _LinkTextSpan(
              style: linkStyle,
              url: warframePage,
              text: warframePage,
            )
          ]),
        ),
        const SizedBox(height: 12.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            IconButton(
              icon: const Icon(BrandIcons.discord, color: Color(0xFF7289DA)),
              iconSize: _iconSize,
              splashColor: Colors.transparent,
              onPressed: () => launchLink(context, discordInvite),
            ),
            const SizedBox(width: 25),
            IconButton(
              icon: Icon(
                BrandIcons.github,
                color: isDark ? Colors.white : const Color(0xFF181717),
              ),
              iconSize: _iconSize,
              splashColor: Colors.transparent,
              onPressed: () => launchLink(context, projectPage),
            ),
            const SizedBox(width: 25),
            IconButton(
              icon: const FaIcon(
                NavisSysIcons.wfcdLogoColor,
                color: Color(0xFF2e96ef),
              ),
              iconSize: _iconSize,
              splashColor: Colors.transparent,
              onPressed: () => launchLink(context, communityPage),
            )
          ],
        ),
      ],
    );
  }
}

class _LinkTextSpan extends TextSpan {
  // Beware!
  //
  // This class is only safe because the TapGestureRecognizer is not
  // given a deadline and therefore never allocates any resources.
  //
  // In any other situation -- setting a deadline, using any of the less trivial
  // recognizers, etc -- you would have to manage the gesture recognizer's
  // lifetime and call dispose() when the TextSpan was no longer being rendered.
  //
  // Since TextSpan itself is @immutable, this means that you would have to
  // manage the recognizer from outside the TextSpan, e.g. in the State of a
  // stateful widget that then hands the recognizer to the TextSpan.
  _LinkTextSpan({
    BuildContext context,
    TextStyle style,
    String url,
    String text,
  }) : super(
          style: style,
          text: text ?? url,
          recognizer: TapGestureRecognizer()
            ..onTap = () => launchLink(context, url),
        );
}
