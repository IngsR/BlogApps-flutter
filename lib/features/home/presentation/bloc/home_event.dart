import 'package:equatable/equatable.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

class HomeFetchData extends HomeEvent {}

class HomeLoadMorePosts extends HomeEvent {}

class HomeFilterByCategory extends HomeEvent {
  final String? categoryId;
  const HomeFilterByCategory(this.categoryId);

  @override
  List<Object?> get props => [categoryId];
}
