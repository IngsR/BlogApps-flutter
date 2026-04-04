import 'package:flutter/material.dart';

class AuthorTile extends StatelessWidget {
  final String? authorName;
  final String? authorAvatar;
  final String? subtitle;
  final VoidCallback? onFollowPressed;

  const AuthorTile({
    super.key,
    this.authorName,
    this.authorAvatar,
    this.subtitle,
    this.onFollowPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        CircleAvatar(
          radius: 24,
          backgroundImage: authorAvatar != null 
            ? NetworkImage(authorAvatar!) 
            : null,
          child: authorAvatar == null 
            ? const Icon(Icons.person, size: 24) 
            : null,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                authorName ?? 'Anonymous',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (subtitle != null)
                Text(
                  subtitle!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
            ],
          ),
        ),
        if (onFollowPressed != null)
          OutlinedButton(
            onPressed: onFollowPressed,
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
    );
  }
}
