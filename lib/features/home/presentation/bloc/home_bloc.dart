import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:blogapps/features/home/domain/repositories/home_repository.dart';
import 'package:blogapps/features/home/presentation/bloc/home_event.dart';
import 'package:blogapps/features/home/presentation/bloc/home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeRepository repository;

  HomeBloc(this.repository) : super(const HomeState()) {
    on<HomeFetchData>(_onFetchData);
    on<HomeLoadMorePosts>(_onLoadMorePosts);
    on<HomeFilterByCategory>(_onFilterByCategory);
  }

  Future<void> _onFetchData(HomeFetchData event, Emitter<HomeState> emit) async {
    emit(state.copyWith(status: HomeStatus.loading));
    try {
      final featured = await repository.getFeaturedPosts();
      final latest = await repository.getLatestPosts(offset: 0);
      final categories = await repository.getCategories();

      emit(state.copyWith(
        status: HomeStatus.success,
        featuredPosts: featured,
        latestPosts: latest,
        categories: categories,
        hasReachedMax: latest.length < 10,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: HomeStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onLoadMorePosts(HomeLoadMorePosts event, Emitter<HomeState> emit) async {
    if (state.hasReachedMax || state.isLoadingMore) return;

    emit(state.copyWith(isLoadingMore: true));

    try {
      final morePosts = await repository.getLatestPosts(
        offset: state.latestPosts.length,
        categoryId: state.selectedCategoryId,
      );

      if (morePosts.isEmpty) {
        emit(state.copyWith(hasReachedMax: true, isLoadingMore: false));
      } else {
        emit(state.copyWith(
          status: HomeStatus.success,
          latestPosts: List.of(state.latestPosts)..addAll(morePosts),
          hasReachedMax: morePosts.length < 10,
          isLoadingMore: false,
        ));
      }
    } catch (e) {
      emit(state.copyWith(status: HomeStatus.failure, isLoadingMore: false));
    }
  }

  Future<void> _onFilterByCategory(HomeFilterByCategory event, Emitter<HomeState> emit) async {
    emit(state.copyWith(
      status: HomeStatus.loading,
      selectedCategoryId: event.categoryId,
      clearSelectedCategory: event.categoryId == null,
      latestPosts: [],
    ));
    
    try {
      final filteredPosts = await repository.getLatestPosts(
        offset: 0, 
        limit: 10,
        categoryId: event.categoryId,
      );

      emit(state.copyWith(
        status: HomeStatus.success,
        latestPosts: filteredPosts,
        clearSelectedCategory: event.categoryId == null,
        selectedCategoryId: event.categoryId,
        hasReachedMax: filteredPosts.length < 10,
      ));
    } catch (e) {
      emit(state.copyWith(status: HomeStatus.failure));
    }
  }
}
