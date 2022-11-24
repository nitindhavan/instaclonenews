import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String email;
  String uid;
  String photoUrl;
  String username;
  String bio;
  String phone;
  List followers;
  List following;
  String address;

  User(
      {required this.username,
      required this.uid,
      required this.photoUrl,
      required this.email,
      required this.bio,
      required this.phone,
      required this.address,
      required this.followers,
      required this.following});

  static User fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return User(
      username: snapshot["username"]??'',
      uid: snapshot["uid"]??'',
      address: snapshot["address"]??'',
      phone: snapshot["phone"]??'',
      email: snapshot["email"]??'',
      photoUrl: snapshot["photoUrl"]??'',
      bio: snapshot["bio"]??'',
      followers: snapshot["followers"]??[],
      following: snapshot["following"]??[],
    );
  }

  Map<String, dynamic> toJson() => {
        "username": username,
        "uid": uid,
        "email": email,
        "photoUrl": photoUrl,
        "bio": bio,
        "phone": phone,
        "followers": followers,
        "following": following,
        "address":address,
      };
}
