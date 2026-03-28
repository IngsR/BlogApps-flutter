import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:blogapps/features/bookmarks/data/models/bookmark_model.dart';
import 'package:blogapps/features/bookmarks/domain/repositories/bookmark_repository.dart';

abstract class BookmarkEvent extends Equatable {
  const BookmarkEvent();
  @override
  List<Object?> get props => [];
}

class LoadBookmarks extends BookmarkEvent {}

class ToggleBookmark extends BookmarkEvent {
  final Bookmark bookmark;
  const ToggleBookmark(this.bookmark);
  @override
  List<Object?> get props => [bookmark];
}

class BookmarkState extends Equatable {
  final List<Bookmark> bookmarks;
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
      if (repository.isBookmarked(event.bookmark.id)) {
        await repository.removeBookmark(event.bookmark.id);
      } else {
        await repository.saveBookmark(event.bookmark);
      }
      emit(BookmarkState(bookmarks: repository.getBookmarks()));
    });
  }
}
