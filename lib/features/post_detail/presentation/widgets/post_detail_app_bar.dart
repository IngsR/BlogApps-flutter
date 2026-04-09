import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:share_plus/share_plus.dart';

import 'package:blogapps/core/common/entities/blog_post.dart';
import 'package:blogapps/core/common/widgets/atoms/app_icon_button.dart';
import 'package:blogapps/features/bookmarks/presentation/bloc/bookmark_bloc.dart';

class PostDetailAppBar extends StatefulWidget {
  final BlogPost post;

  const PostDetailAppBar({super.key, required this.post});

  @override
  State<PostDetailAppBar> createState() => _PostDetailAppBarState();
}

class _PostDetailAppBarState extends State<PostDetailAppBar> {
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

    return SliverAppBar(
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
          child: const Icon(Icons.arrow_back_rounded, color: Colors.white),
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
                            color: theme.colorScheme.surfaceContainerHighest,
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
