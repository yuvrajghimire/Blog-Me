import 'package:blog_me/models/user.dart';
import 'package:blog_me/providers/user_provider.dart';
import 'package:blog_me/utils/colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CommentCard extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables
  final snap;
  const CommentCard({Key? key, required this.snap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage:
                // NetworkImage(
                //   snap.data()['profilePic'],
                // ),
                CachedNetworkImageProvider(
              // 'https://wallpapercave.com/wp/CpRGNUC.jpg',
              snap.data()['profilePic'],
              // placeholder: (context, url) =>
              //     CircularProgressIndicator(),
              // errorWidget: (context, url, error) => Icon(Icons.error),
              // fit: BoxFit.cover,
            ),
            radius: 18,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(color: primaryColor),
                      children: [
                        TextSpan(
                            text: snap.data()['fullName'],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            )),
                        TextSpan(
                          text: ' ${snap.data()['text']}',
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      DateFormat.yMMMd().format(
                        snap.data()['datePublished'].toDate(),
                      ),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          snap.data()['uid'] == user.uid
              ? IconButton(
                  icon: const Icon(
                    Icons.delete,
                    size: 16,
                  ),
                  onPressed: () async {
                    // await FirestoreMethods()
                    //     .deleteComment(snap['postId'], user.uid, snap.data());
                  },
                )
              : const SizedBox()
        ],
      ),
    );
  }
}
