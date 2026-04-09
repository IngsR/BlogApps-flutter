import 'package:equatable/equatable.dart';
import 'package:blogapps/core/common/entities/blog_post.dart';
import 'package:blogapps/core/common/entities/category.dart';

enum HomeStatus { initial, loading, success, failure }

class HomeState extends Equatable {
  final HomeStatus status;
  final List<BlogPost> latestPosts;
  final List<BlogPost> featuredPosts;
  final List<Category> categories;
  final String? selectedCategoryId;
  final String? errorMessage;
  final bool hasReachedMax;

  const HomeState({
    this.status = HomeStatus.initial,
    this.latestPosts = const [],
    this.featuredPosts = const [],
    this.categories = const [],
    this.selectedCategoryId,
    this.errorMessage,
    this.hasReachedMax = false,
  });

  HomeState copyWith({
    HomeStatus? status,
    List<BlogPost>? latestPosts,
    List<BlogPost>? featuredPosts,
    List<Category>? categories,
    String? Function()? selectedCategoryId,
    String? errorMessage,
    bool? hasReachedMax,
  }) {
    return HomeState(
      status: status ?? this.status,
      latestPosts: latestPosts ?? this.latestPosts,
      featuredPosts: featuredPosts ?? this.featuredPosts,
      categories: categories ?? this.categories,
      selectedCategoryId: selectedCategoryId != null
          ? selectedCategoryId()
          : this.selectedCategoryId,
      errorMessage: errorMessage ?? this.errorMessage,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object?> get props => [
    status,
    latestPosts,
    featuredPosts,
    categories,
    selectedCategoryId,
    errorMessage,
    hasReachedMax,
  ];
}
