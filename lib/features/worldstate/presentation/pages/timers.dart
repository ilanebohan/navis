import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/navis_localizations.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:navis/core/utils/extensions.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:warframestat_api_models/entities.dart';

import '../../../../core/widgets/widgets.dart';
import '../../utils/faction_utils.dart';
import '../bloc/solsystem_bloc.dart';
import '../widgets/common/refresh_indicator_bloc_screen.dart';
import '../widgets/timers/timers.dart';

class Timers extends StatelessWidget {
  const Timers({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RefreshIndicatorBlocScreen(
      builder: (BuildContext context, SolsystemState state) {
        if (state is SolState) {
          return ScreenTypeLayout.builder(
            mobile: (_) => MobileTimers(state),
            tablet: (_) => TabletTimers(state),
          );
        }

        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}

List<CycleEntry> _buildCycles(
    NavisLocalizations locale, Worldstate worldstate) {
  const size = 28.0;

  const solCycle = <Icon>[
    Icon(Icons.brightness_7, color: Colors.amber, size: size),
    Icon(Icons.brightness_3, color: Colors.blue, size: size)
  ];

  const tempCycle = <Icon>[
    Icon(NavisSysIcons.heat_wave, color: Colors.red, size: size),
    Icon(Icons.ac_unit, color: Colors.blue, size: size)
  ];

  final cambionCycle = <Widget>[
    StaticBox.text(text: 'Fass'),
    StaticBox.text(text: 'Vome')
  ];

  return <CycleEntry>[
    CycleEntry(
      name: locale.earthCycleTitle,
      states: solCycle,
      cycle: worldstate.earthCycle,
    ),
    CycleEntry(
      name: locale.cetusCycleTitle,
      states: solCycle,
      cycle: worldstate.cetusCycle,
    ),
    CycleEntry(
      name: locale.vallisCycleTitle,
      states: tempCycle,
      cycle: worldstate.vallisCycle,
    ),
    CycleEntry(
      name: locale.cambionCycleTitle,
      states: cambionCycle,
      cycle: worldstate.cetusCycle,
    )
  ];
}

List<Progress> _buildProgress(
    NavisLocalizations locale, Worldstate worldstate) {
  return <Progress>[
    Progress(
      name: locale.formorianTitle,
      color: factionColor('Grineer'),
      progress: double.parse(worldstate.constructionProgress.fomorianProgress),
    ),
    Progress(
      name: locale.razorbackTitle,
      color: factionColor('Corpus'),
      progress: double.parse(worldstate.constructionProgress.razorbackProgress),
    )
  ];
}

class MobileTimers extends StatelessWidget {
  const MobileTimers(this.state);

  final SolState state;

  Worldstate get _worldstate => state.worldstate;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      key: const PageStorageKey<String>('mobile_timers'),
      cacheExtent: 1000,
      slivers: <Widget>[
        SliverOverlapInjector(
          // This is the flip side of the SliverOverlapAbsorber above.
          handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
        ),
        SliverList(
          delegate: SliverChildListDelegate([
            const DailyReward(),
            ConstructionProgressCard(
              constructionProgress: _buildProgress(context.locale, _worldstate),
            ),
            if (state.eventsActive) EventCard(events: _worldstate.events),
            if (state.activeAcolytes)
              AcolyteCard(enemies: _worldstate.persistentEnemies),
            if (state.arbitrationActive)
              ArbitrationCard(arbitration: _worldstate.arbitration),
            if (state.activeAlerts) AlertsCard(alerts: _worldstate.alerts),
            if (state.outpostDetected)
              SentientOutpostCard(outpost: _worldstate.sentientOutposts),
            CycleCard(cycles: _buildCycles(context.locale, _worldstate)),
            if (state.activeSiphons) KuvaCard(kuva: _worldstate.kuva),
            TraderCard(trader: _worldstate.voidTrader),
            if (state.activeSales) DarvoDealCard(deals: _worldstate.dailyDeals),
            SortieCard(sortie: _worldstate.sortie)
          ]),
        )
      ],
    );
  }
}

class TabletTimers extends StatelessWidget {
  const TabletTimers(this.state);

  final SolState state;

  Worldstate get _worldstate => state.worldstate;

  Map<Widget, StaggeredTile> _tiles(
      BuildContext context, NavisLocalizations navisLocalizations) {
    final size = MediaQuery.of(context).size.width ~/ 100;

    final large = size * 10;
    final medium = (size * 3.4).floor();
    final small = (size * 2.9).floor();

    return {
      const DailyReward(): StaggeredTile.fit(large),
      ConstructionProgressCard(
        constructionProgress: _buildProgress(navisLocalizations, _worldstate),
      ): StaggeredTile.fit(medium),
      if (state.eventsActive)
        EventCard(events: _worldstate.events): StaggeredTile.fit(medium),
      if (state.arbitrationActive)
        ArbitrationCard(arbitration: _worldstate.arbitration):
            StaggeredTile.fit(medium),
      if (state.activeAlerts)
        AlertsCard(alerts: _worldstate.alerts): StaggeredTile.fit(medium),
      if (state.outpostDetected)
        SentientOutpostCard(outpost: _worldstate.sentientOutposts):
            StaggeredTile.fit(medium),
      CycleCard(cycles: _buildCycles(navisLocalizations, _worldstate)):
          StaggeredTile.fit(small),
      TraderCard(trader: _worldstate.voidTrader): StaggeredTile.fit(medium),
      if (state.activeSales)
        DarvoDealCard(deals: _worldstate.dailyDeals): StaggeredTile.fit(medium),
      SortieCard(sortie: _worldstate.sortie): StaggeredTile.fit(small),
    };
  }

  @override
  Widget build(BuildContext context) {
    return StaggeredGridView.count(
      crossAxisCount: 75,
      staggeredTiles: _tiles(context, context.locale).values.toList(),
      children: _tiles(context, context.locale).keys.toList(),
    );
  }
}
