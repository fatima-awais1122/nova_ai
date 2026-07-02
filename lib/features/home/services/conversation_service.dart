import 'package:dio/dio.dart';

import '../../../core/constants/api_constants.dart';
import '../../../core/network/dio_client.dart';

class ConversationService {
  Future<List<dynamic>> getConversations() async {
    final Response response = await DioClient.dio.get(
      ApiConstants.conversations,
    );

    return response.data["conversations"];
  }

  Future<Map<String, dynamic>> getConversation(String id) async {
    final Response response = await DioClient.dio.get(
      "${ApiConstants.conversations}/$id",
    );

    return response.data["conversation"];
  }

  Future<void> deleteConversation(String id) async {
    await DioClient.dio.delete("${ApiConstants.conversations}/$id");
  }

  Future<void> renameConversation({
    required String id,
    required String title,
  }) async {
    await DioClient.dio.patch(
      "${ApiConstants.conversations}/$id",
      data: {"title": title},
    );
  }
}
