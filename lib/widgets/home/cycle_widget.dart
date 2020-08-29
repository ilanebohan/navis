import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:navis/widgets/widgets.dart';
import 'package:warframestat_api_models/objects.dart';

class CycleWidget extends StatelessWidget {
  const CycleWidget({Key key, this.title, this.customState, this.cycle})
      : super(key: key);

  final String title, customState;
  final CycleObject cycle;

  @override
  Widget build(BuildContext context) {
    final state = toBeginningOfSentenceCase(customState ?? cycle.state);

    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            title,
            style: Theme.of(context).textTheme.subtitle1.copyWith(fontSize: 17),
          ),
          const Spacer(),
          Text(
            state,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20.0,
              color: cycle.getStateBool ? Colors.yellow[700] : Colors.blue,
            ),
          ),
          const SizedBox(width: 8.0),
          CountdownBox(expiry: cycle.expiry),
        ],
      ),
    );
  }
}
