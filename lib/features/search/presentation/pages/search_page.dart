import 'package:blogapps/core/common/widgets/organisms/post_list_card.dart';
import 'package:blogapps/features/search/presentation/bloc/search_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:blogapps/core/theme/app_effects.dart';
import 'package:blogapps/features/post_detail/presentation/pages/post_detail_page.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: GlassCard(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          borderRadius: BorderRadius.circular(20),
          child: TextField(
            autofocus: true,
            style: const TextStyle(fontSize: 16),
            decoration: const InputDecoration(
              hintText: 'Search posts...',
              border: InputBorder.none,
              icon: Icon(Icons.search_rounded, size: 20),
            ),
            onChanged: (query) {
              context.read<SearchBloc>().add(SearchPosts(query));
            },
          ),
        ).animate().fadeIn(duration: 400.ms).slideY(begin: -0.2),
      ),
      body: BlocBuilder<SearchBloc, SearchState>(
        builder: (context, state) {
          if (state.status == SearchStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.status == SearchStatus.failure) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Text(
                  state.errorMessage ?? 'Error searching posts',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: theme.colorScheme.error),
                ),
              ),
            );
          }
          if (state.posts.isEmpty && state.status == SearchStatus.success) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.search_off_rounded, size: 64, color: theme.colorScheme.primary.withValues(alpha: 0.3)),
                  const SizedBox(height: 16),
                  const Text('No posts found.', style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(20),
            physics: const BouncingScrollPhysics(),
            itemCount: state.posts.length,
            itemBuilder: (context, index) {
              final post = state.posts[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: PostListCard(
                  post: post,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PostDetailPage(post: post),
                      ),
                    );
                  },
                ),
              ).animate().fadeIn(delay: (index * 50).ms).slideX(begin: 0.1);
            },
          );
        },
      ),
    );
  }
}
