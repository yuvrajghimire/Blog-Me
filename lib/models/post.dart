import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String uid;
  final String title;
  final String description;
  final String userName;
  final String fullName;
  final DateTime datePublished;
  final String postUrl;
  final String postId;
  final String profileImage;
  // ignore: prefer_typing_uninitialized_variables
  final likes;
  final List tags;
  final String category;

  const Post({
    required this.uid,
    required this.title,
    required this.description,
    required this.userName,
    required this.fullName,
    required this.datePublished,
    required this.postUrl,
    required this.postId,
    required this.profileImage,
    required this.likes,
    required this.tags,
    required this.category,
  });

  static Post fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Post(
      uid: snapshot["uid"],
      title: snapshot["title"],
      description: snapshot["description"],
      userName: snapshot["userName"],
      fullName: snapshot["fullName"],
      datePublished: snapshot["datePublished"],
      postUrl: snapshot["postUrl"],
      postId: snapshot["postId"],
      profileImage: snapshot["profileImage"],
      likes: snapshot["likes"],
      tags: snapshot["tags"],
      category: snapshot["category"],
    );
  }

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "title": title,
        "description": description,
        "userName": userName,
        "fullName": fullName,
        "datePublished": datePublished,
        "postUrl": postUrl,
        "postId": postId,
        "profileImage": profileImage,
        "likes": likes,
        "tags": tags,
        "category": category,
      };
}
