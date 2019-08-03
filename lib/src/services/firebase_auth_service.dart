import 'package:firebase_auth/firebase_auth.dart';
import 'package:lets_walk/src/models/user.dart';

class FirebaseAuthService {

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  User _userFromFirebase(FirebaseUser user) {
    if (user == null) {
      return null;
    }
    return User(
      uid: user.uid,
      email: user.email,
    );
  }

  Future<User> signInWithEmailAndPassword(String email, String password) async {
    final AuthResult authResult = await _firebaseAuth.signInWithCredential(EmailAuthProvider.getCredential(
      email: email,
      password: password,
    ));
    return _userFromFirebase(authResult.user);
  }

}