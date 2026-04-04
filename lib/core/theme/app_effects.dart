import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:blogapps/core/theme/app_theme.dart';

class GlassCard extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;
  final Border? border;

  final Color? color;

  const GlassCard({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.padding,
    this.borderRadius,
    this.border,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final effects = Theme.of(context).extension<AppEffects>()!;
    final radius = borderRadius ?? BorderRadius.circular(24);

    return ClipRRect(
      borderRadius: radius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: effects.glassBlur, sigmaY: effects.glassBlur),
        child: Container(
          width: width,
          height: height,
          padding: padding,
          decoration: BoxDecoration(
            color: color ?? effects.glassColor,
            borderRadius: radius,
            border: border ?? Border.all(color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.1)),
          ),
          child: child,
        ),
      ),
    );
  }
}

class AnimatedHeroBackground extends StatelessWidget {
  final Widget child;

  const AnimatedHeroBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final effects = Theme.of(context).extension<AppEffects>()!;

    return Container(
      decoration: BoxDecoration(
        gradient: effects.heroGradient,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.8),
        ),
        child: child,
      ),
    );
  }
}
