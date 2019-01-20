import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:navis/models/export.dart';

import 'package:navis/APIs/worldstate.dart';

class BountyRewards extends StatelessWidget {
  final List<String> bountyRewards;

  final String missionTYpe;

  BountyRewards({Key key, this.missionTYpe, this.bountyRewards})
      : super(key: key);

  Future<List<Reward>> getRewards() async {
    List<Reward> imageList = await WorldstateAPI.rewards();
    List<Reward> rewards = [];
    final nonexistent = Reward()
      ..rewardName = 'reward doesn\'t exist'
      ..imagePath = null;

    bountyRewards.forEach((r) {
      var image = List.from(imageList);
      try {
        image.retainWhere((i) => r.contains(i.rewardName) == true);
        rewards.add(image.first);
      } catch (err) {
        rewards.add(nonexistent);
      }
    });

    return rewards;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(missionTYpe)),
        body: _buildForSyndicates(getRewards(), bountyRewards));
  }
}

Widget _buildForSyndicates(
    Future<List<Reward>> future, List<String> bountyRewards) {
  return FutureBuilder<List<Reward>>(
      future: future,
      builder: (BuildContext context, AsyncSnapshot<List<Reward>> snapshot) {
        if (!snapshot.hasData)
          return Center(child: CircularProgressIndicator());

        return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (BuildContext context, int index) {
              final reward = snapshot.data[index];

              final rewardIcon = reward.imagePath == null
                  ? SvgPicture.asset('assets/general/nightmare.svg',
                      color: Colors.red, height: 50, width: 50)
                  : Image.network(reward.imagePath,
                      scale: 8.0, fit: BoxFit.cover);

              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0, top: 8.0),
                child: Center(
                  child: ListTile(
                      leading: rewardIcon,
                      title: Text(bountyRewards[index],
                          style: TextStyle(fontSize: 17.0))),
                ),
              );
            });
      });
}
