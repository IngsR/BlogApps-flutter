import 'package:equatable/equatable.dart';
import 'package:blogapps/features/home/data/models/blog_post_model.dart';
import 'package:blogapps/features/home/data/models/category_model.dart';

enum HomeStatus { initial, loading, success, failure }

class HomeState extends Equatable {
  final HomeStatus status;
  final List<BlogPost> featuredPosts;
  final List<BlogPost> latestPosts;
  final List<Category> categories;
  final String? selectedCategoryId;
  final bool hasReachedMax;
  final bool isLoadingMore;
  final String? errorMessage;

  const HomeState({
    this.status = HomeStatus.initial,
    this.featuredPosts = const [],
    this.latestPosts = const [],
    this.categories = const [],
    this.selectedCategoryId,
    this.hasReachedMax = false,
    this.isLoadingMore = false,
    this.errorMessage,
  });

  HomeState copyWith({
    HomeStatus? status,
    List<BlogPost>? featuredPosts,
    List<BlogPost>? latestPosts,
    List<Category>? categories,
    String? selectedCategoryId, // We'll handle null specially if we use another pattern, but let's see.
    bool? hasReachedMax,
    bool? isLoadingMore,
    String? errorMessage,
    bool clearSelectedCategory = false, // New flag
  }) {
    return HomeState(
      status: status ?? this.status,
      featuredPosts: featuredPosts ?? this.featuredPosts,
      latestPosts: latestPosts ?? this.latestPosts,
      categories: categories ?? this.categories,
      selectedCategoryId: clearSelectedCategory ? null : (selectedCategoryId ?? this.selectedCategoryId),
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status, 
    featuredPosts, 
    latestPosts, 
    categories, 
    selectedCategoryId,
    hasReachedMax, 
    isLoadingMore,
    errorMessage,
  ];
}
