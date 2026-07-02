import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../models/conversation_model.dart';
import '../services/conversation_service.dart';
import '../widgets/conversation_tile.dart';
import '../../chat/screens/chat_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ConversationService _conversationService = ConversationService();

  List<ConversationModel> conversations = [];

  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadConversations();
  }

  Future<void> loadConversations() async {
    try {
      setState(() {
        loading = true;
      });

      final response = await _conversationService.getConversations();

      conversations = response
          .map<ConversationModel>((e) => ConversationModel.fromJson(e))
          .toList();

      setState(() {
        loading = false;
      });
    } catch (e) {
      setState(() {
        loading = false;
      });

      debugPrint(e.toString());
    }
  }

  Future<void> openChat({String? conversationId}) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChatScreen(conversationId: conversationId),
      ),
    );

    loadConversations();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        title: const Text("Nova AI"),
        actions: [
          IconButton(
            onPressed: loadConversations,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        onPressed: () => openChat(),
        icon: const Icon(Icons.add),
        label: const Text("New Chat"),
      ),

      body: loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: loadConversations,
              child: conversations.isEmpty
                  ? ListView(
                      children: const [
                        SizedBox(height: 250),

                        Center(
                          child: Text(
                            "No Conversations Yet",
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ),

                        SizedBox(height: 10),

                        Center(
                          child: Text(
                            "Tap 'New Chat' to start talking with Nova AI",
                            style: TextStyle(color: Colors.grey),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    )
                  : ListView.builder(
                      itemCount: conversations.length,
                      itemBuilder: (_, index) {
                        final conversation = conversations[index];

                        return ConversationTile(
                          title: conversation.title,
                          onTap: () =>
                              openChat(conversationId: conversation.id),
                        );
                      },
                    ),
            ),
    );
  }
}
