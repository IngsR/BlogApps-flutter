import 'package:equatable/equatable.dart';
import 'package:blogapps/features/home/data/models/blog_post_model.dart';
import 'package:blogapps/features/search/domain/repositories/search_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';

abstract class SearchEvent extends Equatable {
  const SearchEvent();
  @override
  List<Object?> get props => [];
}

class SearchQueryChanged extends SearchEvent {
  final String query;
  const SearchQueryChanged(this.query);
  @override
  List<Object?> get props => [query];
}

enum SearchStatus { initial, loading, success, failure }

class SearchState extends Equatable {
  final SearchStatus status;
  final List<BlogPost> results;
  final String? errorMessage;

  const SearchState({
    this.status = SearchStatus.initial,
    this.results = const [],
    this.errorMessage,
  });

  SearchState copyWith({
    SearchStatus? status,
    List<BlogPost>? results,
    String? errorMessage,
  }) {
    return SearchState(
      status: status ?? this.status,
      results: results ?? this.results,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, results, errorMessage];
}

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchRepository repository;
  Timer? _debounce;

  SearchBloc(this.repository) : super(const SearchState()) {
    on<SearchQueryChanged>(_onQueryChanged);
    on<_SearchExecuteTask>(_onExecuteSearch);
  }

  void _onQueryChanged(SearchQueryChanged event, Emitter<SearchState> emit) {
    if (event.query.isEmpty) {
      emit(state.copyWith(status: SearchStatus.initial, results: []));
      return;
    }

    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      add(_SearchExecuteTask(event.query));
    });
  }

  Future<void> _onExecuteSearch(_SearchExecuteTask event, Emitter<SearchState> emit) async {
    emit(state.copyWith(status: SearchStatus.loading));
    try {
      final results = await repository.searchPosts(event.query);
      emit(state.copyWith(status: SearchStatus.success, results: results));
    } catch (e) {
      emit(state.copyWith(status: SearchStatus.failure, errorMessage: e.toString()));
    }
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }
}

class _SearchExecuteTask extends SearchEvent {
  final String query;
  const _SearchExecuteTask(this.query);
}
