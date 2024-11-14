import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  User? _user;

  User? get user => _firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  AuthService() {
    // authStateChanges stream'i dinleyerek _user'ı her değişiklikte güncelliyoruz
    _firebaseAuth.authStateChanges().listen((User? user) {
      _user = user;
    });
  }

  Future<bool> login(String email, String password) async {
    try {
      print("Firebase kimlik doğrulama başlatılıyor...");
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);

      if (credential.user != null) {
        _user = credential.user;
        print('Kullanıcı giriş yaptı: ${_user?.email}');
        return true;
      } else {
        print('Giriş başarısız: Kullanıcı bulunamadı.');
      }
    } on FirebaseAuthException catch (e) {
      print('Firebase Auth hatası: ${e.message}');
    } catch (e) {
      print('Bilinmeyen hata: $e');
    }
    return false;
  }

  Future<bool> register(String email, String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if(userCredential.user != null){
        _user = userCredential.user;
        return true;
      }
    } catch (e) {
      print("Error registering: $e");
    }
    return false;
  }


  Future<bool> logout() async {
    try{
      await _firebaseAuth.signOut();
      return true;
    }catch(e){
      print(e);
      
    }
    return false;
  }
}
