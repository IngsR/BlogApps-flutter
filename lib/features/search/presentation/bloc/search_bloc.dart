import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:blogapps/core/common/entities/blog_post.dart';
import 'package:blogapps/features/search/domain/repositories/search_repository.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchRepository repository;

  SearchBloc(this.repository) : super(const SearchState()) {
    on<SearchPosts>(_onSearchPosts);
  }

  Future<void> _onSearchPosts(
    SearchPosts event,
    Emitter<SearchState> emit,
  ) async {
    if (event.query.isEmpty) {
      emit(state.copyWith(status: SearchStatus.initial, posts: []));
      return;
    }

    emit(state.copyWith(status: SearchStatus.loading));

    try {
      final posts = await repository.searchPosts(event.query);
      emit(state.copyWith(status: SearchStatus.success, posts: posts));
    } catch (e) {
      emit(
        state.copyWith(
          status: SearchStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
