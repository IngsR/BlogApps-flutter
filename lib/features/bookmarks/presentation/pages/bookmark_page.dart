import 'package:blogapps/core/common/widgets/atoms/gradient_text.dart';
import 'package:blogapps/core/common/widgets/organisms/post_list_card.dart';
import 'package:blogapps/features/post_detail/presentation/pages/post_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:blogapps/features/bookmarks/presentation/bloc/bookmark_bloc.dart';

class BookmarkPage extends StatelessWidget {
  const BookmarkPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const GradientText(
          'Saved Stories',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ).animate().fadeIn(duration: 600.ms).slideX(begin: -0.2),
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
                        size: 80,
                        color: theme.colorScheme.primary.withValues(alpha: 0.1),
                      )
                      .animate(
                        onPlay: (controller) =>
                            controller.repeat(reverse: true),
                      )
                      .moveY(
                        begin: -10,
                        end: 10,
                        duration: 2.seconds,
                        curve: Curves.easeInOut,
                      ),
                  const SizedBox(height: 24),
                  Text(
                    'No bookmarks yet',
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: theme.colorScheme.onSurface,
                      fontWeight: FontWeight.w800,
                    ),
                  ).animate().fadeIn(delay: 200.ms),
                  const SizedBox(height: 12),
                  Text(
                    'Stories you save will appear here.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ).animate().fadeIn(delay: 400.ms),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            physics: const BouncingScrollPhysics(),
            itemCount: state.bookmarks.length,
            itemBuilder: (context, index) {
              final post = state.bookmarks[index];

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
                  )
                  .animate()
                  .fadeIn(delay: (200 + (index * 50)).ms)
                  .slideX(begin: 0.1);
            },
          );
        },
      ),
    );
  }
}
