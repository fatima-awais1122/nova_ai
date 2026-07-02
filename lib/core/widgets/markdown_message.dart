import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '../theme/app_colors.dart';
import 'code_block.dart';

class MarkdownMessage extends StatelessWidget {
  final String text;

  const MarkdownMessage({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    final RegExp codeRegex = RegExp(
      r'```(\w+)?\n([\s\S]*?)```',
      multiLine: true,
    );

    final match = codeRegex.firstMatch(text);

    // ============================
    // No Code Block
    // ============================

    if (match == null) {
      return MarkdownBody(
        selectable: true,

        data: text,

        styleSheet: MarkdownStyleSheet(
          p: const TextStyle(color: Colors.white, fontSize: 15, height: 1.5),

          h1: const TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),

          h2: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),

          h3: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),

          strong: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),

          em: const TextStyle(
            color: Colors.white70,
            fontStyle: FontStyle.italic,
          ),

          blockquoteDecoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(8),
          ),

          code: const TextStyle(
            color: Colors.greenAccent,
            fontFamily: "monospace",
          ),

          codeblockDecoration: BoxDecoration(
            color: Colors.black54,
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }

    // ============================
    // Code Block Found
    // ============================

    final language = match.group(1) ?? "";

    final code = match.group(2) ?? "";

    final before = text.substring(0, match.start);

    final after = text.substring(match.end);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (before.trim().isNotEmpty)
          MarkdownBody(
            selectable: true,

            data: before,

            styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context))
                .copyWith(
                  p: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    height: 1.5,
                  ),
                ),
          ),

        CodeBlock(language: language, code: code),

        if (after.trim().isNotEmpty)
          MarkdownBody(
            selectable: true,

            data: after,

            styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context))
                .copyWith(
                  p: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    height: 1.5,
                  ),
                ),
          ),
      ],
    );
  }
}
