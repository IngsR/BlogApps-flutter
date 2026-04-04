part of 'search_bloc.dart';

enum SearchStatus { initial, loading, success, failure }

class SearchState extends Equatable {
  final SearchStatus status;
  final List<BlogPost> posts;
  final String? errorMessage;

  const SearchState({
    this.status = SearchStatus.initial,
    this.posts = const [],
    this.errorMessage,
  });

  SearchState copyWith({
    SearchStatus? status,
    List<BlogPost>? posts,
    String? errorMessage,
  }) {
    return SearchState(
      status: status ?? this.status,
      posts: posts ?? this.posts,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, posts, errorMessage];
}
