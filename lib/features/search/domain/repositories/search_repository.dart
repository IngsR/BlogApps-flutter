import 'package:blogapps/features/home/data/models/blog_post_model.dart';
import 'package:blogapps/features/home/data/sources/home_local_data_source.dart';

abstract class SearchRepository {
  Future<List<BlogPost>> searchPosts(String query);
}

class SearchRepositoryImpl implements SearchRepository {
  final HomeLocalDataSource localDataSource;

  SearchRepositoryImpl(this.localDataSource);

  @override
  Future<List<BlogPost>> searchPosts(String query) async {
    final posts = await localDataSource.getLatestPosts(limit: 100);
    return posts.where((post) {
      final q = query.toLowerCase();
      return post.title.toLowerCase().contains(q) || 
             post.content.toLowerCase().contains(q);
    }).toList();
  }
}
