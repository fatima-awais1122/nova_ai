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
}
