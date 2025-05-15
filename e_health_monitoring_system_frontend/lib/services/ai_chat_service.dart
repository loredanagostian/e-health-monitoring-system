import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:e_health_monitoring_system_frontend/constants/ai_chat_constants.dart';
import 'package:e_health_monitoring_system_frontend/models/chat_message.dart';

class OpenRouterService {
  // static const String _baseUrl = 'https://openrouter.ai/api/v1/chat/completions';
  // static const String _model = 'mistralai/mistral-7b-instruct'; // or other available models
  // static const String _apiKey = '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'; // store securely!

  static Future<String?> sendMessage(List<ChatMessage> conversation) async {

    final messages = <Map<String, String>>[];

    messages.add({
      'role': 'system',
      'content': ChatGptConstants.customerAssistantPrompt,
    });

    for (final msg in conversation) {
      messages.add({
        'role': msg.sender == SenderType.user ? 'user' : 'assistant',
        'content': msg.message,
      });
    }
    
    final requestBody = {
      'model': ChatGptConstants.model,
      'messages': messages,
      'temperature': ChatGptConstants.temperature,
      'max_tokens': ChatGptConstants.maxTokens,
    };

    print(ChatGptConstants.baseUrl + ChatGptConstants.chatEndpoint);

    try {
      final response = await http.post(
        Uri.parse(ChatGptConstants.baseUrl + ChatGptConstants.chatEndpoint),
        headers: {
          'Authorization': 'Bearer ${ChatGptConstants.apiKey}',
          'Content-Type': 'application/json'
        },
        body: jsonEncode(requestBody),
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        return jsonResponse['choices'][0]['message']['content']?.trim();
      } else {
        print('OpenRouter API error: ${response.body}');
        return null;
      }
    } on TimeoutException {
      print('OpenRouter request timed out.');
      return null;
    } catch (e) {
      print('Unexpected error: $e');
      return null;
    }
  }
}
