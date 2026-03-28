import 'package:blogapps/features/home/data/models/blog_post_model.dart';
import 'package:blogapps/features/home/data/models/category_model.dart';
import 'package:blogapps/features/home/data/sources/home_remote_data_source.dart';

abstract class HomeRepository {
  Future<List<BlogPost>> getLatestPosts({
    int offset = 0, 
    int limit = 10,
    String? categoryId,
  });
  Future<List<BlogPost>> getFeaturedPosts();
  Future<List<Category>> getCategories();
}

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource remoteDataSource;

  HomeRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<BlogPost>> getLatestPosts({
    int offset = 0, 
    int limit = 10,
    String? categoryId,
  }) {
    return remoteDataSource.getLatestPosts(
      offset: offset, 
      limit: limit,
      categoryId: categoryId,
    );
  }

  @override
  Future<List<BlogPost>> getFeaturedPosts() {
    return remoteDataSource.getFeaturedPosts();
  }

  @override
  Future<List<Category>> getCategories() {
    return remoteDataSource.getCategories();
  }
}
