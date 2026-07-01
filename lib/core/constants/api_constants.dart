class ApiConstants {
  ApiConstants._();

  static const String baseUrl = "http://localhost:5000/api/v1";

  static const String register = "/auth/register";
  static const String login = "/auth/login";
  static const String me = "/auth/me";

  static const String conversations = "/conversations";
  static const String messages = "/messages";
  static const String chat = "/chat";
}
