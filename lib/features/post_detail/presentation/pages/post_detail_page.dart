import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:blogapps/features/home/data/models/blog_post_model.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:blogapps/features/bookmarks/presentation/bloc/bookmark_bloc.dart';
import 'package:blogapps/features/home/data/models/category_model.dart';
import 'package:blogapps/features/home/presentation/bloc/home_bloc.dart';
import 'package:blogapps/features/home/presentation/widgets/post_list_card.dart';
import 'package:blogapps/features/home/presentation/bloc/home_state.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:blogapps/core/theme/app_effects.dart';

class PostDetailPage extends StatefulWidget {
  final BlogPost post;

  const PostDetailPage({super.key, required this.post});

  @override
  State<PostDetailPage> createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  final ScrollController _scrollController = ScrollController();
  double _scrollProgress = 0.0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.hasClients) {
      final progress = _scrollController.offset / _scrollController.position.maxScrollExtent;
      setState(() {
        _scrollProgress = progress.clamp(0.0, 1.0);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final readingTime = (widget.post.content.length / 500).ceil();
    final theme = Theme.of(context);

    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverAppBar(
                expandedHeight: 350,
                pinned: true,
                stretch: true,
                flexibleSpace: FlexibleSpaceBar(
                  stretchModes: const [
                    StretchMode.zoomBackground,
                    StretchMode.blurBackground,
                  ],
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      Hero(
                        tag: 'post_${widget.post.id}',
                        child: CachedNetworkImage(
                          imageUrl: widget.post.imageUrl ?? 'https://via.placeholder.com/800x400',
                          fit: BoxFit.cover,
                        ),
                      ),
                      const DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black26,
                              Colors.transparent,
                              Colors.black45,
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                actions: [
                  _CircleActionButton(
                    icon: Icons.link_rounded,
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: 'Check out this post: ${widget.post.title}\n\nRead more at: https://myblog.com/posts/${widget.post.slug}'));
                      HapticFeedback.lightImpact();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Link copied to clipboard'),
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          width: 250,
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 8),
                  _CircleActionButton(
                    icon: Icons.share_rounded,
                    onPressed: () {
                      HapticFeedback.mediumImpact();
                      Share.share(
                        'Read "${widget.post.title}" on My Blog!\n\n${widget.post.content.substring(0, 100)}...',
                      );
                    },
                  ),
                  const SizedBox(width: 8),
                  BlocBuilder<BookmarkBloc, BookmarkState>(
                    builder: (context, state) {
                      final isBookmarked = state.bookmarks.any((b) => b.id == widget.post.id);
                      return _CircleActionButton(
                        icon: isBookmarked ? Icons.bookmark_rounded : Icons.bookmark_outline_rounded,
                        iconColor: isBookmarked ? Colors.amber : null,
                        onPressed: () {
                          HapticFeedback.mediumImpact();
                          context.read<BookmarkBloc>().add(
                                ToggleBookmark(
                                  widget.post.toBookmark(),
                                ),
                              );
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(isBookmarked ? 'Removed from bookmarks' : 'Added to bookmarks'),
                              duration: const Duration(seconds: 1),
                              behavior: SnackBarBehavior.floating,
                              width: 200,
                            ),
                          );
                        },
                      );
                    },
                  ),
                  const SizedBox(width: 16),
                ],
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BlocBuilder<HomeBloc, HomeState>(
                        builder: (context, state) {
                          final category = state.categories.firstWhere(
                            (c) => c.id == widget.post.categoryId,
                            orElse: () => const Category(id: '', name: 'General', slug: 'general'),
                          );
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              category.name.toUpperCase(),
                              style: TextStyle(
                                color: theme.colorScheme.primary,
                                fontSize: 10,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 1.5,
                              ),
                            ),
                          );
                        },
                      ).animate().fadeIn(delay: 200.ms),
                      const SizedBox(height: 16),
                      GradientText(
                        widget.post.title,
                        style: theme.textTheme.displaySmall?.copyWith(
                          fontWeight: FontWeight.w800,
                          height: 1.2,
                        ),
                      ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.1),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 24,
                            backgroundImage: widget.post.authorAvatar != null 
                              ? NetworkImage(widget.post.authorAvatar!) 
                              : null,
                            child: widget.post.authorAvatar == null 
                              ? const Icon(Icons.person, size: 24) 
                              : null,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.post.authorName ?? 'Anonymous',
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '${DateFormat.yMMMMd().format(widget.post.createdAt)} • $readingTime min read',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          OutlinedButton(
                            onPressed: () {},
                            style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              side: BorderSide(color: theme.colorScheme.primary),
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                            ),
                            child: const Text('Follow'),
                          ),
                        ],
                      ).animate().fadeIn(delay: 400.ms),
                      const SizedBox(height: 24),
                      const Divider(),
                      const SizedBox(height: 24),
                      MarkdownBody(
                        data: widget.post.content,
                        selectable: true,
                        styleSheet: MarkdownStyleSheet(
                          p: theme.textTheme.bodyLarge?.copyWith(
                            height: 1.8,
                            fontSize: 18,
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.9),
                          ),
                          h1: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w800),
                          h2: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
                          code: TextStyle(
                            backgroundColor: theme.colorScheme.surfaceContainerHighest,
                            fontFamily: 'monospace',
                            fontSize: 14,
                          ),
                          codeblockDecoration: BoxDecoration(
                            color: theme.colorScheme.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: theme.colorScheme.outline.withValues(alpha: 0.1)),
                          ),
                          blockquote: TextStyle(
                            color: theme.colorScheme.primary,
                            fontStyle: FontStyle.italic,
                            fontSize: 18,
                          ),
                          blockquoteDecoration: BoxDecoration(
                            border: Border(
                              left: BorderSide(color: theme.colorScheme.primary, width: 4),
                            ),
                          ),
                        ),
                      ).animate().fadeIn(delay: 600.ms),
                      const SizedBox(height: 48),
                      Text(
                        'Related Posts',
                        style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
              BlocBuilder<HomeBloc, HomeState>(
                builder: (context, state) {
                  final relatedPosts = state.latestPosts
                      .where((p) => p.id != widget.post.id)
                      .take(3)
                      .toList();
                  
                  if (relatedPosts.isEmpty) return const SliverToBoxAdapter(child: SizedBox());

                  return SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final post = relatedPosts[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: PostListCard(
                              post: post,
                              onTap: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PostDetailPage(post: post),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                        childCount: relatedPosts.length,
                      ),
                    ),
                  );
                },
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 40)),
            ],
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: PreferredSize(
                preferredSize: const Size.fromHeight(2),
                child: LinearProgressIndicator(
                  value: _scrollProgress,
                  backgroundColor: Colors.transparent,
                  valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
                  minHeight: 3,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CircleActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final Color? iconColor;

  const _CircleActionButton({
    required this.icon,
    required this.onPressed,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      borderRadius: BorderRadius.circular(12),
      child: IconButton(
        icon: Icon(icon, color: iconColor ?? Colors.white, size: 20),
        onPressed: onPressed,
      ),
    );
  }
}
