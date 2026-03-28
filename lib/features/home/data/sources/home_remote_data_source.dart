import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:blogapps/features/home/data/models/blog_post_model.dart';
import 'package:blogapps/features/home/data/models/category_model.dart';
import 'package:blogapps/core/constants/app_constants.dart';

abstract class HomeRemoteDataSource {
  Future<List<BlogPost>> getLatestPosts({
    int offset = 0, 
    int limit = 10,
    String? categoryId,
  });
  Future<List<BlogPost>> getFeaturedPosts();
  Future<List<Category>> getCategories();
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final SupabaseClient client;

  HomeRemoteDataSourceImpl(this.client);

  @override
  Future<List<BlogPost>> getLatestPosts({
    int offset = 0, 
    int limit = 10,
    String? categoryId,
  }) async {
    var query = client
        .from(AppConstants.postsTable)
        .select('*, profiles(name, avatar_url)');

    if (categoryId != null) {
      query = query.eq('category_id', categoryId);
    }
    
    final response = await query.order('created_at', ascending: false).range(offset, offset + limit - 1);
    
    return (response as List).map((json) => BlogPost.fromJson(json)).toList();
  }

  @override
  Future<List<BlogPost>> getFeaturedPosts() async {
    final response = await client
        .from(AppConstants.postsTable)
        .select('*, profiles(name, avatar_url)')
        .eq('is_featured', true)
        .order('created_at', ascending: false)
        .limit(5);
    
    return (response as List).map((json) => BlogPost.fromJson(json)).toList();
  }

  @override
  Future<List<Category>> getCategories() async {
    final response = await client
        .from(AppConstants.categoriesTable)
        .select('*')
        .order('name');
    
    return (response as List).map((json) => Category.fromJson(json)).toList();
  }
}
