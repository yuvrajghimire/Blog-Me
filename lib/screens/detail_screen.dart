import 'package:blog_me/models/user.dart';
import 'package:blog_me/providers/user_provider.dart';
import 'package:blog_me/resources/firestore_methods.dart';
import 'package:blog_me/utils/colors.dart';
import 'package:blog_me/utils/utils.dart';
import 'package:blog_me/utils/variables_constants.dart';
import 'package:blog_me/widgets/comment_card.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DetailPage extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final snap;
  // ignore: prefer_typing_uninitialized_variables
  final postId;
  // ignore: prefer_typing_uninitialized_variables
  final index;
  const DetailPage(
      {Key? key, required this.postId, required this.snap, required this.index})
      : super(key: key);

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final TextEditingController _commentController = TextEditingController();
  bool isLikeAnimating = false;

  @override
  void dispose() {
    super.dispose();
    _commentController.dispose();
  }

  void postComment(String uid, String fullName, String profilePic) async {
    try {
      String res = await FirestoreMethods().postComment(
        widget.postId,
        _commentController.text,
        uid,
        fullName,
        profilePic,
      );

      if (res != 'success') {
        showSnackBar(context, res);
      }
      setState(() {
        _commentController.text = "";
      });
    } catch (err) {
      showSnackBar(
        context,
        err.toString(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final User? user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      body: SafeArea(
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          children: [
            Text(
              '${widget.snap['category'] == '' ? 'Uncategorized' : widget.snap['category']}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              widget.snap['title'],
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Published by ${widget.snap['userName']}',
                    style:
                        TextStyle(color: Colors.grey.shade600, fontSize: 14)),
                Text(
                    DateFormat.yMMMd()
                        .format(widget.snap['datePublished'].toDate()),
                    style:
                        TextStyle(color: Colors.grey.shade600, fontSize: 14)),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 280,
              // child: Image.network(
              //   widget.snap['postUrl'],
              // ),
              child: CachedNetworkImage(
                imageUrl: widget.snap['postUrl'],
                // imageUrl: widget.snap['postUrl'],
                placeholder: (context, url) => Image.asset(
                  'assets/images/loading.gif',
                  fit: BoxFit.cover,
                ),
                errorWidget: (context, url, error) => const Icon(Icons.error),
                fit: BoxFit.cover,
              ),
            ),
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('posts')
                  .orderBy(
                    'datePublished',
                    descending: true,
                  )
                  .snapshots(),
              builder: (context,
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            onPressed: () async {
                              await FirestoreMethods().likePost(
                                  snapshot.data!.docs[widget.index]['postId'],
                                  user!.uid,
                                  snapshot.data!.docs[widget.index]['likes']);
                            },
                            icon: snapshot.data!.docs[widget.index]['likes']
                                    .contains(user!.uid)
                                ? const Icon(Icons.thumb_up, size: 22)
                                : const Icon(Icons.thumb_up_outlined, size: 22),
                          ),
                          const SizedBox(width: 5),
                          Text(
                              '${snapshot.data!.docs[widget.index]['likes'].length} likes',
                              style: const TextStyle(
                                  color: primaryColor, fontSize: 12)),
                        ],
                      ),
                      const SizedBox(width: 5),
                      IconButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        onPressed: () {},
                        icon: const Icon(Icons.bookmark_border, size: 22),
                      ),
                      const SizedBox(width: 5),
                      widget.snap['uid'] != user.uid
                          ? const SizedBox()
                          : PopupMenuButton(
                              // initialValue: 2,
                              color: Theme.of(context).scaffoldBackgroundColor,
                              child: const Icon(Icons.more_vert,
                                  size: 19, color: primaryColor),
                              itemBuilder: (popupContext) {
                                return List.generate(
                                  actions.length,
                                  (popupIndex) {
                                    return PopupMenuItem(
                                      textStyle:
                                          const TextStyle(color: primaryColor),
                                      onTap: () async {
                                        if (popupIndex == 0) {
                                          // print('object');
                                          Navigator.of(context).pop();
                                          Future.delayed(
                                              const Duration(seconds: 2), () {
                                            FirestoreMethods().deletePost(
                                              widget.snap['postId'],
                                            );
                                          });
                                        }
                                      },
                                      value: popupIndex,
                                      child: Text(actions[popupIndex],
                                          style: TextStyle(
                                              color: actions[popupIndex] ==
                                                      'Delete'
                                                  ? Colors.red
                                                  : Theme.of(context)
                                                      .primaryColor,
                                              fontSize: 16,
                                              fontFamily: 'Nunito')),
                                    );
                                  },
                                );
                              },
                            )
                    ],
                  ),
                );
              },
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(10)),
              child: Text(widget.snap['description'],
                  style: const TextStyle(fontSize: 14)),
            ),
            const SizedBox(height: 20),
            widget.snap['tags'].length == 0
                ? const SizedBox()
                : Text(
                    'Tags',
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                  ),
            const SizedBox(height: 5),
            widget.snap['tags'].length == 0
                ? const SizedBox()
                : SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: widget.snap['tags']
                          .map<Widget>(
                            (data) => Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 6),
                              margin: const EdgeInsets.only(right: 10),
                              decoration: BoxDecoration(
                                color: primaryColor,
                                border: Border.all(
                                  color: Colors.grey,
                                ),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Text(
                                '#${data.toLowerCase()}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
            const SizedBox(height: 10),
            Divider(
              color: Colors.grey.shade400,
            ),
            const Text(
              'Comments',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: CachedNetworkImageProvider(
                    widget.snap['profileImage'],
                    // imageUrl: widget.snap['postUrl'],
                    // placeholder: (context, url) =>
                    //     CircularProgressIndicator(),
                    // errorWidget: (context, url, error) => Icon(Icons.error),
                    // fit: BoxFit.cover,
                  ),
                  radius: 18,
                  backgroundColor: Colors.grey,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16, right: 8),
                    child: TextField(
                      controller: _commentController,
                      decoration: InputDecoration(
                        hintText: 'Comment as ${user!.userName}',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () async {
                    postComment(user.uid, user.fullName, user.photoUrl);
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                    child: const Text(
                      'Post',
                      style: TextStyle(color: primaryColor),
                    ),
                  ),
                ),
              ],
            ),
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('posts')
                  .doc(widget.postId)
                  .collection('comments')
                  .orderBy(
                    'datePublished',
                    descending: true,
                  )
                  .snapshots(),
              builder: (context,
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const ScrollPhysics(),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (ctx, index) => CommentCard(
                    snap: snapshot.data!.docs[index],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
