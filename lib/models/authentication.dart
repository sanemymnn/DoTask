import 'package:firebase_auth/firebase_auth.dart';
import 'database.dart';


class Authentication {

  final FirebaseAuth _auth;
 Authentication(this._auth);
Stream<User> get authStateChanges => _auth.idTokenChanges();

//sign up

  Future signUp(String name, String surname, String email, String password) async
  {
  try{
    UserCredential result= await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email, 
      password:password
    );
    User user =result.user;
    await Database().createUserData(name, surname, email, user.uid);
    return user;
    } 
    on FirebaseAuthException catch (e) {
  if (e.code == 'weak-password') {
    print('The password provided is too weak.');
  } else if (e.code == 'email-already-in-use') {
    print('The account already exists for that email.');
  }
} catch (e) {
  print(e);
}

  }

  //login

  Future login(String email, String password) async
  {
    try {
      UserCredential result = await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email, password: password
      );
      return result.user;
    } 
    on FirebaseAuthException catch (e) {
  if (e.code == 'user-not-found') {
    print('No user found for that email.');
  } else if (e.code == 'wrong-password') {
    print('Wrong password provided for that user.');
  }
  }

  //sign out

  

  //get user 


  

 

 
 
}
}

