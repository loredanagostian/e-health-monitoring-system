class ChatMessage {
  final String message;
  final SenderType sender;

  ChatMessage({
    required this.message,
    required this.sender
  });
}

enum SenderType {
  user,
  chatbot,
}
