import 'package:cloud_firestore/cloud_firestore.dart';

class Database {
  final String uid;
  Database({this.uid});

  final CollectionReference profileList= 

  FirebaseFirestore.instance.collection("profileInfo");
  


  Future<void> createUserData (String name, String surname, String email, String uid) async {
    return await profileList.doc(uid).set({
    "name": name,
    "surname": surname,
    "email": email

    });
    }

    Future updateUserList(String name, String surname, String email, String uid) async {
      return await profileList.doc(uid).update( {
        "name" : name,
        "surname" :surname,
        "email" :email
        
      });
    }
  
  Future getUsersList() async {
    List itemsList = [];

    try {
      await profileList.get().then((querySnapshot) {

        querySnapshot.docs.forEach((element) {
          itemsList.add(element.data);
        });

      } );
      return itemsList;
    } catch(e) {
      print(e.toString());
      return null;
    }
  }

  Stream<QuerySnapshot> get users {

    return profileList.snapshots();

  }
  
  Future getCurrentUserData() async {
    try {
      DocumentSnapshot snapshot = await profileList.doc(uid).get();
      String name = snapshot.get("name");
      String surname = snapshot.get("surname");
      String email = snapshot.get("email");
      return [name, surname, email];

    } catch(e) {
      print(e.toString());
      return null;
    }
  }
  }


