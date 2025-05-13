import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:e_health_monitoring_system_frontend/helpers/colors_helper.dart';


class ChatSupportScreen extends ConsumerStatefulWidget {
  //final Account friendAccount;
  //const ChatScreen({super.key, required this.friendAccount});

  @override
  ConsumerState<ChatSupportScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatSupportScreen> {
  final TextEditingController _messageController = TextEditingController();
  //final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // void sendMessage() async {
  //   if (_messageController.text.isNotEmpty) {
  //     await ChatManager.sendMessage(
  //         widget.friendAccount.userId, _messageController.text);
  //     _messageController.clear();
  //   }
  // }

  // Widget _buildMessageList() {
  //   return StreamBuilder(
  //       stream: ChatManager.getMessages(widget.friendAccount.userId),
  //       builder: (context, snapshot) {
  //         if (snapshot.hasError) {
  //           return Text('Error${snapshot.error}');
  //         }

  //         if (snapshot.connectionState == ConnectionState.waiting) {
  //           return Center(child: CircularProgressIndicator());
  //         }

  //         return ListView(
  //           children: snapshot.data!.docs
  //               .map((document) => _buildListItem(document))
  //               .toList(),
  //         );
  //       });
  // }

  // Widget _buildListItem(DocumentSnapshot document) {
  //   Map<String, dynamic> data = document.data() as Map<String, dynamic>;
  //   bool isMessageSentByCurrentUser =
  //       data["senderId"] == _firebaseAuth.currentUser!.uid;

  //   return Padding(
  //     padding: EdgeInsets.only(bottom: AppSizes.smallDistance),
  //     child: Row(
  //       mainAxisAlignment: isMessageSentByCurrentUser
  //           ? MainAxisAlignment.end
  //           : MainAxisAlignment.start,
  //       crossAxisAlignment: CrossAxisAlignment.end,
  //       children: [
  //         Visibility(
  //             visible: !isMessageSentByCurrentUser,
  //             child: SizedBox(
  //                 height: 50,
  //                 width: 50,
  //                 child: widget.friendAccount.imageURL != null
  //                     ? CircleAvatar(
  //                         backgroundImage:
  //                             NetworkImage(widget.friendAccount.imageURL!))
  //                     : CircleAvatar(
  //                         backgroundImage:
  //                             AssetImage(AppPaths.defaultProfilePicture),
  //                         backgroundColor: AppColors.white,
  //                       ))),
  //         Visibility(
  //             visible: !isMessageSentByCurrentUser,
  //             child: SizedBox(width: AppSizes.smallDistance)),
  //         Container(
  //           height: 70,
  //           width: 220,
  //           alignment: isMessageSentByCurrentUser
  //               ? Alignment.centerLeft
  //               : Alignment.centerRight,
  //           padding: const EdgeInsets.all(AppSizes.mediumDistance),
  //           decoration: BoxDecoration(
  //             color: isMessageSentByCurrentUser
  //                 ? AppColors.lightBlue
  //                 : AppColors.mediumBlue,
  //             borderRadius: BorderRadius.only(
  //                 topLeft: Radius.circular(AppSizes.borders),
  //                 topRight: Radius.circular(AppSizes.borders),
  //                 bottomLeft: isMessageSentByCurrentUser
  //                     ? Radius.circular(AppSizes.borders)
  //                     : Radius.zero,
  //                 bottomRight: isMessageSentByCurrentUser
  //                     ? Radius.zero
  //                     : Radius.circular(
  //                         AppSizes.borders,
  //                       )),
  //           ),
  //           child: Center(
  //             child: Text(
  //               data["message"],
  //               style: AppStyles.hintComponentStyle.copyWith(
  //                 color: AppColors.white,
  //               ),
  //             ),
  //           ),
  //         ),
  //         Visibility(
  //             visible: isMessageSentByCurrentUser,
  //             child: SizedBox(width: AppSizes.smallDistance)),
  //         Visibility(
  //           visible: isMessageSentByCurrentUser,
  //           child: SizedBox(
  //               height: 50,
  //               width: 50,
  //               child: _firebaseAuth.currentUser!.photoURL != null
  //                   ? CircleAvatar(
  //                       backgroundImage:
  //                           NetworkImage(_firebaseAuth.currentUser!.photoURL!))
  //                   : CircleAvatar(
  //                       backgroundImage:
  //                           AssetImage(AppPaths.defaultProfilePicture),
  //                       backgroundColor: AppColors.white,
  //                     )),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // Widget _buildMessageInput() {
  //   return Expanded(
  //       child: TextFormField(
  //     controller: _messageController,
  //     decoration: InputDecoration(
  //       isDense: true,
  //       contentPadding: const EdgeInsets.fromLTRB(
  //         AppSizes.mediumDistance,
  //         AppSizes.smallDistance,
  //         AppSizes.mediumDistance,
  //         AppSizes.smallDistance,
  //       ),
  //       hintText: AppStrings.typeAMessageHint,
  //       hintStyle: AppStyles.bodyStyle.copyWith(color: AppColors.mediumGray),
  //       fillColor: AppColors.componentGray,
  //       filled: true,
  //       suffixIcon:
  //           IconButton(icon: Icon(Icons.send_outlined), onPressed: sendMessage),
  //       suffixIconColor: AppColors.mainDarkGray,
  //       border: OutlineInputBorder(
  //         borderRadius: BorderRadius.circular(AppSizes.borders),
  //       ),
  //       enabledBorder: OutlineInputBorder(
  //         borderSide: const BorderSide(color: AppColors.componentGray),
  //         borderRadius: BorderRadius.circular(AppSizes.borders),
  //       ),
  //       focusedBorder: OutlineInputBorder(
  //         borderSide: const BorderSide(color: AppColors.componentGray),
  //         borderRadius: BorderRadius.circular(AppSizes.borders),
  //       ),
  //     ),
  //     textCapitalization: TextCapitalization.sentences,
  //     keyboardType: TextInputType.text,
  //   ));
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: ColorsHelper.mainWhite,
          elevation: 0,
          titleSpacing: 0.0,
          title: Row(
            children: [
              SizedBox(
                height: 50,
                width: 50,
                child: Padding(
                    padding:
                        const EdgeInsets.only(right: 15),
                    child: 
                      CircleAvatar(
                        backgroundImage:
                          AssetImage('assets/images/chatbot_icon.png',),
                        backgroundColor: ColorsHelper.mainWhite,
                      )),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "ChatBot",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: ColorsHelper.mainDark,
                    ),
                  ),
                ],
              )
            ],
          ),
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.arrow_back_ios,
              color: ColorsHelper.mainDark,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              // Expanded(child: _buildMessageList()),
              // Align(
              //   alignment: Alignment.bottomCenter,
              //   child: _buildMessageInput(),
              // ),
            ],
          ),
        ));
  }
}