import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String email;
  final String fullName;
  final String userName;
  final String uid;
  final String bio;
  final String photoUrl;
  final List followers;
  final List following;

  const User({
    required this.email,
    required this.fullName,
    required this.userName,
    required this.uid,
    required this.bio,
    required this.photoUrl,
    required this.followers,
    required this.following,
  });

  static User fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return User(
      email: snapshot["email"],
      fullName: snapshot["fullName"],
      userName: snapshot["userName"],
      uid: snapshot["uid"],
      bio: snapshot["bio"],
      photoUrl: snapshot["photoUrl"],
      followers: snapshot["followers"],
      following: snapshot["following"],
    );
  }

  Map<String, dynamic> toJson() => {
        "email": email,
        "fullName": fullName,
        "userName": userName,
        "uid": uid,
        "bio": bio,
        "photoUrl": photoUrl,
        "followers": followers,
        "following": following,
      };
//   static User fromSnap(DocumentSnapshot snap) {
//     var snapshot = snap.data() as Map<String, dynamic>;

//     return User(
//       email: snapshot['email'],
//       fullName: snapshot['fullName'],
//       userName: snapshot['userName'],
//       uid: snapshot['uid'],
//       bio: snapshot['bio'],
//       photoUrl: snapshot['photoUrl'],
//       followers: snapshot['followers'],
//       following: snapshot['following'],
//     );
//   }
}
