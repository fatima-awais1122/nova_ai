import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class ConversationTile extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const ConversationTile({super.key, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.surface,
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: const Icon(
          Icons.chat_bubble_outline,
          color: AppColors.primary,
        ),
        title: Text(title, style: const TextStyle(color: AppColors.white)),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: AppColors.grey,
        ),
        onTap: onTap,
      ),
    );
  }
}
