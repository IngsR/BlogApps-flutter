import 'package:blogapps/core/common/entities/blog_post.dart';
import 'package:blogapps/features/bookmarks/domain/repositories/bookmark_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class BookmarkEvent extends Equatable {
  const BookmarkEvent();
  @override
  List<Object?> get props => [];
}

class LoadBookmarks extends BookmarkEvent {}

class ToggleBookmark extends BookmarkEvent {
  final BlogPost post;
  const ToggleBookmark(this.post);
  @override
  List<Object?> get props => [post];
}

class BookmarkState extends Equatable {
  final List<BlogPost> bookmarks;
  const BookmarkState({this.bookmarks = const []});
  @override
  List<Object?> get props => [bookmarks];
}

class BookmarkBloc extends Bloc<BookmarkEvent, BookmarkState> {
  final BookmarkRepository repository;

  BookmarkBloc(this.repository) : super(const BookmarkState()) {
    on<LoadBookmarks>((event, emit) {
      emit(BookmarkState(bookmarks: repository.getBookmarks()));
    });

    on<ToggleBookmark>((event, emit) async {
      if (repository.isBookmarked(event.post.id)) {
        await repository.removeBookmark(event.post.id);
      } else {
        await repository.saveBookmark(event.post);
      }
      emit(BookmarkState(bookmarks: repository.getBookmarks()));
    });
  }
}
