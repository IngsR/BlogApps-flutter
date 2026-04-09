import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:blogapps/core/common/entities/blog_post.dart';
import 'package:blogapps/features/home/data/models/blog_post_model.dart';
import 'package:blogapps/core/constants/app_constants.dart';
import 'package:blogapps/features/search/domain/repositories/search_repository.dart';

class SearchRepositoryImpl implements SearchRepository {
  final SupabaseClient client;

  SearchRepositoryImpl(this.client);

  @override
  Future<List<BlogPost>> searchPosts(String query) async {
    final response = await client
        .from(AppConstants.postsTable)
        .select('*, profiles(name, avatar_url)')
        .or('title.ilike.%$query%,content.ilike.%$query%')
        .order('created_at', ascending: false)
        .limit(20);

    return (response as List)
        .map((json) => BlogPostModel.fromJson(json))
        .toList();
  }
}
