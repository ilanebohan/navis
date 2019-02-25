import 'package:flutter/material.dart';
import 'package:navis/global_keys.dart';

class CustomScaffold extends StatefulWidget {
  const CustomScaffold({this.pageChilderen, this.childeren});

  final List<Widget> pageChilderen;
  final List<BottomNavigationBarItem> childeren;

  @override
  CustomScaffoldState createState() => CustomScaffoldState();
}

class CustomScaffoldState extends State<CustomScaffold>
    with TickerProviderStateMixin {
  int _currentPage = 1;
  List<NavigationFade> transWidget;

  @override
  void initState() {
    super.initState();

    transWidget = widget.pageChilderen
        .map((Widget w) => NavigationFade(child: w, vsync: this))
        .toList();

    for (NavigationFade view in transWidget)
      view.controller.addListener(_rebuild);

    transWidget[_currentPage].controller.value = 1.0;
  }

  @override
  void dispose() {
    for (NavigationFade child in transWidget) child.controller.dispose();
    super.dispose();
  }

  Widget _buildTransitionsStack() {
    final List<FadeTransition> transitions = <FadeTransition>[];

    for (NavigationFade child in transWidget)
      transitions.add(child.transition(context));

    // We want to have the newly animating (fading in) views on top.
    transitions.sort((FadeTransition a, FadeTransition b) {
      final Animation<double> aAnimation = a.opacity;
      final Animation<double> bAnimation = b.opacity;
      final double aValue = aAnimation.value;
      final double bValue = bAnimation.value;
      return aValue.compareTo(bValue);
    });

    return Stack(children: transitions);
  }

  void _rebuild() {
    setState(() {
      // Rebuild in order to animate views.
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffold,
        appBar: AppBar(title: const Text('Navis'), actions: <Widget>[
          IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () => Navigator.of(context).pushNamed('/Settings'))
        ]),
        body: _buildTransitionsStack(),
        bottomNavigationBar: Theme(
            data: Theme.of(context).copyWith(
                canvasColor: const Color(0xFF222222),
                brightness: Brightness.dark),
            child: BottomNavigationBar(
              currentIndex: _currentPage,
              items: widget.childeren,
              onTap: (int index) {
                setState(() {
                  transWidget[_currentPage].controller.reverse();
                  _currentPage = index;
                  transWidget[index].controller.forward();
                });
              },
            )));
  }
}

class NavigationFade {
  NavigationFade({
    Widget child,
    TickerProvider vsync,
  })  : _child = child,
        controller = AnimationController(
          duration: const Duration(milliseconds: 200),
          vsync: vsync,
        ) {
    _animation = controller.drive(CurveTween(
      curve: const Interval(0.5, 1.0, curve: Curves.easeInOut),
    ));
  }

  final Widget _child;
  final AnimationController controller;
  Animation<double> _animation;

  FadeTransition transition(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: _child,
    );
  }
}
