import 'package:blogapps/core/common/entities/blog_post.dart';
import 'package:blogapps/core/common/entities/category.dart';

abstract class HomeRepository {
  Future<List<BlogPost>> getLatestPosts({
    int offset = 0,
    int limit = 10,
    String? categoryId,
  });
  Future<List<BlogPost>> getFeaturedPosts();
  Future<List<Category>> getCategories();

  List<BlogPost> getCachedLatestPosts();
  List<BlogPost> getCachedFeaturedPosts();
  List<Category> getCachedCategories();
}
