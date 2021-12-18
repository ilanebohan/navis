import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:navis/home/cubit/navigation_cubit.dart';
import 'package:navis/home/widgets/n_drawer.dart';
import 'package:navis/injection_container.dart';
import 'package:navis/worldstate/cubits/darvodeal_cubit.dart';
import 'package:navis/worldstate/cubits/solsystem_cubit.dart';
import 'package:navis_ui/navis_ui.dart';
import 'package:user_settings/user_settings.dart';
import 'package:worldstate_repository/worldstate_repository.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final repository = sl<WorldstateRepository>();
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => NavigationCubit()),
        BlocProvider(
          create: (_) => SolsystemCubit(repository)..fetchWorldstate(),
        ),
        BlocProvider(create: (_) => DarvodealCubit(repository))
      ],
      child: const Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final GlobalKey<ScaffoldState> scaffold = GlobalKey<ScaffoldState>();

  Future<bool> _willPop() async {
    if (context.read<UserSettingsNotifier>().backKey) {
      if (!scaffold.currentState!.isDrawerOpen) {
        scaffold.currentState!.openDrawer();
        return false;
      } else {
        return true;
      }
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _willPop,
      child: Scaffold(
        key: scaffold,
        appBar: AppBar(),
        drawer: const NDrawer(),
        body: BlocBuilder<NavigationCubit, Widget>(
          builder: (BuildContext context, Widget state) {
            return AnimatedSwitcher(
              duration: kAnimationShort,
              child: state,
            );
          },
        ),
      ),
    );
  }
}
