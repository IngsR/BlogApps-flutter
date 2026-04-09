import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:blogapps/core/common/entities/blog_post.dart';
import 'package:blogapps/core/common/widgets/organisms/post_list_card.dart';
import 'package:blogapps/features/home/presentation/bloc/home_bloc.dart';
import 'package:blogapps/features/home/presentation/bloc/home_state.dart';
import 'package:blogapps/features/post_detail/presentation/pages/post_detail_page.dart';

class PostRelatedList extends StatelessWidget {
  final BlogPost currentPost;

  const PostRelatedList({super.key, required this.currentPost});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        final relatedPosts = state.latestPosts
            .where((p) => p.id != currentPost.id)
            .take(3)
            .toList();

        if (relatedPosts.isEmpty) {
          return const SliverToBoxAdapter(child: SizedBox());
        }

        return SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              final post = relatedPosts[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: PostListCard(
                  post: post,
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (_, _, _) => PostDetailPage(post: post),
                        transitionsBuilder: (_, animation, _, child) {
                          return FadeTransition(
                            opacity: animation,
                            child: child,
                          );
                        },
                        transitionDuration: const Duration(
                          milliseconds: 300,
                        ),
                      ),
                    );
                  },
                ),
              );
            }, childCount: relatedPosts.length),
          ),
        );
      },
    );
  }
}
