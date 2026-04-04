import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:blogapps/features/home/domain/repositories/home_repository.dart';
import 'package:blogapps/features/home/presentation/bloc/home_event.dart';
import 'package:blogapps/features/home/presentation/bloc/home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeRepository repository;

  HomeBloc(this.repository) : super(const HomeState()) {
    on<HomeFetchData>(_onFetchData);
    on<HomeFilterByCategory>(_onFilterByCategory);
  }

  Future<void> _onFilterByCategory(HomeFilterByCategory event, Emitter<HomeState> emit) async {
    // If selecting the same category, clear filter (Toggle behavior)
    final newCategoryId = state.selectedCategoryId == event.categoryId ? null : event.categoryId;
    
    emit(state.copyWith(
      status: HomeStatus.loading,
      selectedCategoryId: () => newCategoryId,
    ));

    try {
      final posts = await repository.getLatestPosts(
        categoryId: newCategoryId,
      );

      emit(state.copyWith(
        status: HomeStatus.success,
        latestPosts: posts,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: HomeStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onFetchData(HomeFetchData event, Emitter<HomeState> emit) async {
    // Reset category when fetching fresh data
    emit(state.copyWith(
      selectedCategoryId: () => null,
    ));
    // 1. Return cached data immediately for instant load
    final cachedLatest = repository.getCachedLatestPosts();
    final cachedFeatured = repository.getCachedFeaturedPosts();
    final cachedCategories = repository.getCachedCategories();

    if (cachedLatest.isNotEmpty || cachedFeatured.isNotEmpty || cachedCategories.isNotEmpty) {
      emit(state.copyWith(
        status: HomeStatus.success,
        latestPosts: cachedLatest,
        featuredPosts: cachedFeatured,
        categories: cachedCategories,
      ));
    } else {
      emit(state.copyWith(status: HomeStatus.loading));
    }

    // 2. Fetch fresh data from remote
    try {
      final posts = await repository.getLatestPosts();
      final featured = await repository.getFeaturedPosts();
      final categories = await repository.getCategories();

      emit(state.copyWith(
        status: HomeStatus.success,
        latestPosts: posts,
        featuredPosts: featured,
        categories: categories,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: HomeStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }
}
