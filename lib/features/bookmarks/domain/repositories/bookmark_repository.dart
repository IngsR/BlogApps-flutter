import 'package:blogapps/core/common/entities/blog_post.dart';

abstract class BookmarkRepository {
  Future<void> saveBookmark(BlogPost post);
  Future<void> removeBookmark(String id);
  List<BlogPost> getBookmarks();
  bool isBookmarked(String id);
}
