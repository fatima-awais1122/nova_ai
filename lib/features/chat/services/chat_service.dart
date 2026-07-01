import 'package:dio/dio.dart';

import '../../../core/constants/api_constants.dart';
import '../../../core/network/dio_client.dart';

class ChatService {
  Future<Map<String, dynamic>> sendMessage({
    String? conversationId,
    required String message,
  }) async {
    final Response response = await DioClient.dio.post(
      ApiConstants.chat,
      data: {"conversationId": conversationId, "message": message},
    );

    return response.data;
  }
}
