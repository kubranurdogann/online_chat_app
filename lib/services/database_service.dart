import 'package:chat_app/models/chat.dart';
import 'package:chat_app/models/message.dart';
import 'package:chat_app/models/user_profile.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final AuthService _auth = AuthService();

  late final CollectionReference<UserProfile> _userCollection;
  late final CollectionReference<Chat> _chatsCollection;

  DatabaseService() {
    _setupCollectionReferences();
  }

  void _setupCollectionReferences() {
    _userCollection = _db.collection('users').withConverter<UserProfile>(
          fromFirestore: (snapshot, _) =>
              UserProfile.fromJson(snapshot.data()!),
          toFirestore: (userProfile, _) => userProfile.toJson(),
        );

    _chatsCollection = _db.collection('chats').withConverter(
        fromFirestore: (snapshots, _) => Chat.fromJson(snapshots.data()!),
        toFirestore: (chat, _) => chat.toJson());
  }

  Future<void> createUserProfile({required UserProfile user}) async {
    await _userCollection.doc(user.uid).set(user);
  }

  Future<List<UserProfile>?> fetchUsers() async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) return null;

      QuerySnapshot querySnapshot = await _db
          .collection('users')
          .where('uid', isNotEqualTo: currentUser.uid)
          .get();

      List<UserProfile> userList = querySnapshot.docs.map((doc) {
        return UserProfile(
          uid: doc.id,
          name: doc['name'] ?? 'Anonim',
          pfpURL: doc['pfpURL'] ?? '',
        );
      }).toList();

      return userList;
    } catch (e) {
      print("Hata: $e");
      return null;
    }
  }

  String generateChatID({required String uid1, required String uid2}) {
    List<String> uids = [uid1, uid2];
    uids.sort();
    return uids.join('_');
  }

  Future<bool> checkChatExists(String uid1, String uid2) async {
    try {
      String chatID = generateChatID(uid1: uid1, uid2: uid2);
      final result = await _chatsCollection.doc(chatID).get();
      return result.exists;
    } catch (e) {
      print("Error checking chat existence: $e");
      return false;
    }
  }

  Future<void> createNewChat(String uid1, String uid2) async {
    String chatID = generateChatID(uid1: uid1, uid2: uid2);
    final docRef = _chatsCollection.doc(chatID);
    final chat = Chat(id: chatID, participants: [uid1, uid2], messages: []);
    await docRef.set(chat);
  }

  Future<void> sendMessage(String uid1, String uid2, Message message) async {
    String chatID = generateChatID(uid1: uid1, uid2: uid2);
    final docRef = _chatsCollection.doc(chatID);
    await docRef.update({
      "messages": FieldValue.arrayUnion([message.toJson()]),
    });
  }
}
