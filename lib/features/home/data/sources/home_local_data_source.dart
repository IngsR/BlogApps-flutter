import 'package:hive/hive.dart';
import 'package:blogapps/features/home/data/models/blog_post_model.dart';
import 'package:blogapps/features/home/data/models/category_model.dart';

abstract class HomeLocalDataSource {
  Future<void> cacheLatestPosts(List<BlogPostModel> posts);
  List<BlogPostModel> getCachedLatestPosts();
  Future<void> cacheFeaturedPosts(List<BlogPostModel> posts);
  List<BlogPostModel> getCachedFeaturedPosts();
  Future<void> cacheCategories(List<CategoryModel> categories);
  List<CategoryModel> getCachedCategories();
}

class HomeLocalDataSourceImpl implements HomeLocalDataSource {
  final Box<BlogPostModel> latestPostsBox;
  final Box<BlogPostModel> featuredPostsBox;
  final Box<CategoryModel> categoriesBox;

  HomeLocalDataSourceImpl({
    required this.latestPostsBox,
    required this.featuredPostsBox,
    required this.categoriesBox,
  });

  @override
  Future<void> cacheLatestPosts(List<BlogPostModel> posts) async {
    await latestPostsBox.clear();
    await latestPostsBox.addAll(posts);
  }

  @override
  List<BlogPostModel> getCachedLatestPosts() {
    return latestPostsBox.values.toList();
  }

  @override
  Future<void> cacheFeaturedPosts(List<BlogPostModel> posts) async {
    await featuredPostsBox.clear();
    await featuredPostsBox.addAll(posts);
  }

  @override
  List<BlogPostModel> getCachedFeaturedPosts() {
    return featuredPostsBox.values.toList();
  }

  @override
  Future<void> cacheCategories(List<CategoryModel> categories) async {
    await categoriesBox.clear();
    await categoriesBox.addAll(categories);
  }

  @override
  List<CategoryModel> getCachedCategories() {
    return categoriesBox.values.toList();
  }
}
