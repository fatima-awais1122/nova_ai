import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../chat/screens/chat_screen.dart';
import '../services/conversation_service.dart';
import '../models/conversation_model.dart';
import '../widgets/conversation_tile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ConversationService _service = ConversationService();

  List<ConversationModel> conversations = [];

  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadConversations();
  }

  Future<void> loadConversations() async {
    try {
      final response = await _service.getConversations();

      conversations = response
          .map((e) => ConversationModel.fromJson(e))
          .toList();

      setState(() {
        loading = false;
      });
    } catch (e) {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(title: const Text("Nova AI")),

      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ChatScreen()),
          );

          loadConversations();
        },
        icon: const Icon(Icons.add),
        label: const Text("New Chat"),
      ),

      body: loading
          ? const Center(child: CircularProgressIndicator())
          : conversations.isEmpty
          ? const Center(
              child: Text(
                "No Conversations Yet",
                style: TextStyle(color: Colors.white),
              ),
            )
          : ListView.builder(
              itemCount: conversations.length,
              itemBuilder: (_, index) {
                final conversation = conversations[index];

                return ConversationTile(
                  title: conversation.title,
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            ChatScreen(conversationId: conversation.id),
                      ),
                    );

                    loadConversations();
                  },
                );
              },
            ),
    );
  }
}
