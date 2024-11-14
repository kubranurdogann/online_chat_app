import 'package:chat_app/consts.dart';
import 'package:chat_app/models/user_profile.dart';
import 'package:flutter/material.dart';


class ChatTile extends StatelessWidget {
  final UserProfile userProfile;
  final Function onTap;

  ChatTile({super.key, required this.userProfile, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => onTap(),
      dense: false,
      leading: CircleAvatar(
        backgroundImage: userProfile.pfpURL != null && userProfile.pfpURL!.isNotEmpty
            ? NetworkImage(userProfile.pfpURL!)
            : NetworkImage(PLACEHOLDER_PFP) as ImageProvider,
      ),
      title: Text(userProfile.name ?? 'Anonim'),
    );
  }
}

