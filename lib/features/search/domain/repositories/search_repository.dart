import 'package:blogapps/core/common/entities/blog_post.dart';

abstract class SearchRepository {
  Future<List<BlogPost>> searchPosts(String query);
}
