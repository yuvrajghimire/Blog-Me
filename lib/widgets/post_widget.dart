import 'package:blog_me/models/user.dart';
import 'package:blog_me/providers/user_provider.dart';
import 'package:blog_me/resources/firestore_methods.dart';
import 'package:blog_me/screens/detail_screen.dart';
import 'package:blog_me/utils/colors.dart';
import 'package:blog_me/utils/variables_constants.dart';
import 'package:blog_me/widgets/like_animation.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PostCard extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final snap;
  const PostCard({Key? key, required this.snap}) : super(key: key);

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool isLikeAnimating = false;

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<UserProvider>(context).getUser;
    return user == null
        ? SizedBox()
        : GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DetailPage(
                          postId: widget.snap['postId'].toString(),
                          snap: widget.snap)));
            },
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(10),
              ),
              margin: const EdgeInsets.only(bottom: 10),
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: 200,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15.0),
                          child: CachedNetworkImage(
                            imageUrl: widget.snap['postUrl'],
                            placeholder: (context, url) => Image.asset(
                              'assets/images/loading.gif',
                              fit: BoxFit.cover,
                            ),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      AnimatedOpacity(
                        duration: const Duration(milliseconds: 200),
                        opacity: isLikeAnimating ? 1 : 0,
                        child: LikeAnimation(
                            child: const Icon(Icons.thumb_up,
                                color: Colors.white, size: 100),
                            isAnimating: isLikeAnimating,
                            duration: const Duration(milliseconds: 400),
                            onEnd: () {
                              setState(() {
                                isLikeAnimating = false;
                              });
                            }),
                      )
                    ],
                  ),
                  const SizedBox(height: 5),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      widget.snap['title'],
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            '${widget.snap['fullName']} • ${DateFormat.yMMMd().format(widget.snap['datePublished'].toDate())}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade700,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          LikeAnimation(
                            isAnimating:
                                widget.snap['likes'].contains(user.uid),
                            smallLike: true,
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              onPressed: () async {
                                await FirestoreMethods().likePost(
                                    widget.snap['postId'],
                                    user.uid,
                                    widget.snap['likes']);
                                if (widget.snap['likes'].contains(user.uid)) {
                                  setState(() {
                                    isLikeAnimating = true;
                                  });
                                }
                              },
                              icon: widget.snap['likes'].contains(user.uid)
                                  ? const Icon(Icons.thumb_up, size: 22)
                                  : const Icon(Icons.thumb_up_outlined,
                                      size: 22),
                            ),
                          ),
                          const SizedBox(width: 5),
                          Text('${widget.snap['likes'].length} likes',
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
                      PopupMenuButton(
                        // initialValue: 2,
                        color: Theme.of(context).scaffoldBackgroundColor,
                        child: Icon(Icons.more_vert,
                            size: 19, color: Theme.of(context).primaryColor),
                        itemBuilder: (popupContext) {
                          return List.generate(
                            actions.length,
                            (popupIndex) {
                              return PopupMenuItem(
                                onTap: () async {
                                  // if (popupIndex == 0) {
                                  //   Future.delayed(
                                  //       const Duration(seconds: 0),
                                  //       () => Navigator.pushNamed(context, 'edit',
                                  //           arguments: {'urlIndex': index}));
                                  // } else if (popupIndex == 1) {
                                  //   Clipboard.setData(ClipboardData(
                                  //       text: "${urlData.urls[index].url}"));
                                  //   ScaffoldMessenger.of(context)
                                  //       .showSnackBar(snackBarCopyClipboard(context));
                                  // } else if (popupIndex == 2) {
                                  //   Share.share(urlData.urls[index].url!);
                                  // } else if (popupIndex == 3) {
                                  //   try {
                                  //     await launch(urlData.urls[index].url!);
                                  //   } catch (e) {
                                  //     ScaffoldMessenger.of(context)
                                  //         .showSnackBar(snackBarInvalidUrl(context));
                                  //   }
                                  // } else {
                                  //   Future.delayed(
                                  //     const Duration(seconds: 0),
                                  //     () => showDialog(
                                  //       context: context,
                                  //       builder: (BuildContext context) {
                                  //         return alertDialog(context, index);
                                  //       },
                                  //     ),
                                  //   );
                                  // }
                                  if (popupIndex == 4) {
                                    // print('object');
                                    FirestoreMethods()
                                        .deletePost(widget.snap['postId']);
                                  }
                                },
                                value: popupIndex,
                                child: Text(actions[popupIndex],
                                    style: TextStyle(
                                        color: actions[popupIndex] == 'Delete'
                                            ? Colors.red
                                            : Theme.of(context).primaryColor,
                                        fontSize: 16,
                                        fontFamily: 'Nunito')),
                              );
                            },
                          );
                        },
                      )
                    ],
                  ),
                ],
              ),
            ),
          );
  }
}
