import 'package:blogapps/core/common/entities/blog_post.dart';
import 'package:blogapps/core/common/entities/category.dart';
import 'package:blogapps/features/home/data/sources/home_remote_data_source.dart';
import 'package:blogapps/features/home/data/sources/home_local_data_source.dart';
import 'package:blogapps/features/home/domain/repositories/home_repository.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource remoteDataSource;
  final HomeLocalDataSource localDataSource;

  HomeRepositoryImpl(this.remoteDataSource, this.localDataSource);

  @override
  Future<List<BlogPost>> getLatestPosts({
    int offset = 0, 
    int limit = 10,
    String? categoryId,
  }) async {
    final posts = await remoteDataSource.getLatestPosts(
      offset: offset, 
      limit: limit,
      categoryId: categoryId,
    );

    // Cache initial posts
    if (offset == 0 && categoryId == null) {
      await localDataSource.cacheLatestPosts(posts);
    }

    return posts;
  }

  @override
  Future<List<BlogPost>> getFeaturedPosts() async {
    final featured = await remoteDataSource.getFeaturedPosts();
    await localDataSource.cacheFeaturedPosts(featured);
    return featured;
  }

  @override
  Future<List<Category>> getCategories() async {
    final categories = await remoteDataSource.getCategories();
    await localDataSource.cacheCategories(categories);
    return categories;
  }

  @override
  List<BlogPost> getCachedLatestPosts() {
    return localDataSource.getCachedLatestPosts();
  }

  @override
  List<BlogPost> getCachedFeaturedPosts() {
    return localDataSource.getCachedFeaturedPosts();
  }

  @override
  List<Category> getCachedCategories() {
    return localDataSource.getCachedCategories();
  }
}
