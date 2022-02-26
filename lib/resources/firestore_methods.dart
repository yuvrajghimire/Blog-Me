import 'dart:typed_data';

import 'package:blog_me/models/post.dart';
import 'package:blog_me/resources/storage_methods.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // upload post
  Future<String> uploadPost(
    String uid,
    String title,
    String description,
    String category,
    List tags,
    Uint8List file,
    String userName,
    String fullName,
    String profileImage,
  ) async {
    String res = "Some error occured";
    try {
      String photoUrl =
          await StorageMethods().uploadImageToStorage('post', file, true);

      String postId = const Uuid().v1();

      Post post = Post(
          uid: uid,
          title: title,
          description: description,
          userName: userName,
          fullName: fullName,
          postId: postId,
          datePublished: DateTime.now(),
          postUrl: photoUrl,
          profileImage: profileImage,
          likes: [],
          tags: tags,
          category: category);

      _firestore.collection('posts').doc(postId).set(
            post.toJson(),
          );
      res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
}
