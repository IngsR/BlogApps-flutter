import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:blogapps/features/home/data/models/blog_post_model.dart';

class FeaturedPostCard extends StatelessWidget {
  final BlogPost post;
  final VoidCallback onTap;

  const FeaturedPostCard({
    super.key,
    required this.post,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: 320,
      margin: const EdgeInsets.only(right: 16),
      child: GestureDetector(
        onTap: onTap,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Image with Hero
            ClipRRect(
              borderRadius: BorderRadius.circular(32),
              child: Hero(
                tag: 'post_${post.id}',
                child: CachedNetworkImage(
                  imageUrl: post.imageUrl ?? 'https://via.placeholder.com/800x600',
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(color: theme.colorScheme.surfaceContainerHighest),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
            ),
            
            // Gradient Overlay
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(32),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.1),
                    Colors.black.withValues(alpha: 0.8),
                  ],
                  stops: const [0.0, 0.4, 1.0],
                ),
              ),
            ),
            
            // Content
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'Featured',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    post.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 14,
                        backgroundImage: post.authorAvatar != null 
                            ? NetworkImage(post.authorAvatar!) 
                            : null,
                        child: post.authorAvatar == null 
                            ? const Icon(Icons.person, size: 14) 
                            : null,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        post.authorName ?? 'Anonymous',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
