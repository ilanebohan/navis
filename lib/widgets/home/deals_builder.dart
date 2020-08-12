import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:navis/blocs/bloc.dart';
import 'package:navis/global_keys.dart';
import 'package:navis/utils/size_config.dart';
import 'package:navis/widgets/widgets.dart';
import 'package:warframestat_api_models/entities.dart';

import 'deal_widget.dart';

class Deals extends StatelessWidget {
  const Deals({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Tiles(
      title: 'Darvo Deals',
      child: PageStorage(
        key: dealskey,
        bucket: dealsBucket,
        child: BlocBuilder<WorldstateBloc, WorldStates>(
          buildWhen: (WorldStates previous, WorldStates current) => listEquals(
              previous.worldstate?.dailyDeals, current.worldstate?.dailyDeals),
          builder: (_, state) {
            final List<DarvoDeal> dailyDeals =
                state.worldstate?.dailyDeals ?? [];

            dailyDeals.retainWhere((d) {
              return d.total - d.sold > 0 ||
                  d.expiry.difference(DateTime.now()) >
                      const Duration(seconds: 60);
            });

            return Carousel(
              dotCount: dailyDeals.length,
              height: SizeConfig.heightMultiplier * 33,
              enableIndicator: dailyDeals.length > 1,
              children: dailyDeals.map((d) => DealWidget(deal: d)).toList(),
            );
          },
        ),
      ),
    );
  }
}
