import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:blogapps/core/theme/app_effects.dart';
import 'package:blogapps/features/search/presentation/bloc/search_bloc.dart';
import 'package:blogapps/features/home/presentation/widgets/post_list_card.dart';
import 'package:blogapps/features/post_detail/presentation/pages/post_detail_page.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: GlassCard(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          borderRadius: BorderRadius.circular(16),
          child: TextField(
            autofocus: true,
            style: const TextStyle(fontSize: 16),
            decoration: const InputDecoration(
              hintText: 'Search posts...',
              border: InputBorder.none,
              icon: Icon(Icons.search_rounded, size: 20),
            ),
            onChanged: (query) {
              context.read<SearchBloc>().add(SearchQueryChanged(query));
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
            return Center(child: Text(state.errorMessage ?? 'Error searching posts'));
          }
          if (state.results.isEmpty && state.status == SearchStatus.success) {
            return const Center(child: Text('No posts found.'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: state.results.length,
            itemBuilder: (context, index) {
              final post = state.results[index];
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
