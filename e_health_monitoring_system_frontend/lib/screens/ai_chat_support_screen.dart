import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:e_health_monitoring_system_frontend/helpers/colors_helper.dart';
import 'package:e_health_monitoring_system_frontend/helpers/animated_dots_helper.dart';
import 'package:e_health_monitoring_system_frontend/models/chat_message.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:e_health_monitoring_system_frontend/services/ai_chat_service.dart';

class ChatSupportScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<ChatSupportScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatSupportScreen> {
  final TextEditingController messageController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  List<ChatMessage> chatMessages = [
    ChatMessage(message: "Hi, what can I help you with?", sender: SenderType.chatbot)
  ];
  String? firstName;
  String? lastName;
  static final SharedPreferencesAsync _prefs = SharedPreferencesAsync();
  bool chatIsTyping = false;

  @override
  void initState() {
    super.initState();
    loadUserInfo();
  }

  Future<void> loadUserInfo() async {
    final _firstname = await _prefs.getString('firstName');
    final _lastname = await _prefs.getString('lastName');

    setState(() {
      firstName = _firstname;
      lastName = _lastname;
    });
  }

  Widget _buildMessageList() {
    return ListView.builder(
      controller: scrollController,
      itemCount: chatMessages.length,
      itemBuilder: (context, index) {
        return _buildListItem(chatMessages[index]);
      },
    );
  }

  Widget _buildListItem(ChatMessage message) {
  bool isMessageSentByCurrentUser = message.sender == SenderType.user;

  if (message.message == '...' && message.sender == SenderType.chatbot) {
    return _buildTypingIndicator();
  }

  return Padding(
    padding: EdgeInsets.only(bottom: 8.0),
    child: Row(
      mainAxisAlignment:
          isMessageSentByCurrentUser ? MainAxisAlignment.end : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (!isMessageSentByCurrentUser)
          CircleAvatar(
            backgroundImage: AssetImage('assets/images/chatbot_icon.png'),
            radius: 25,
          ),
        if (!isMessageSentByCurrentUser)
          SizedBox(width: 8.0),
        Flexible(
          child: Container(
            constraints: BoxConstraints(
              maxWidth: 250,
            ),
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: isMessageSentByCurrentUser
                  ? ColorsHelper.mediumPurple
                  : ColorsHelper.mainPurple,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25.0),
                topRight: Radius.circular(25.0),
                bottomLeft: isMessageSentByCurrentUser
                    ? Radius.circular(25.0)
                    : Radius.zero,
                bottomRight: isMessageSentByCurrentUser
                    ? Radius.zero
                    : Radius.circular(25.0),
              ),
            ),
            child: Text(
              message.message,
              style: TextStyle(
                color: ColorsHelper.mainWhite.withAlpha(179), // 0.7 * 255
                fontFamily: 'Poppins',
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
              softWrap: true,
            ),
          ),
        ),
        if (isMessageSentByCurrentUser)
          SizedBox(width: 8.0),
        if (isMessageSentByCurrentUser)
          CircleAvatar(
            backgroundColor: ColorsHelper.mediumPurple,
            radius: 25,
            child: Text(
              "${(firstName?.isNotEmpty ?? false ? firstName![0] : '')}${(lastName?.isNotEmpty ?? false ? lastName![0] : '')}",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: ColorsHelper.mainWhite,
              ),
            )
          )
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return TextFormField(
      controller: messageController,
      decoration: InputDecoration(
        isDense: true,
        contentPadding: const EdgeInsets.fromLTRB(
          16.0,
          8.0,
          16.0,
          8.0,
        ),
        hintText: "Ask any question about the app",
        hintStyle: TextStyle(
            color: ColorsHelper.darkGray,
            fontFamily: 'Poppins',
            fontSize: 16,
            fontWeight: FontWeight.w400),
        fillColor: ColorsHelper.lightGray,
        filled: true,
        suffixIcon:
            IconButton(icon: Icon(Icons.send_outlined), onPressed: chatIsTyping ? null : _handleSendMessage),
        suffixIconColor: ColorsHelper.mainDark,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: ColorsHelper.darkGray),
          borderRadius: BorderRadius.circular(25.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: ColorsHelper.darkGray),
          borderRadius: BorderRadius.circular(25.0),
        ),
      ),
      textCapitalization: TextCapitalization.sentences,
      keyboardType: TextInputType.text,
    );
  }

  void _handleSendMessage() async {
  final messageText = messageController.text.trim();
  if (messageText.isEmpty || chatIsTyping) return;

  setState(() {
    chatIsTyping = true;

    chatMessages.add(
      ChatMessage(message: messageText, sender: SenderType.user),
    );
  });

  messageController.clear();
  scrollToBottom();

  await Future.delayed(Duration(milliseconds: 1000));

  setState(() {
    chatMessages.add(ChatMessage(message: '...', sender: SenderType.chatbot));
  });

  scrollToBottom();

  final response = await OpenRouterService.sendMessage(chatMessages);

  setState(() {
    chatMessages.removeLast();

    if (response != null) {
      chatMessages.add(ChatMessage(message: response, sender: SenderType.chatbot));
    }

    chatIsTyping = false;
  });

  scrollToBottom();
}


  void scrollToBottom() async {
    await Future.delayed(Duration(milliseconds: 100), () {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  Widget _buildTypingIndicator() {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          CircleAvatar(
            backgroundImage: AssetImage('assets/images/chatbot_icon.png'),
            radius: 25,
          ),
          SizedBox(width: 8.0),
          Container(
            constraints: BoxConstraints(
              maxWidth: 100,
              minHeight: 40,
            ),
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: ColorsHelper.mainPurple,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25.0),
                topRight: Radius.circular(25.0),
                bottomRight: Radius.circular(25.0),
              ),
            ),
            child: AnimatedDots(),
          ),
        ],
      ),
    );
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorsHelper.mainWhite,
        elevation: 0,
        titleSpacing: 0.0,
        centerTitle: true,
        title: Text(
          "Chatbot Support",
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: ColorsHelper.mainDark,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              Expanded(child: _buildMessageList()),
              Align(
                alignment: Alignment(0.0, 0.0),
                child: _buildMessageInput(),
              ),
            ],
          )
        )
      )
    );
  }
}