import 'package:firebase_auth/firebase_auth.dart';
import 'database.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Stream<User> get onAuthStateChanged  => _firebaseAuth.authStateChanges();

  Future<String> getCurrentUID() async {
    return _firebaseAuth.currentUser.uid;
  }


  // Email & Password Sign Up
  Future<String> createUserWithEmailAndPassword (
      String name, String surname, String email, String password ) async {
    UserCredential currentUser = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
      
    );
    User user=currentUser.user;
    await Database().createUserData(name, surname, email, user.uid);
    

    // Update the username
    
    await currentUser.user.updateProfile();
    await currentUser.user.reload();
    return currentUser.user.uid;
  }

  // Email & Password Sign In
  Future<String> signInWithEmailAndPassword(
      String email, String password) async {
    return (await _firebaseAuth.signInWithEmailAndPassword(
            email: email, password: password))
        .user.uid;
  }

  // Sign Out
  signOut() {
    return _firebaseAuth.signOut();
  }

}

class NameValidator {
  static String validate(String value) {
    if(value.isEmpty) {
      return "Name can't be empty";
    }
    if(value.length < 2) {
      return "Name must be at least 2 characters long";
    }
    if(value.length > 50) {
      return "Name must be less than 50 characters long";
    }
    return null;
  }
}

class EmailValidator {
  static String validate(String value) {
    if(value.isEmpty) {
      return "Email can't be empty";
    }
    return null;
  }
}

class PasswordValidator {
  static String validate(String value) {
    if(value.isEmpty) {
      return "Password can't be empty";
    }
    return null;
  }
}