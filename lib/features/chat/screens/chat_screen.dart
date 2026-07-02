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

  final ScrollController scrollController = ScrollController();

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

  void scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!scrollController.hasClients) return;

      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  Future<void> loadMessages() async {
    try {
      final response = await _messageService.getMessages(conversationId!);

      messages.clear();

      messages.addAll(
        response.map<MessageModel>((e) => MessageModel.fromJson(e)).toList(),
      );

      setState(() {});

      scrollToBottom();
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

    scrollToBottom();

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

      scrollToBottom();
    } catch (e) {
      setState(() {
        loading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }

  @override
  void dispose() {
    controller.dispose();
    scrollController.dispose();
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
              controller: scrollController,
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
              padding: EdgeInsets.all(10),
              child: Row(
                children: [
                  SizedBox(width: 12),

                  CircleAvatar(
                    radius: 14,
                    backgroundColor: AppColors.primary,
                    child: Icon(Icons.smart_toy, color: Colors.white, size: 15),
                  ),

                  SizedBox(width: 10),

                  Text(
                    "Nova AI is typing...",
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
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
