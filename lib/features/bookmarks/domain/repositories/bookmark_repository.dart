import 'package:hive/hive.dart';
import 'package:blogapps/features/bookmarks/data/models/bookmark_model.dart';

abstract class BookmarkRepository {
  Future<void> saveBookmark(Bookmark bookmark);
  Future<void> removeBookmark(String id);
  List<Bookmark> getBookmarks();
  bool isBookmarked(String id);
}

class BookmarkRepositoryImpl implements BookmarkRepository {
  final Box<Bookmark> bookmarkBox;

  BookmarkRepositoryImpl(this.bookmarkBox);

  @override
  Future<void> saveBookmark(Bookmark bookmark) async {
    await bookmarkBox.put(bookmark.id, bookmark);
  }

  @override
  Future<void> removeBookmark(String id) async {
    await bookmarkBox.delete(id);
  }

  @override
  List<Bookmark> getBookmarks() {
    return bookmarkBox.values.toList();
  }

  @override
  bool isBookmarked(String id) {
    return bookmarkBox.containsKey(id);
  }
}
