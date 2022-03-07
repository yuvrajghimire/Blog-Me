import 'package:blog_me/screens/profile_screen.dart';
import 'package:blog_me/utils/colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FollowScreen extends StatefulWidget {
  final String uid;
  // ignore: prefer_typing_uninitialized_variables
  final userSnap;
  final String follow;
  const FollowScreen(
      {Key? key,
      required this.uid,
      required this.userSnap,
      required this.follow})
      : super(key: key);

  @override
  _FollowScreenState createState() => _FollowScreenState();
}

class _FollowScreenState extends State<FollowScreen> {
  var userData = {};
  int postLen = 0;
  int followers = 0;
  int following = 0;
  bool isFollowing = false;
  bool isLoading = false;
  late DocumentSnapshot<Map<String, dynamic>> userSnap;
  @override
  void initState() {
    super.initState();
  }

  getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();
      userData = userSnap.data()!;
      isFollowing = userSnap
          .data()!['followers']
          .contains(FirebaseAuth.instance.currentUser!.uid);
    } catch (e) {
      //
    }
    setState(() {
      isLoading = false;
    });
  }

  // bool isFollowing = false;

  @override
  Widget build(BuildContext context) {
    userData = widget.userSnap.data()!;
    // print(widget.userSnap.data()![widget.follow.toLowerCase()].length);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text(widget.follow),
      ),
      body: ListView.builder(
        // itemCount: 1,
        itemCount: widget.userSnap.data()![widget.follow.toLowerCase()].length,
        itemBuilder: (context, listIndex) {
          // print((snapshot.data! as dynamic).docs[index].data());
          // print((snapshot.data! as dynamic).docs);
          return FutureBuilder(
            future: FirebaseFirestore.instance
                .collection('users')
                .where(
                  'uid',
                  isEqualTo: userData[widget.follow.toLowerCase()][listIndex],
                )
                .get(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                // print((snapshot.data! as dynamic).docs[index]['fullName']);
                return InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ProfileScreen(
                          uid: (snapshot.data! as dynamic).docs[0]['uid'],
                        ),
                      ),
                    );
                  },
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: CachedNetworkImageProvider(
                        (snapshot.data! as dynamic).docs[0]['photoUrl'],
                      ),
                      backgroundColor: Colors.grey,
                      radius: 16,
                    ),
                    title: Text(
                      (snapshot.data! as dynamic).docs[0]['fullName'],
                    ),
                    subtitle: Text(
                      (snapshot.data! as dynamic).docs[0]['userName'],
                    ),
                    // trailing: isFollowing
                    //     ? FollowButton(
                    //         text: 'Unfollow',
                    //         backgroundColor: Colors.white,
                    //         textColor: primaryColor,
                    //         borderColor: primaryColor,
                    //         function: () async {
                    //           await FirestoreMethods().followUser(
                    //             FirebaseAuth.instance.currentUser!.uid,
                    //             userData['uid'],
                    //           );
                    //           setState(() {
                    //             isFollowing = false;
                    //           });
                    //         },
                    //       )
                    //     : FollowButton(
                    //         text: 'Follow',
                    //         backgroundColor: primaryColor,
                    //         textColor: Colors.white,
                    //         borderColor: Colors.black,
                    //         function: () async {
                    //           await FirestoreMethods().followUser(
                    //             FirebaseAuth.instance.currentUser!.uid,
                    //             userData['uid'],
                    //           );
                    //           setState(() {
                    //             isFollowing = true;
                    //           });
                    //         },
                    //       ),
                  ),
                );
              }
            },
          );
        },
      ),
      // FutureBuilder(
      //   future: FirebaseFirestore.instance
      //       .collection('users')
      //       .doc(widget.uid)
      //       .get(),
      //   builder: (context, snapshot) {
      //     if (!snapshot.hasData) {
      //       return const Center(
      //         child: CircularProgressIndicator(),
      //       );
      //     }
      //     return ListView.builder(
      //       itemCount: widget.userSnap
      //           .data()!['${widget.follow.toLowerCase()}']
      //           .length,
      //       itemBuilder: (context, index) {
      //         // print((snapshot.data! as dynamic).docs[index].data());
      //         // print((snapshot.data! as dynamic).docs);
      //         return Container();
      //         // InkWell(
      //         //   onTap: () => Navigator.of(context).push(
      //         //     MaterialPageRoute(
      //         //       builder: (context) => ProfileScreen(
      //         //         uid: (snapshot.data! as dynamic).docs[index]['uid'],
      //         //       ),
      //         //     ),
      //         //   ),
      //         //   child: ListTile(
      //         //     leading: const CircleAvatar(
      //         //       backgroundImage:
      //         //           // NetworkImage(
      //         //           //   (snapshot.data! as dynamic).docs[index]['photoUrl'],
      //         //           // ),
      //         //           CachedNetworkImageProvider(
      //         //         'https://wallpapercave.com/wp/CpRGNUC.jpg',
      //         //         // imageUrl: widget.snap['postUrl'],
      //         //         // placeholder: (context, url) =>
      //         //         //     CircularProgressIndicator(),
      //         //         // errorWidget: (context, url, error) => Icon(Icons.error),
      //         //         // fit: BoxFit.cover,
      //         //       ),
      //         //       radius: 16,
      //         //     ),
      //         //     title: Text(
      //         //       (snapshot.data! as dynamic).docs[index]['fullName'],
      //         //     ),
      //         //     subtitle: Text(
      //         //       (snapshot.data! as dynamic).docs[index]['userName'],
      //         //     ),
      //         //     // trailing: isFollowing
      //         //     //     ? FollowButton(
      //         //     //         text: 'Unfollow',
      //         //     //         backgroundColor: Colors.white,
      //         //     //         textColor: primaryColor,
      //         //     //         borderColor: primaryColor,
      //         //     //         function: () async {
      //         //     //           await FirestoreMethods().followUser(
      //         //     //             FirebaseAuth.instance.currentUser!.uid,
      //         //     //             userData['uid'],
      //         //     //           );
      //         //     //           setState(() {
      //         //     //             isFollowing = false;
      //         //     //           });
      //         //     //         },
      //         //     //       )
      //         //     //     : FollowButton(
      //         //     //         text: 'Follow',
      //         //     //         backgroundColor: primaryColor,
      //         //     //         textColor: Colors.white,
      //         //     //         borderColor: Colors.black,
      //         //     //         function: () async {
      //         //     //           await FirestoreMethods().followUser(
      //         //     //             FirebaseAuth.instance.currentUser!.uid,
      //         //     //             userData['uid'],
      //         //     //           );
      //         //     //           setState(() {
      //         //     //             isFollowing = true;
      //         //     //           });
      //         //     //         },
      //         //     //       ),
      //         //   ),
      //         // );
      //       },
      //     );
      //   },
      // ),
    );
  }
}
