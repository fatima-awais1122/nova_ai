import 'package:dio/dio.dart';

import '../../../core/constants/api_constants.dart';
import '../../../core/network/dio_client.dart';

class MessageService {
  Future<List<dynamic>> getMessages(String conversationId) async {
    final Response response = await DioClient.dio.get(
      "${ApiConstants.messages}/$conversationId",
    );

    return response.data["data"] ?? [];
  }
}
