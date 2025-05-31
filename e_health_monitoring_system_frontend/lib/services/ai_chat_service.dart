import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:e_health_monitoring_system_frontend/models/chat_message.dart';
import 'package:e_health_monitoring_system_frontend/helpers/auth_manager.dart';

class AiChatService {
  static final AuthManager _manager = AuthManager();

  static Future<String?> sendMessage(List<ChatMessage> messages) async {
    var token = await _manager.jwtToken;
    try {
      final formattedMessages = messages.map((msg) {
        return {
          "role": msg.sender == SenderType.user ? "user" : "assistant",
          "content": msg.message
        };
      }).toList();

      final response = await http.post(
        Uri.parse("${AuthManager.endpoint}/Chat/SendMessage"),
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer ${token?.accessToken}",
          },
          body: jsonEncode({"messages": formattedMessages}),
      );

      print("Backend response (${response.statusCode}): ${response.body}");

      if (response.statusCode == 200) {
        final responseJson = jsonDecode(response.body);
        return responseJson['response'];
      } else {
        print('Server error: ${response.body}');
        return "Sorry, something went wrong on our end.";
      }
    } catch (e) {
      print('Error sending message: $e');
      return "Failed to contact support. Please try again later.";
    }
  }

  static Future<List<ChatMessage>> getConversation() async {
    var token = await _manager.jwtToken;
    final url = Uri.parse('${AuthManager.endpoint}/Chat/GetConversation');
    final response = await http.get(url, headers: {
      'Authorization': 'Bearer ${token?.accessToken}',
      'Content-Type': 'application/json',
    });

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);

      return data.map((msg) {
        return ChatMessage(
          message: msg['message'],
          sender: msg['sender'] == 'user' ? SenderType.user : SenderType.chatbot,
        );
      }).toList();
    } else {
      print("Failed to load conversation: ${response.body}");
      return [];
    }
  }
}
