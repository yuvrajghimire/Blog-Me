import 'package:blog_me/resources/auth.dart';
import 'package:blog_me/resources/firestore_methods.dart';
import 'package:blog_me/screens/detail_screen.dart';
import 'package:blog_me/screens/follow_screen.dart';
import 'package:blog_me/screens/login_screen.dart';
import 'package:blog_me/utils/colors.dart';
import 'package:blog_me/widgets/follow_button.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;
  const ProfileScreen({Key? key, required this.uid}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
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
    getData();
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

      // get post lENGTH
      var postSnap = await FirebaseFirestore.instance
          .collection('posts')
          .where('uid', isEqualTo: widget.uid)
          .get();
      postLen = postSnap.docs.length;
      userData = userSnap.data()!;
      followers = userSnap.data()!['followers'].length;
      following = userSnap.data()!['following'].length;
      isFollowing = userSnap
          .data()!['followers']
          .contains(FirebaseAuth.instance.currentUser!.uid);
      setState(() {});
    } catch (e) {
      // showSnackBar(
      //   context,
      //   e.toString(),
      // );
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(child: CircularProgressIndicator(color: primaryColor))
        : Scaffold(
            body: ListView(
              children: [
                Column(
                  children: [
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CircleAvatar(
                                    backgroundImage: CachedNetworkImageProvider(
                                        userData['photoUrl']),
                                    radius: 40,
                                    backgroundColor: Colors.grey,
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    '${userData['fullName']} (${userData['userName']})',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 18),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          FirebaseAuth.instance.currentUser!.uid == widget.uid
                              ? Expanded(
                                  child: FollowButton(
                                    text: 'Sign Out',
                                    backgroundColor: primaryColor,
                                    textColor: Colors.white,
                                    borderColor: Colors.black,
                                    function: () async {
                                      await AuthMethods().signOut();
                                      Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const LoginScreen(),
                                        ),
                                      );
                                    },
                                  ),
                                )
                              : isFollowing
                                  ? Expanded(
                                      child: FollowButton(
                                        text: 'Unfollow',
                                        backgroundColor: Colors.white,
                                        textColor: primaryColor,
                                        borderColor: primaryColor,
                                        function: () async {
                                          await FirestoreMethods().followUser(
                                            FirebaseAuth
                                                .instance.currentUser!.uid,
                                            userData['uid'],
                                          );

                                          setState(() {
                                            isFollowing = false;
                                            followers--;
                                          });
                                        },
                                      ),
                                    )
                                  : Expanded(
                                      child: FollowButton(
                                        text: 'Follow',
                                        backgroundColor: primaryColor,
                                        textColor: Colors.white,
                                        borderColor: Colors.black,
                                        function: () async {
                                          await FirestoreMethods().followUser(
                                            FirebaseAuth
                                                .instance.currentUser!.uid,
                                            userData['uid'],
                                          );
                                          setState(() {
                                            isFollowing = true;
                                            followers++;
                                          });
                                        },
                                      ),
                                    ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    (userData['bio'] == null || userData['bio'] == '')
                        ? const SizedBox()
                        : Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 20.0),
                              child: Text(
                                userData['bio'].toString(),
                                style: const TextStyle(),
                              ),
                            ),
                          ),
                    (userData['bio'] == null || userData['bio'] == '')
                        ? const SizedBox()
                        : const SizedBox(height: 10),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      // mainAxisSize: MainAxisSize.min,
                      children: [
                        buildStatColumn(postLen, 'posts', 0),
                        buildStatColumn(followers, 'followers', 1),
                        buildStatColumn(following, 'following', 2),
                      ],
                    ),
                  ],
                ),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: FutureBuilder(
                    future: FirebaseFirestore.instance
                        .collection('posts')
                        .where('uid', isEqualTo: widget.uid)
                        .get(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const ScrollPhysics(),
                        itemCount: (snapshot.data! as dynamic).docs.length,
                        itemBuilder: (context, index) {
                          DocumentSnapshot snap =
                              (snapshot.data! as dynamic).docs[index];
                          return Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: secondaryColor,
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey
                                      .withOpacity(0.5), //color of shadow
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            margin: const EdgeInsets.only(bottom: 10),
                            child: Column(
                              children: [
                                SizedBox(
                                  width: double.infinity,
                                  height: 200,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(15.0),
                                    child: CachedNetworkImage(
                                      // imageUrl:
                                      //     'https://asia.olympus-imaging.com/content/000090033.jpg',
                                      imageUrl: snap['postUrl'],
                                      placeholder: (context, url) =>
                                          Image.asset(
                                        'assets/images/loading.gif',
                                        fit: BoxFit.cover,
                                      ),
                                      errorWidget: (context, url, error) =>
                                          const Icon(Icons.error),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      snap['title'],
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8.0),
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            '${snap['description'].length > 80 ? snap['description'].substring(0, 80) + '...' : snap['description']}',
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => DetailPage(
                                              postId: snap['postId'].toString(),
                                              snap: snap,
                                              index: index,
                                            ),
                                          ),
                                        );
                                      },
                                      child: const Text('See more',
                                          style:
                                              TextStyle(color: Colors.white)),
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  primaryColor)),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          );
                          // SizedBox(
                          //   child: ClipRRect(
                          //     borderRadius: BorderRadius.circular(5),
                          //     child: Image(
                          //       // image: CachedNetworkImageProvider(
                          //       //   'https://1.bp.blogspot.com/-33yWnmi1pDs/UQfUtNjwhOI/AAAAAAAAg08/xzu7cauygLY/s1600/TatraPhotographylake2534671.jpg',
                          //       // ),
                          //       image: NetworkImage(snap['postUrl']),
                          //       fit: BoxFit.cover,
                          //     ),
                          //   ),
                          // );
                        },
                      );
                    },
                  ),
                )
              ],
            ),
          );
  }

  GestureDetector buildStatColumn(int num, String label, int index) {
    return GestureDetector(
      onTap: () {
        if (index > 0) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => FollowScreen(
                      uid: FirebaseAuth.instance.currentUser!.uid,
                      userSnap: userSnap,
                      follow: index == 1 ? 'Followers' : 'Following')));
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            num.toString(),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
