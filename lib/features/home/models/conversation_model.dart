import '../../chat/models/message_model.dart';

class ConversationModel {
  final String id;
  final String title;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<MessageModel> messages;

  ConversationModel({
    required this.id,
    required this.title,
    required this.createdAt,
    required this.updatedAt,
    this.messages = const [],
  });

  factory ConversationModel.fromJson(Map<String, dynamic> json) {
    return ConversationModel(
      id: json["id"],
      title: json["title"],
      createdAt: DateTime.parse(json["createdAt"]),
      updatedAt: DateTime.parse(json["updatedAt"]),
      messages: json["messages"] == null
          ? []
          : (json["messages"] as List)
                .map((e) => MessageModel.fromJson(e))
                .toList(),
    );
  }
}
