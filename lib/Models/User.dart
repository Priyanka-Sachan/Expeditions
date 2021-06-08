import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String uid;
  String username;
  String emailId;
  String imageUrl;

  User(
      {required this.uid,
      required this.username,
      required this.emailId,
      required this.imageUrl});

  static Future<User> getUser(FirebaseFirestore firestore,String uid) async {
    final userData = await firestore.collection("users").doc(uid).get();
    final user = User(
        uid: uid,
        username: userData['username'],
        emailId: userData['email'],
        imageUrl: userData['imageUrl']);
    return user;
  }

}
