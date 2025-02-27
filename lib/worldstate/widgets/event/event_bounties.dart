import 'package:flutter/material.dart';
import 'package:navis/l10n/l10n.dart';
import 'package:navis_ui/navis_ui.dart';
import 'package:wfcd_client/entities.dart';

class EventBounties extends StatelessWidget {
  const EventBounties({super.key, required this.jobs});

  final List<Job> jobs;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final category =
        theme.textTheme.subtitle1?.copyWith(color: theme.colorScheme.secondary);

    return AppCard(
      child: Column(
        children: <Widget>[
          CategoryTitle(
            title: context.l10n.bountyTitle,
            style: category,
          ),
          SizedBoxSpacer.spacerHeight2,
          _BuildBounties(jobs: jobs),
        ],
      ),
    );
  }
}

class _BuildBounties extends StatelessWidget {
  const _BuildBounties({required this.jobs});

  final List<Job> jobs;

  void _showDialog(BuildContext context, String type, List<String> rewards) {
    final size = MediaQuery.of(context).size;
    final horizontal = (size.width / 100) * 2;
    final vertical = (size.height / 100) * 0.5;

    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text(type),
          contentPadding:
              EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical),
          children: <Widget>[
            for (final reward in rewards) ListTile(title: Text(reward)),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: jobs.map<Widget>((j) {
        return ListTile(
          title: Text(j.type ?? ''),
          subtitle: Text(
            context.l10n.levelInfo(j.enemyLevels.first, j.enemyLevels.last),
          ),
          onTap: () => _showDialog(context, j.type ?? '', j.rewardPool),
        );
      }).toList(),
    );
  }
}
