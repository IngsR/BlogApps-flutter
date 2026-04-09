import 'package:blogapps/core/common/entities/blog_post.dart';
import 'package:blogapps/core/common/entities/category.dart';
import 'package:blogapps/core/common/widgets/atoms/app_badge.dart';
import 'package:blogapps/core/common/widgets/atoms/app_icon_button.dart';
import 'package:blogapps/core/common/widgets/atoms/gradient_text.dart';
import 'package:blogapps/core/common/widgets/molecules/author_tile.dart';
import 'package:blogapps/core/common/widgets/molecules/content_renderer.dart';
import 'package:blogapps/core/common/widgets/organisms/post_list_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:blogapps/features/bookmarks/presentation/bloc/bookmark_bloc.dart';
import 'package:blogapps/features/home/presentation/bloc/home_bloc.dart';
import 'package:blogapps/features/home/presentation/bloc/home_event.dart';
import 'package:blogapps/features/home/presentation/bloc/home_state.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_animate/flutter_animate.dart';

class PostDetailPage extends StatefulWidget {
  final BlogPost post;

  const PostDetailPage({super.key, required this.post});

  @override
  State<PostDetailPage> createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  final ScrollController _scrollController = ScrollController();
  final ValueNotifier<double> _scrollProgress = ValueNotifier<double>(0.0);

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _scrollProgress.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final maxExtent = _scrollController.position.maxScrollExtent;
    // Guard: hindari division by zero saat konten pendek
    if (maxExtent <= 0) {
      _scrollProgress.value = 1.0;
      return;
    }
    final progress = _scrollController.offset / maxExtent;
    _scrollProgress.value = progress.clamp(0.0, 1.0);
  }

  /// Ambil preview konten yang aman (tanpa crash jika < 150 karakter)
  String _getSafeContentPreview() {
    final clean = widget.post.content
        .replaceAll(RegExp(r'<[^>]+>'), '') // strip HTML tags
        .replaceAll(RegExp(r'\s+'), ' ') // normalkan whitespace
        .trim();
    if (clean.length <= 150) return clean;
    return '${clean.substring(0, 150)}...';
  }

  void _handleShare() {
    HapticFeedback.mediumImpact();
    Share.share(
      'Baca "${widget.post.title}" di Blog Saya!\n\n${_getSafeContentPreview()}\n\nhttps://myblog.com/posts/${widget.post.slug}',
    );
  }

  void _handleCopyLink() {
    Clipboard.setData(
      ClipboardData(text: 'https://myblog.com/posts/${widget.post.slug}'),
    );
    HapticFeedback.lightImpact();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Link berhasil disalin'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        width: 220,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Stack(
        children: [
          // ── Konten Utama ──────────────────────────────────────────────────
          CustomScrollView(
            controller: _scrollController,
            physics: const BouncingScrollPhysics(),
            slivers: [
              // ── App Bar dengan Hero Image ─────────────────────────────────
              SliverAppBar(
                expandedHeight: 320,
                pinned: true,
                stretch: true,
                backgroundColor: theme.colorScheme.surface,
                leading: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.black38,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.arrow_back_rounded,
                      color: Colors.white,
                    ),
                  ),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  stretchModes: const [
                    StretchMode.zoomBackground,
                    StretchMode.blurBackground,
                  ],
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Gambar Hero – tag consistent dengan home_page.dart
                      Hero(
                        tag: 'post_${widget.post.id}',
                        child:
                            widget.post.imageUrl != null &&
                                widget.post.imageUrl!.isNotEmpty
                            ? CachedNetworkImage(
                                imageUrl: widget.post.imageUrl!,
                                fit: BoxFit.cover,
                                memCacheWidth: 1200,
                                placeholder: (context, url) => Container(
                                  color:
                                      theme.colorScheme.surfaceContainerHighest,
                                ),
                                errorWidget: (context, url, error) =>
                                    _ImageFallback(theme: theme),
                              )
                            : _ImageFallback(theme: theme),
                      ),
                      // Gradient overlay bawah
                      const DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black26,
                              Colors.transparent,
                              Colors.black54,
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                actions: [
                  AppIconButton(
                    icon: Icons.link_rounded,
                    onPressed: _handleCopyLink,
                  ),
                  const SizedBox(width: 8),
                  AppIconButton(
                    icon: Icons.share_rounded,
                    onPressed: _handleShare,
                  ),
                  const SizedBox(width: 8),
                  // ── Tombol Bookmark ──────────────────────────────────────
                  BlocBuilder<BookmarkBloc, BookmarkState>(
                    builder: (context, state) {
                      final isBookmarked = state.bookmarks.any(
                        (b) => b.id == widget.post.id,
                      );
                      return AppIconButton(
                        icon: isBookmarked
                            ? Icons.bookmark_rounded
                            : Icons.bookmark_outline_rounded,
                        iconColor: isBookmarked ? Colors.amber : null,
                        onPressed: () {
                          HapticFeedback.mediumImpact();
                          context.read<BookmarkBloc>().add(
                            ToggleBookmark(widget.post),
                          );
                          if (!mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                isBookmarked
                                    ? 'Dihapus dari bookmark'
                                    : 'Ditambahkan ke bookmark',
                              ),
                              duration: const Duration(seconds: 2),
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              width: 240,
                            ),
                          );
                        },
                      );
                    },
                  ),
                  const SizedBox(width: 16),
                ],
              ),

              // ── Konten Artikel ────────────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 24,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Kategori
                      BlocBuilder<HomeBloc, HomeState>(
                        builder: (context, state) {
                          final category = state.categories.firstWhere(
                            (c) => c.id == widget.post.categoryId,
                            orElse: () => const Category(
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
                        widget.post.title,
                        style: theme.textTheme.displaySmall?.copyWith(
                          fontWeight: FontWeight.w800,
                          height: 1.25,
                        ),
                      ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.1),

                      const SizedBox(height: 20),

                      // Info Penulis
                      AuthorTile(
                        authorName: widget.post.authorName,
                        authorAvatar: widget.post.authorAvatar,
                        subtitle:
                            '${DateFormat.yMMMMd('id').format(widget.post.createdAt)} • ${widget.post.readingTime} menit baca',
                        onFollowPressed: () {},
                      ).animate().fadeIn(delay: 400.ms),

                      const SizedBox(height: 24),
                      Divider(
                        color: theme.colorScheme.outlineVariant,
                        thickness: 1,
                      ),
                      const SizedBox(height: 24),

                      // ── Konten Blog (HTML/Markdown/Plain-text) ─────────────
                      ContentRenderer(
                        content: widget.post.content,
                      ).animate().fadeIn(delay: 500.ms),

                      const SizedBox(height: 48),

                      // Divider sebelum Related Posts
                      Divider(
                        color: theme.colorScheme.outlineVariant,
                        thickness: 1,
                      ),
                      const SizedBox(height: 24),

                      Text(
                        'Artikel Terkait',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),

              // ── Related Posts ─────────────────────────────────────────────
              BlocBuilder<HomeBloc, HomeState>(
                builder: (context, state) {
                  final relatedPosts = state.latestPosts
                      .where((p) => p.id != widget.post.id)
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
                                  pageBuilder: (_, _, _) =>
                                      PostDetailPage(post: post),
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
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 60)),
            ],
          ),

          // ── Reading Progress Bar ──────────────────────────────────────────
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: SizedBox(
                height: 3,
                child: ValueListenableBuilder<double>(
                  valueListenable: _scrollProgress,
                  builder: (context, value, _) {
                    return LinearProgressIndicator(
                      value: value,
                      backgroundColor: Colors.transparent,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        theme.colorScheme.primary,
                      ),
                      minHeight: 3,
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Image Fallback ────────────────────────────────────────────────────────────
class _ImageFallback extends StatelessWidget {
  final ThemeData theme;

  const _ImageFallback({required this.theme});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: theme.colorScheme.surfaceContainerHighest,
      child: Center(
        child: Icon(
          Icons.article_outlined,
          size: 64,
          color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
        ),
      ),
    );
  }
}
