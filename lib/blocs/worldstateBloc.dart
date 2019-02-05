import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';
import 'package:navis/utils/factionutils.dart';

import '../services/repository.dart';
import 'wordstateStates.dart';

abstract class StateEvent {}

class UpdateState extends StateEvent {}

class WorldstateBloc extends Bloc<StateEvent, WorldStates> {
  final repository = Respiratory();
  final DateFormat format = DateFormat.jms().add_yMd();

  @override
  WorldStates get initialState => WorldstateUninitialized();

  @override
  Stream<StateEvent> transform(Stream<StateEvent> events) {
    // ignore: avoid_as
    return (events as Observable<StateEvent>).distinct();
  }

  @override
  Stream<WorldStates> mapEventToState(currentState, event) async* {
    try {
      if (currentState is WorldstateUninitialized) {
        final state = await repository.getState();
        yield WorldstateLoaded(worldState: state);
      }
      if (currentState is WorldstateLoaded) {
        final state = await repository.getState();
        yield WorldstateLoaded(worldState: state);
      }
    } catch (e) {
      yield WorldstateError(error: e);
    }
  }

  Factionutils get factionUtils => Factionutils();

  String expiration(DateTime expiry) {
    try {
      return format.format(expiry);
    } catch (err) {
      return 'Fetching Date';
    }
  }

  Future<void> update() async {
    await Future.delayed(Duration(milliseconds: 200));
    dispatch(UpdateState());
  }
}
