import 'package:flutter/material.dart';
import 'package:scholarchat/constans.dart';
import 'package:scholarchat/models/message_model.dart';
import 'package:scholarchat/widgets/chat_buble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreen extends StatelessWidget {
  ChatScreen({super.key});
  static String id = 'chatsereen';

  final _controller = ScrollController();

  CollectionReference messages =
      FirebaseFirestore.instance.collection(kMessagesCollection);
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var email = ModalRoute.of(context)!.settings.arguments;
    return StreamBuilder<QuerySnapshot>(
      stream: messages.orderBy(kCreatedAt, descending: true).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Message> messagesList = [];
          for (int i = 0; i < snapshot.data!.docs.length; i++) {
            messagesList.add(Message.fromJson(snapshot.data!.docs[i]));
          }
          return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: kPrimaryColor,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    iconImage,
                    height: 60,
                  ),
                  const Text(
                    'Chat',
                    style: TextStyle(color: Colors.white),
                  )
                ],
              ),
            ),
            body: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    reverse: true,
                    controller: _controller,
                    itemCount: messagesList.length,
                    itemBuilder: (context, index) {
                      return messagesList[index].id == email
                          ? ChatBuble(
                              message: messagesList[index],
                            )
                          : ChatBubleForFrind(
                              message: messagesList[index],
                            );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextField(
                    controller: controller,
                    onSubmitted: (data) {
                      messages.add(
                        {
                          kMessage: data,
                          kCreatedAt: DateTime.now(),
                          'id': email,
                        },
                      );
                      controller.clear();
                      _controller.animateTo(0,
                          duration: const Duration(seconds: 1),
                          curve: Curves.easeIn);
                    },
                    decoration: InputDecoration(
                      hintText: 'send Message',
                      suffixIcon: IconButton(
                        onPressed: () {
                          if (controller.text.trim().isNotEmpty) {
                            messages.add(
                              {
                                kMessage: controller.text,
                                kCreatedAt: DateTime.now(),
                                'id': email,
                              },
                            );
                          } 
                          // else {
                          //  showSnakBar(context, 'Please enter a message');
                          // }
                          controller.clear();
                          _controller.animateTo(0,
                              duration: const Duration(seconds: 1),
                              curve: Curves.easeIn);
                        },
                        icon: const Icon(
                          Icons.send,
                        ),
                        color: kPrimaryColor,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: kPrimaryColor),
                      ),
                      focusColor: kPrimaryColor,
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
        } else {
          return const Text('loading...');
        }
      },
    );
  }
}
