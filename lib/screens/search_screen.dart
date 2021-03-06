import 'package:blog_me/screens/detail_screen.dart';
import 'package:blog_me/screens/profile_screen.dart';
import 'package:blog_me/utils/dimensions.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
// import 'package:blog_me/screens/profile_screen.dart';
import 'package:blog_me/utils/colors.dart';
// import 'package:blog_me/utils/global_variable.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController = TextEditingController();
  bool isShowUsers = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: secondaryColor,
        title: Form(
          child: TextFormField(
            controller: searchController,
            decoration:
                const InputDecoration(labelText: 'Search for a user...'),
            onFieldSubmitted: (String _) {
              setState(() {
                isShowUsers = true;
              });
              // print(_);
            },
          ),
        ),
      ),
      body: isShowUsers
          ? FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .where(
                    'fullName',
                    isEqualTo: searchController.text,
                  )
                  .get(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                // print((snapshot.data! as dynamic).docs.length);
                return ListView.builder(
                  itemCount: (snapshot.data! as dynamic).docs.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ProfileScreen(
                            uid: (snapshot.data! as dynamic).docs[index]['uid'],
                          ),
                        ),
                      ),
                      child: ListTile(
                        // leading: CircleAvatar(
                        //   backgroundImage:
                        //       NetworkImage(
                        //         (snapshot.data! as dynamic).docs[index]['photoUrl'],
                        //       ),
                        //   //     CachedNetworkImageProvider(
                        //   //   'https://wallpapercave.com/wp/CpRGNUC.jpg',
                        //   //   // imageUrl: widget.snap['postUrl'],
                        //   //   // placeholder: (context, url) =>
                        //   //   //  CircularProgressIndicator(),
                        //   //   // errorWidget: (context, url, error) => Icon(Icons.error),
                        //   //   // fit: BoxFit.cover,
                        //   // ),
                        //   radius: 16,
                        // ),
                        title: Text(
                          (snapshot.data! as dynamic).docs[index]['fullName'],
                        ),
                      ),
                    );
                  },
                );
              },
            )
          : FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection('posts')
                  .orderBy('datePublished')
                  .get(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return StaggeredGridView.countBuilder(
                  crossAxisCount: 3,
                  itemCount: (snapshot.data! as dynamic).docs.length,
                  itemBuilder: (context, index) =>
                      // Image.network(
                      //   (snapshot.data! as dynamic).docs[index]['postUrl'],
                      //   fit: BoxFit.cover,
                      // ),
                      GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailPage(
                            postId: (snapshot.data! as dynamic)
                                .docs[index]
                                .data()['postId']
                                .toString(),
                            snap:
                                (snapshot.data! as dynamic).docs[index].data(),
                            index: index,
                          ),
                        ),
                      );
                    },
                    child: Hero(
                      tag: (snapshot.data! as dynamic).docs[index].data(),
                      child: CachedNetworkImage(
                        imageUrl: (snapshot.data! as dynamic).docs[index]
                            ['postUrl'],
                        placeholder: (context, url) => const Center(
                          child: CircularProgressIndicator(color: Colors.grey),
                        ),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  staggeredTileBuilder: (index) => MediaQuery.of(context)
                              .size
                              .width >
                          webScreenSize
                      ? StaggeredTile.count(
                          (index % 7 == 0) ? 1 : 1, (index % 7 == 0) ? 1 : 1)
                      : StaggeredTile.count(
                          (index % 7 == 0) ? 2 : 1, (index % 7 == 0) ? 2 : 1),
                  mainAxisSpacing: 8.0,
                  crossAxisSpacing: 8.0,
                );
              },
            ),
    );
  }
}
