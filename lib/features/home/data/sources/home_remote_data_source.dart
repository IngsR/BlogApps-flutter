import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart' hide Category;
import 'package:blogapps/features/home/data/models/blog_post_model.dart';
import 'package:blogapps/features/home/data/models/category_model.dart';
import 'package:blogapps/core/constants/app_constants.dart';

abstract class HomeRemoteDataSource {
  Future<List<BlogPostModel>> getLatestPosts({
    int offset = 0, 
    int limit = 10,
    String? categoryId,
  });
  Future<List<BlogPostModel>> getFeaturedPosts();
  Future<List<CategoryModel>> getCategories();
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final SupabaseClient client;

  HomeRemoteDataSourceImpl(this.client);

  @override
  Future<List<BlogPostModel>> getLatestPosts({
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
    
    return compute(_parsePosts, response as List<dynamic>);
  }

  @override
  Future<List<BlogPostModel>> getFeaturedPosts() async {
    final response = await client
        .from(AppConstants.postsTable)
        .select('*, profiles(name, avatar_url)')
        .eq('is_featured', true)
        .order('created_at', ascending: false)
        .limit(5);
    
    return compute(_parsePosts, response as List<dynamic>);
  }

  @override
  Future<List<CategoryModel>> getCategories() async {
    final response = await client
        .from(AppConstants.categoriesTable)
        .select('*')
        .order('name');
    
    return (response as List).map((json) => CategoryModel.fromJson(json)).toList();
  }

  static List<BlogPostModel> _parsePosts(List<dynamic> jsonList) {
    return jsonList.map((json) => BlogPostModel.fromJson(json as Map<String, dynamic>)).toList();
  }
}
