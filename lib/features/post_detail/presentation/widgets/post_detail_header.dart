import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:blogapps/core/common/entities/blog_post.dart';
import 'package:blogapps/core/common/widgets/atoms/app_badge.dart';
import 'package:blogapps/core/common/widgets/atoms/gradient_text.dart';
import 'package:blogapps/core/common/widgets/molecules/author_tile.dart';
import 'package:blogapps/features/home/data/models/category_model.dart';
import 'package:blogapps/features/home/presentation/bloc/home_bloc.dart';
import 'package:blogapps/features/home/presentation/bloc/home_event.dart';
import 'package:blogapps/features/home/presentation/bloc/home_state.dart';

class PostDetailHeader extends StatelessWidget {
  final BlogPost post;

  const PostDetailHeader({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Kategori
        BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            final category = state.categories.firstWhere(
              (c) => c.id == post.categoryId,
              orElse: () => const CategoryModel(
                id: '',
                name: 'General',
                slug: 'general',
              ),
            );
            return AppBadge(
              label: category.name,
              onTap: () {
                context.read<HomeBloc>().add(
                  HomeFilterByCategory(category.id),
                );
                Navigator.pop(context);
              },
            );
          },
        ).animate().fadeIn(delay: 200.ms),

        const SizedBox(height: 16),

        // Judul
        GradientText(
          post.title,
          style: theme.textTheme.displaySmall?.copyWith(
            fontWeight: FontWeight.w800,
            height: 1.25,
          ),
        ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.1),

        const SizedBox(height: 20),

        // Info Penulis
        AuthorTile(
          authorName: post.authorName,
          authorAvatar: post.authorAvatar,
          subtitle:
              '${DateFormat.yMMMMd('id').format(post.createdAt)} • ${post.readingTime} menit baca',
          onFollowPressed: () {},
        ).animate().fadeIn(delay: 400.ms),

        const SizedBox(height: 24),
        Divider(
          color: theme.colorScheme.outlineVariant,
          thickness: 1,
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
