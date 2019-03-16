import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:navis/models/export.dart';
import 'package:navis/ui/routes/syndicates/rewards.dart';
import 'package:navis/ui/widgets/layout.dart';

class EventPanel extends StatefulWidget {
  const EventPanel({this.events});

  final List<Event> events;

  @override
  EventPanelState createState() => EventPanelState();
}

class EventPanelState extends State<EventPanel> {
  final _dotKey = PageStorageBucket();
  int _currentPage;

  @override
  void initState() {
    super.initState();

    _currentPage = 0;
  }

  @override
  void didUpdateWidget(EventPanel oldWidget) {
    if (oldWidget.events != widget.events) _currentPage = 0;

    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _currentPage = null;

    super.dispose();
  }

  void onPageChanged(int index) {
    setState(() {
      _currentPage = index;
      _dotKey.writeState(context, index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool enableDots = widget.events.length <= 1;

    return PageStorage(
        bucket: _dotKey,
        child: SizedBox(
            height: 140,
            width: MediaQuery.of(context).size.width,
            child: Material(
                color: Theme.of(context).cardColor,
                elevation: 6,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Expanded(
                        child: PageView(
                      scrollDirection: Axis.horizontal,
                      children: widget.events
                          .map((e) => EventBuilder(event: e))
                          .toList(),
                      onPageChanged: onPageChanged,
                    )),
                    enableDots
                        ? Container()
                        : DotsIndicator(
                            numberOfDot: widget.events.length,
                            position:
                                _dotKey.readState(context) ?? _currentPage,
                            dotActiveColor: Theme.of(context).accentColor,
                          )
                  ],
                ))));
  }
}

class EventBuilder extends StatelessWidget {
  const EventBuilder({this.event});

  final Event event;

  Color _healthColor(double health) {
    if (health > 50.0)
      return Colors.green;
    else if (health <= 50.0 && health >= 10.0)
      return Colors.orange[700];
    else
      return Colors.red;
  }

  void _addReward(BuildContext context, bool bounty, List<Widget> children) {
    if (bounty) {
      children.addAll(event.jobs.map((j) => _buildJob(context, j)));
    } else {
      if (event.rewards.isNotEmpty) {
        final reward = event.rewards.first;
        if (reward.itemString.isNotEmpty) {
          final withCredits =
              '${event.rewards.first.itemString} + ${event.rewards.first.credits}cr';
          final withoutCredits = '${event.rewards.first.itemString}';

          children.add(StaticBox.text(
              color: Colors.green,
              text: event.rewards.first.credits < 100
                  ? withoutCredits
                  : withCredits));
        }

        children.add(Container());
      }

      children.add(Container());
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = [];

    final victimNode = event.victimNode == null
        ? Container()
        : StaticBox.text(text: event.victimNode, color: Colors.red);

    final progress = event.health == null
        ? Container()
        : StaticBox.text(
            text: '${event.health}% Remaining',
            color: _healthColor(double.parse(event.health)),
          );

    _addReward(context, event.jobs?.isNotEmpty ?? false, children);

    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
              margin: const EdgeInsets.only(bottom: 4, top: 3),
              child: Text(event.description,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.title)),
          event.tooltip == null
              ? Container()
              : Container(
                  margin: const EdgeInsets.only(bottom: 4),
                  child: Text(event.tooltip,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.subtitle)),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            victimNode,
            const SizedBox(width: 4),
            progress
          ]),
          const SizedBox(height: 4),
          Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: children)
        ]);
  }
}

Widget _buildJob(BuildContext context, Jobs job) {
  return Card(
    margin: const EdgeInsets.only(right: 3.0),
    color: Colors.blueAccent[400],
    child: InkWell(
        onTap: () => Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => BountyRewards(
                missionTYpe: job.type,
                bountyRewards: job.rewardPool.cast<String>()))),
        child: Container(
            margin: const EdgeInsets.all(4.0),
            padding: const EdgeInsets.all(4.0),
            width: MediaQuery.of(context).size.width / 2.2,
            alignment: Alignment.center,
            child: Text(job.type,
                overflow: TextOverflow.ellipsis, textAlign: TextAlign.center))),
  );
}
