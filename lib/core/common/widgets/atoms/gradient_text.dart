import 'package:flutter/material.dart';
import 'package:blogapps/core/theme/app_theme.dart';

class GradientText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final Gradient? gradient;

  const GradientText(this.text, {super.key, this.style, this.gradient});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appEffects = theme.extension<AppEffects>();
    final defaultGradient = appEffects?.textGradient ??
        LinearGradient(
          colors: [theme.colorScheme.primary, theme.colorScheme.primary],
        );

    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) => (gradient ?? defaultGradient).createShader(
        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
      ),
      child: Text(text, style: style),
    );
  }
}
