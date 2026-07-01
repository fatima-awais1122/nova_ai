class MessageModel {
  final String id;
  final String role;
  final String content;
  final DateTime createdAt;

  MessageModel({
    required this.id,
    required this.role,
    required this.content,
    required this.createdAt,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json["id"],
      role: json["role"],
      content: json["content"],
      createdAt: DateTime.parse(json["createdAt"]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "role": role,
      "content": content,
      "createdAt": createdAt.toIso8601String(),
    };
  }
}
