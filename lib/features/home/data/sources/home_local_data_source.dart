import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:blogapps/features/home/data/models/blog_post_model.dart';
import 'package:blogapps/features/home/data/models/category_model.dart';

abstract class HomeLocalDataSource {
  Future<List<BlogPost>> getLatestPosts({
    int offset = 0, 
    int limit = 10,
    String? categoryId,
  });
  Future<List<BlogPost>> getFeaturedPosts();
  Future<List<Category>> getCategories();
}

class HomeLocalDataSourceImpl implements HomeLocalDataSource {
  final String jsonPath = 'assets/data/blogs.json';

  @override
  Future<List<BlogPost>> getLatestPosts({
    int offset = 0, 
    int limit = 10,
    String? categoryId,
  }) async {
    final String response = await rootBundle.loadString(jsonPath);
    final data = await json.decode(response);
    final List postsJson = data['posts'];
    
    var posts = postsJson
        .map((post) => BlogPost.fromJson(post))
        .toList();

    // Filter by category if provided
    if (categoryId != null) {
      posts = posts.where((p) => p.categoryId == categoryId).toList();
    }
        
    // Apply limit and offset locally
    final end = (offset + limit) > posts.length ? posts.length : (offset + limit);
    if (offset >= posts.length) return [];
    
    return posts.sublist(offset, end);
  }

  @override
  Future<List<BlogPost>> getFeaturedPosts() async {
    final String response = await rootBundle.loadString(jsonPath);
    final data = await json.decode(response);
    final List postsJson = data['posts'];
    
    return postsJson
        .where((post) => post['is_featured'] == true)
        .map((post) => BlogPost.fromJson(post))
        .toList();
  }

  @override
  Future<List<Category>> getCategories() async {
    final String response = await rootBundle.loadString(jsonPath);
    final data = await json.decode(response);
    final List categoriesJson = data['categories'];
    
    return categoriesJson
        .map((category) => Category.fromJson(category))
        .toList();
  }
}
