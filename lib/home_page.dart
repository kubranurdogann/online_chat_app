import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/chat_page.dart';
import 'package:chat_app/consts.dart'; // PLACEHOLDER_PFP burada tanımlı
import 'package:chat_app/models/user_profile.dart';
import 'package:chat_app/services/alert_service.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:chat_app/services/database_service.dart';
import 'package:chat_app/signin_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DatabaseService _dbService = DatabaseService();
  final AuthService _auth = AuthService();
  List<UserProfile> users = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    List<UserProfile>? fetchedUsers = await _dbService.fetchUsers();
    setState(() {
      users = fetchedUsers ?? [];
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Messages",
          style: TextStyle(color: Colors.blue[900], fontSize: 20),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              bool result = await _auth.logout();
              if (result == true) {
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (context) => SignIn()));
              } else {
                CustomToast(
                  message: "Logout failed.",
                  icon: Icons.error,
                  iconColor: Colors.red,
                ).show(context);
              }
            },
            icon: Icon(Icons.logout),
            color: Colors.red,
          )
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : users.isEmpty
              ? Center(child: Text("No users found."))
              : ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    UserProfile user = users[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: CachedNetworkImageProvider(
                          users[index].pfpURL!,
                        ),
                        child: CachedNetworkImage(
                          imageUrl: users[index].pfpURL!,
                          placeholder: (context, url) => CircleAvatar(
                              backgroundImage: NetworkImage(PLACEHOLDER_PFP)),
                          errorWidget: (context, url, error) => CircleAvatar(
                              backgroundImage: NetworkImage(PLACEHOLDER_PFP)),
                        ),
                      ),
                      title: Text(user.name!),
                      onTap: () async {
                        bool chatExists;
                        try {
                          chatExists = await _dbService.checkChatExists(
                              _auth.user!.uid, user.uid!);
                          if (chatExists) {
                          } else {
                            await _dbService.createNewChat(
                                _auth.user!.uid, user.uid!);

                          }
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ChatPage(
                                        chatUser: user,
                                      )));
                        } catch (e) {
                          print("Error checking chat existence: $e");
                        }
                      },
                    );
                  },
                ),
    );
  }
}
