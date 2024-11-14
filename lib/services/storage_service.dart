import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  StorageService() {}

  Future<String?> uploadUserPic({required File file, required String uid}) {
    Reference fileRef = _firebaseStorage
        .ref('users/pfps')
        .child('$uid${p.extension(file.path)}');
    UploadTask task = fileRef.putFile(file);
    return task.then((p) {
      if (p.state == TaskState.success) {
        return fileRef.getDownloadURL();
      }
    });
  }
Future<String?> uploadUserPicBytes({required Uint8List file, required String uid}) async {
    try {
      // Dosya referansı oluştur
      Reference ref = _firebaseStorage.ref().child('user_profile_pics/$uid.jpg');

      // Dosyayı yükle
      UploadTask uploadTask = ref.putData(file);
      
      // Yükleme işleminin sonucunu bekle
      TaskSnapshot snapshot = await uploadTask;

      // Yüklenen dosyanın URL'sini al
      String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print("Error uploading profile picture: $e");
      return null;
    }
  }
}
