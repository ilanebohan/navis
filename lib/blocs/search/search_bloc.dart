import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:navis/services/repository.dart';
import 'package:navis/utils/search_utils.dart';
import 'package:rxdart/rxdart.dart';
import 'package:warframestat_api_models/warframestat_api_models.dart';

import 'search_event.dart';
import 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc(this.repository);

  final Repository repository;

  @override
  SearchState get initialState => SearchStateEmpty();

  @override
  Stream<Transition<SearchEvent, SearchState>> transformEvents(
    events,
    transitionFn,
  ) {
    return super.transformEvents(
      events.distinct().debounceTime(const Duration(milliseconds: 500)),
      transitionFn,
    );
  }

  @override
  Stream<SearchState> mapEventToState(
    SearchEvent event,
  ) async* {
    final type = repository.persistent?.searchType ?? CodexDatabase.drops;

    if (event is TextChanged) {
      final searchText = event.text;

      if (searchText.isEmpty) {
        yield SearchStateEmpty();
      } else {
        yield SearchStateLoading();

        try {
          if (type == CodexDatabase.drops) {
            final results = await repository.searchDrops(searchText);

            yield SearchStateSuccess<SlimDrop>(results);
          } else {
            final results = await repository.searchItems(searchText);

            yield SearchStateSuccess<BaseItem>(results);
          }
        } catch (e) {
          yield SearchStateError(e.toString());
        }
      }
    }

    if (event is SortSearch) {
      if (type == CodexDatabase.drops) {
        final sorted =
            await compute(sortDrops, SortedDrops(event.sortBy, event.results));

        yield SearchStateSuccess(sorted, sortBy: event.sortBy);
      }
    }

    if (event is SearchError) {
      yield SearchListenerError(event.error);
    }
  }
}
