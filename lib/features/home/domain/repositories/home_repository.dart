import 'package:blogapps/features/home/data/models/blog_post_model.dart';
import 'package:blogapps/features/home/data/models/category_model.dart';
import 'package:blogapps/features/home/data/sources/home_local_data_source.dart';

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
  final HomeLocalDataSource localDataSource;

  HomeRepositoryImpl(this.localDataSource);

  @override
  Future<List<BlogPost>> getLatestPosts({
    int offset = 0, 
    int limit = 10,
    String? categoryId,
  }) {
    return localDataSource.getLatestPosts(
      offset: offset, 
      limit: limit,
      categoryId: categoryId,
    );
  }

  @override
  Future<List<BlogPost>> getFeaturedPosts() {
    return localDataSource.getFeaturedPosts();
  }

  @override
  Future<List<Category>> getCategories() {
    return localDataSource.getCategories();
  }
}
