import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class ConversationTile extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final VoidCallback onRename;
  final VoidCallback onDelete;

  const ConversationTile({
    super.key,
    required this.title,
    required this.onTap,
    required this.onRename,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.surface,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        onTap: onTap,

        leading: const CircleAvatar(
          backgroundColor: AppColors.primary,
          child: Icon(Icons.chat_bubble_outline, color: Colors.white),
        ),

        title: Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),

        trailing: PopupMenuButton<String>(
          color: AppColors.surface,
          onSelected: (value) {
            if (value == "rename") {
              onRename();
            }

            if (value == "delete") {
              onDelete();
            }
          },
          itemBuilder: (_) => const [
            PopupMenuItem(
              value: "rename",
              child: Row(
                children: [
                  Icon(Icons.edit),
                  SizedBox(width: 10),
                  Text("Rename"),
                ],
              ),
            ),
            PopupMenuItem(
              value: "delete",
              child: Row(
                children: [
                  Icon(Icons.delete, color: Colors.red),
                  SizedBox(width: 10),
                  Text("Delete", style: TextStyle(color: Colors.red)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
