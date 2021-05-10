import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart'; 


class BooksScreen extends StatefulWidget {

  static const route = "/BooksScreen";

  @override
  _ListBooksStuffState createState() => _ListBooksStuffState() ;
}

class _ListBooksStuffState extends State<BooksScreen> {

  String userID = "";
  String listInput = "";
  double userRating;

  @override
  void initState() {
    super.initState();
    fetchUserInfo();
  }

  fetchUserInfo() async {
    User getUser = FirebaseAuth.instance.currentUser;
    userID = getUser.uid;
  }

  Future<void> addOtherList() async {
    final DocumentReference documentReference =
      FirebaseFirestore.instance.collection("profileInfo").doc(userID).collection("book_lists").doc(listInput);
    Map<String, dynamic> lists = {
      "bookListsTitle":listInput,
      "userRating":0.0,
    };
    await documentReference.set(lists, SetOptions(merge: true)).whenComplete(() {
     return null;
    });
  }

  Future<void> deleteOtherLists(item) async {
    final DocumentReference documentReference =
      FirebaseFirestore.instance.collection("profileInfo").doc(userID).collection("book_lists").doc(item);
    await documentReference.delete().whenComplete(() {
      print(" $listInput deleted successfully");
    }).catchError((error) => print("Deleting list is failed. There is an error: $error"));
  }

  

  @override
  Widget build(BuildContext context){
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue[400],
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                title: Text("Add your list"),
                content: TextField(
                  onChanged: (String value) {
                    listInput = value;
                  },
                ),
                actions: <Widget>[
                 
                  FlatButton(
                    onPressed: () {
                      addOtherList();
                      Navigator.of(context).pop();
                    },
                    child: Text("Add"),
                  ),
                ],
              );
            },
          );
        }, //onPressed
        child: Icon(Icons.add),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("profileInfo").doc(userID).collection("book_lists").snapshots(),
        builder: (context, snapshots) {
          if(snapshots.hasError) {
            return Text("Something went wrong");
          }
          else if(snapshots.data == null) return CircularProgressIndicator();
          return ListView.builder(
            shrinkWrap: true,
            itemCount: snapshots.data.docs.length,
            itemBuilder: (context, index) {
              DocumentSnapshot documentSnapshot = snapshots.data.docs[index];
              return Dismissible(
                onDismissed: (direction){
                  deleteOtherLists(documentSnapshot["bookListsTitle"]);
                },
                key: Key(documentSnapshot.data()["bookListsTitle"]),
                child: Card(
                  elevation: 4,
                  margin: EdgeInsets.all(8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ListTile(
                    title: Text(documentSnapshot.data()["bookListsTitle"]),
                    subtitle:
                    SmoothStarRating(
                              allowHalfRating: true,
                              starCount: 5,
                              size: 20.0,
                              color: Colors.blue,
                              borderColor: Colors.blue,
                              onRated: (userRating) {
                                
                                updateRating(item) {
                                  DocumentReference documentReference =
                                  FirebaseFirestore.instance.collection("profileInfo").doc(userID).collection("book_lists").doc(item);
                                  Map<String, dynamic> list = {
                                    "userRating": userRating
                                  };
                                  documentReference.update(list).whenComplete(() {
                                    return null;
                                  });
                                }
                                updateRating(documentSnapshot.data()["bookListsTitle"]);
                                
                              },
                              rating: documentSnapshot.data()["userRating"],
                              
                             
  
                                  ),

                    trailing: IconButton(
                      icon: Icon(
                        Icons.delete,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        deleteOtherLists(documentSnapshot["bookListsTitle"]);
                      },
                    ),
                    
                                
                  ),
                  ),
                            );
                          }
                        );
                      },    
                    ),
                 
            
          );
        }
}
