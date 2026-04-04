import 'package:blogapps/core/common/entities/blog_post.dart';
import 'package:blogapps/features/bookmarks/data/models/bookmark_model.dart';
import 'package:blogapps/features/bookmarks/domain/repositories/bookmark_repository.dart';
import 'package:hive/hive.dart';

class BookmarkRepositoryImpl implements BookmarkRepository {
  final Box<Bookmark> bookmarkBox;

  BookmarkRepositoryImpl(this.bookmarkBox);

  @override
  Future<void> saveBookmark(BlogPost post) async {
    await bookmarkBox.put(post.id, Bookmark.fromBlogPost(post));
  }

  @override
  Future<void> removeBookmark(String id) async {
    await bookmarkBox.delete(id);
  }

  @override
  List<BlogPost> getBookmarks() {
    return bookmarkBox.values.map((b) => b.toBlogPost()).toList();
  }

  @override
  bool isBookmarked(String id) {
    return bookmarkBox.containsKey(id);
  }
}
