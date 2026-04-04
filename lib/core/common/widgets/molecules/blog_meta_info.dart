import 'package:flutter/material.dart';

class BlogMetaInfo extends StatelessWidget {
  final String date;
  final int readingTime;
  final Color? color;

  const BlogMetaInfo({
    super.key,
    required this.date,
    required this.readingTime,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textStyle = theme.textTheme.bodySmall?.copyWith(
      color: color ?? theme.colorScheme.onSurfaceVariant,
    );

    return Row(
      children: [
        Icon(
          Icons.calendar_today_outlined,
          size: 12,
          color: color ?? theme.colorScheme.onSurfaceVariant,
        ),
        const SizedBox(width: 4),
        Text(date, style: textStyle),
        const SizedBox(width: 12),
        Icon(
          Icons.access_time_rounded,
          size: 12,
          color: color ?? theme.colorScheme.onSurfaceVariant,
        ),
        const SizedBox(width: 4),
        Text('$readingTime min read', style: textStyle),
      ],
    );
  }
}
