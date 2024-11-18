import 'package:chat_app/consts.dart';
import 'package:chat_app/models/chat.dart';
import 'package:chat_app/models/message.dart';
import 'package:chat_app/models/user_profile.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:chat_app/services/database_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  final UserProfile chatUser;
  ChatPage({super.key, required this.chatUser});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  ChatUser? currentUser, otherUser;
  AuthService _auth = AuthService();
  DatabaseService _db = DatabaseService();

  @override
  void initState() {
    super.initState();

    // _auth.user null değilse currentUser'ı ayarla
    if (_auth.user != null) {
      currentUser = ChatUser(
        id: _auth.user!.uid,
        firstName: _auth.user!.displayName ?? "Anonim", // Varsayılan isim
      );
    }

    // widget.chatUser null değilse otherUser'ı ayarla
    otherUser = ChatUser(
      id: widget.chatUser.uid ?? "unknown",
      firstName: widget.chatUser.name ?? "Anonim", // Varsayılan isim
      profileImage: widget.chatUser.pfpURL ?? PLACEHOLDER_PFP,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.chatUser.name ?? "Anonim"),
      ),
      body: _buildUI(),
    );
  }

  Widget _buildUI() {
    return StreamBuilder(
        stream: _db.getChatData(currentUser!.id, otherUser!.id),
        builder: (context, snapshot) {
          Chat? chat = snapshot.data!.data();
          List<ChatMessage> messages = [];

          if (chat != null && chat.messages != null) {
            messages = generateChatMessagesList(chat.messages!);
          }
          return currentUser != null
              ? DashChat(
                  inputOptions: const InputOptions(alwaysShowSend: true),
                  currentUser: currentUser!,
                  onSend: _sendMessage,
                  messages: messages,
                )
              : Center(child: CircularProgressIndicator());
        });
  }

  Future<void> _sendMessage(ChatMessage chatMessage) async {
    Message message = Message(
        senderID: currentUser!.id,
        content: chatMessage.text,
        messageType: MessageType.Text,
        sentAt: Timestamp.fromDate(chatMessage.createdAt));
    await _db.sendMessage(currentUser!.id, otherUser!.id, message);
  }

  List<ChatMessage> generateChatMessagesList(List<Message> messages) {
    List<ChatMessage> chatMessages = messages.map((m) {
      return ChatMessage(
          user: m.senderID == currentUser!.id ? currentUser! : otherUser!,
          text: m.content!,
          createdAt: m.sentAt!.toDate());
    }).toList();
    chatMessages.sort((a, b){
      return b.createdAt.compareTo(a.createdAt);
    });
    return chatMessages;
  }
}
