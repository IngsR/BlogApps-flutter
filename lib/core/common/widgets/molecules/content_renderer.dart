import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

/// Widget cerdas yang mendeteksi format konten (HTML, Markdown, plain-text)
/// dan merendernya dengan tampilan yang benar: paragraf, list, heading, dll.
class ContentRenderer extends StatelessWidget {
  final String content;
  final MarkdownStyleSheet? markdownStyleSheet;
  final TextStyle? baseTextStyle;

  const ContentRenderer({
    super.key,
    required this.content,
    this.markdownStyleSheet,
    this.baseTextStyle,
  });

  /// Deteksi apakah konten adalah HTML
  static bool _isHtml(String text) {
    final trimmed = text.trimLeft();
    return trimmed.startsWith('<') &&
        (trimmed.contains('<p') ||
            trimmed.contains('<h1') ||
            trimmed.contains('<h2') ||
            trimmed.contains('<h3') ||
            trimmed.contains('<div') ||
            trimmed.contains('<ul') ||
            trimmed.contains('<ol') ||
            trimmed.contains('<br') ||
            trimmed.contains('<strong') ||
            trimmed.contains('<em'));
  }

  /// Deteksi apakah konten adalah Markdown
  static bool _isMarkdown(String text) {
    return text.contains('## ') ||
        text.contains('# ') ||
        text.contains('**') ||
        text.contains('__') ||
        text.contains('```') ||
        text.contains('> ') ||
        RegExp(r'^\d+\. ', multiLine: true).hasMatch(text) ||
        RegExp(r'^- ', multiLine: true).hasMatch(text) ||
        RegExp(r'^\* ', multiLine: true).hasMatch(text);
  }

  /// Konversi plain-text dengan \n menjadi Markdown yang valid
  static String _plainTextToMarkdown(String text) {
    // Normalkan line endings
    String result = text.replaceAll('\r\n', '\n').replaceAll('\r', '\n');

    // Hapus lebih dari 3 baris kosong berturut-turut
    result = result.replaceAll(RegExp(r'\n{4,}'), '\n\n\n');

    // Pastikan setiap paragraf dipisah oleh double newline
    // (single \n → double \n agar Markdown memperlakukan sebagai paragraf baru)
    result = result.replaceAll(RegExp(r'(?<!\n)\n(?!\n)'), '\n\n');

    return result;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final trimmedContent = content.trim();

    if (trimmedContent.isEmpty) {
      return Text(
        'Konten tidak tersedia.',
        style: baseTextStyle ?? theme.textTheme.bodyLarge,
      );
    }

    // 1. Render HTML
    if (_isHtml(trimmedContent)) {
      return _HtmlContentRenderer(
        content: trimmedContent,
        theme: theme,
        baseTextStyle: baseTextStyle,
      );
    }

    // 2. Render Markdown
    if (_isMarkdown(trimmedContent)) {
      return _MarkdownContentRenderer(
        content: trimmedContent,
        styleSheet: markdownStyleSheet,
        theme: theme,
      );
    }

    // 3. Plain text → convert ke markdown lalu render
    final asMarkdown = _plainTextToMarkdown(trimmedContent);
    return _MarkdownContentRenderer(
      content: asMarkdown,
      styleSheet: markdownStyleSheet,
      theme: theme,
    );
  }
}

// ── HTML Renderer ────────────────────────────────────────────────────────────
class _HtmlContentRenderer extends StatelessWidget {
  final String content;
  final ThemeData theme;
  final TextStyle? baseTextStyle;

  const _HtmlContentRenderer({
    required this.content,
    required this.theme,
    this.baseTextStyle,
  });

  @override
  Widget build(BuildContext context) {
    final textStyle =
        baseTextStyle ??
        theme.textTheme.bodyLarge?.copyWith(
          height: 1.8,
          fontSize: 17,
          color: theme.colorScheme.onSurface.withValues(alpha: 0.9),
        );

    return Html(
      data: content,
      style: {
        'body': Style(
          margin: Margins.zero,
          padding: HtmlPaddings.zero,
          fontFamily: textStyle?.fontFamily,
          fontSize: FontSize(textStyle?.fontSize ?? 17),
          lineHeight: LineHeight(1.8),
          color: theme.colorScheme.onSurface.withValues(alpha: 0.9),
        ),
        'p': Style(
          margin: Margins.only(bottom: 16),
          lineHeight: LineHeight(1.8),
          fontSize: FontSize(textStyle?.fontSize ?? 17),
        ),
        'h1': Style(
          color: theme.colorScheme.onSurface,
          fontWeight: FontWeight.w800,
          fontSize: FontSize(28),
          margin: Margins.symmetric(vertical: 16),
          lineHeight: LineHeight(1.3),
        ),
        'h2': Style(
          color: theme.colorScheme.onSurface,
          fontWeight: FontWeight.w700,
          fontSize: FontSize(22),
          margin: Margins.symmetric(vertical: 12),
          lineHeight: LineHeight(1.3),
        ),
        'h3': Style(
          color: theme.colorScheme.onSurface,
          fontWeight: FontWeight.w700,
          fontSize: FontSize(18),
          margin: Margins.symmetric(vertical: 10),
        ),
        'h4': Style(
          color: theme.colorScheme.onSurface,
          fontWeight: FontWeight.w600,
          fontSize: FontSize(16),
          margin: Margins.symmetric(vertical: 8),
        ),
        'strong': Style(
          fontWeight: FontWeight.w700,
          color: theme.colorScheme.onSurface,
        ),
        'em': Style(fontStyle: FontStyle.italic),
        'blockquote': Style(
          color: theme.colorScheme.primary,
          fontStyle: FontStyle.italic,
          fontSize: FontSize(17),
          margin: Margins.symmetric(vertical: 16, horizontal: 0),
          padding: HtmlPaddings.only(left: 16),
          border: Border(
            left: BorderSide(color: theme.colorScheme.primary, width: 4),
          ),
          backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.05),
        ),
        'code': Style(
          backgroundColor: theme.colorScheme.surfaceContainerHighest,
          fontFamily: 'monospace',
          fontSize: FontSize(14),
          padding: HtmlPaddings.symmetric(horizontal: 6, vertical: 2),
        ),
        'pre': Style(
          backgroundColor: theme.colorScheme.surfaceContainerHighest,
          padding: HtmlPaddings.all(16),
          margin: Margins.symmetric(vertical: 12),
        ),
        'ul': Style(
          margin: Margins.only(bottom: 16, left: 4),
          listStyleType: ListStyleType.disc,
        ),
        'ol': Style(
          margin: Margins.only(bottom: 16, left: 4),
          listStyleType: ListStyleType.decimal,
        ),
        'li': Style(
          margin: Margins.only(bottom: 6),
          lineHeight: LineHeight(1.7),
          fontSize: FontSize(textStyle?.fontSize ?? 17),
        ),
        'a': Style(
          color: theme.colorScheme.primary,
          textDecoration: TextDecoration.underline,
        ),
        'img': Style(margin: Margins.symmetric(vertical: 16)),
        'hr': Style(
          margin: Margins.symmetric(vertical: 20),
          border: Border(
            bottom: BorderSide(
              color: theme.colorScheme.outlineVariant,
              width: 1,
            ),
          ),
        ),
      },
    );
  }
}

// ── Markdown Renderer ─────────────────────────────────────────────────────────
class _MarkdownContentRenderer extends StatelessWidget {
  final String content;
  final MarkdownStyleSheet? styleSheet;
  final ThemeData theme;

  const _MarkdownContentRenderer({
    required this.content,
    required this.theme,
    this.styleSheet,
  });

  @override
  Widget build(BuildContext context) {
    final defaultStyleSheet = MarkdownStyleSheet(
      p: theme.textTheme.bodyLarge?.copyWith(
        height: 1.8,
        fontSize: 17,
        color: theme.colorScheme.onSurface.withValues(alpha: 0.9),
      ),
      h1: theme.textTheme.headlineMedium?.copyWith(
        fontWeight: FontWeight.w800,
        height: 1.3,
        color: theme.colorScheme.onSurface,
      ),
      h2: theme.textTheme.headlineSmall?.copyWith(
        fontWeight: FontWeight.w800,
        height: 1.3,
        color: theme.colorScheme.onSurface,
      ),
      h3: theme.textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.w700,
        color: theme.colorScheme.onSurface,
      ),
      h4: theme.textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.w700,
        color: theme.colorScheme.onSurface,
      ),
      strong: TextStyle(
        fontWeight: FontWeight.w700,
        color: theme.colorScheme.onSurface,
      ),
      em: const TextStyle(fontStyle: FontStyle.italic),
      code: TextStyle(
        backgroundColor: theme.colorScheme.surfaceContainerHighest,
        fontFamily: 'monospace',
        fontSize: 14,
      ),
      codeblockDecoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.15),
        ),
      ),
      codeblockPadding: const EdgeInsets.all(16),
      blockquote: TextStyle(
        color: theme.colorScheme.primary,
        fontStyle: FontStyle.italic,
        fontSize: 17,
        height: 1.7,
      ),
      blockquoteDecoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.05),
        border: Border(
          left: BorderSide(color: theme.colorScheme.primary, width: 4),
        ),
      ),
      blockquotePadding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      listBullet: theme.textTheme.bodyLarge?.copyWith(
        height: 1.8,
        fontSize: 17,
        color: theme.colorScheme.primary,
      ),
      tableHead: TextStyle(
        fontWeight: FontWeight.w700,
        color: theme.colorScheme.onSurface,
      ),
      tableBody: TextStyle(color: theme.colorScheme.onSurface),
      tableBorder: TableBorder.all(
        color: theme.colorScheme.outlineVariant,
        width: 1,
      ),
      horizontalRuleDecoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: theme.colorScheme.outlineVariant, width: 1),
        ),
      ),
      pPadding: const EdgeInsets.only(bottom: 8),
    );

    return MarkdownBody(
      data: content,
      selectable: true,
      styleSheet: styleSheet ?? defaultStyleSheet,
      softLineBreak: true,
    );
  }
}
