import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../models/message_model.dart';
import '../services/chat_service.dart';
import '../services/message_service.dart';
import '../widgets/message_bubble.dart';

class ChatScreen extends StatefulWidget {
  final String? conversationId;

  const ChatScreen({super.key, this.conversationId});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ChatService _chatService = ChatService();
  final MessageService _messageService = MessageService();

  final TextEditingController controller = TextEditingController();

  final List<MessageModel> messages = [];

  bool loading = false;

  String? conversationId;

  @override
  void initState() {
    super.initState();

    conversationId = widget.conversationId;

    if (conversationId != null) {
      loadMessages();
    }
  }

  Future<void> loadMessages() async {
    try {
      final response = await _messageService.getMessages(conversationId!);

      messages.clear();

      messages.addAll(
        response.map<MessageModel>((e) => MessageModel.fromJson(e)).toList(),
      );

      setState(() {});
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> sendMessage() async {
    if (controller.text.trim().isEmpty) return;

    final text = controller.text.trim();

    setState(() {
      messages.add(
        MessageModel(
          id: "",
          role: "user",
          content: text,
          createdAt: DateTime.now(),
        ),
      );

      loading = true;
    });

    controller.clear();

    try {
      final response = await _chatService.sendMessage(
        conversationId: conversationId,
        message: text,
      );

      final data = response["data"];

      conversationId = data["conversationId"];

      setState(() {
        messages.add(
          MessageModel(
            id: data["assistantMessage"]["id"],
            role: "assistant",
            content: data["assistantMessage"]["content"],
            createdAt: DateTime.parse(data["assistantMessage"]["createdAt"]),
          ),
        );

        loading = false;
      });
    } catch (e) {
      setState(() {
        loading = false;
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(title: const Text("Nova AI")),

      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 12),
              itemCount: messages.length,
              itemBuilder: (_, index) {
                final msg = messages[index];

                return MessageBubble(
                  message: msg.content,
                  isUser: msg.role == "user",
                );
              },
            ),
          ),

          if (loading)
            const Padding(
              padding: EdgeInsets.all(12),
              child: CircularProgressIndicator(),
            ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => sendMessage(),
                      decoration: InputDecoration(
                        hintText: "Ask Nova AI...",
                        filled: true,
                        fillColor: AppColors.surface,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 10),

                  IconButton(
                    onPressed: loading ? null : sendMessage,
                    icon: const Icon(Icons.send, color: AppColors.primary),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
