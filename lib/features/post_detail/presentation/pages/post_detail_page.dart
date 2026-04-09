import 'package:blogapps/features/post_detail/presentation/widgets/post_detail_app_bar.dart';
import 'package:blogapps/features/post_detail/presentation/widgets/post_detail_header.dart';
import 'package:blogapps/features/post_detail/presentation/widgets/post_related_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:blogapps/core/common/entities/blog_post.dart';
import 'package:blogapps/core/common/widgets/molecules/content_renderer.dart';

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
              PostDetailAppBar(post: widget.post),

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
                      PostDetailHeader(post: widget.post),

                      // ── Konten Blog (HTML/Markdown/Plain-text) ─────────────
                      ContentRenderer(content: widget.post.content)
                          .animate()
                          .fadeIn(delay: 500.ms),

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
              PostRelatedList(currentPost: widget.post),

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
