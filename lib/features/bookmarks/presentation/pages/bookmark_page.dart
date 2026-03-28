import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:blogapps/features/bookmarks/presentation/bloc/bookmark_bloc.dart';
import 'package:blogapps/features/home/presentation/widgets/post_list_card.dart';
import 'package:blogapps/features/post_detail/presentation/pages/post_detail_page.dart';

class BookmarkPage extends StatelessWidget {
  const BookmarkPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved Stories'),
        centerTitle: false,
      ),
      body: BlocBuilder<BookmarkBloc, BookmarkState>(
        builder: (context, state) {
          if (state.bookmarks.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.bookmark_border_rounded,
                    size: 64,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.1),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No bookmarks yet',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Stories you save will appear here.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            physics: const BouncingScrollPhysics(),
            itemCount: state.bookmarks.length,
            itemBuilder: (context, index) {
              final bookmark = state.bookmarks[index];
              final post = bookmark.toBlogPost();

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
              );
            },
          );
        },
      ),
    );
  }
}
