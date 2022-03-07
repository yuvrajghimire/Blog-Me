// import 'package:blog_me/utils/colors.dart';
import 'package:blog_me/utils/colors.dart';
import 'package:blog_me/utils/variables_constants.dart';
import 'package:blog_me/widgets/post_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  bool switchValue = false;
  String _selectedCategory = 'Any';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
        child: ListView(
          shrinkWrap: true,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // logo
                const Text(
                  'BlogMe',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                // switch
                Row(
                  children: [
                    Text('Light Mode'),
                    Switch(
                      value: switchValue,
                      onChanged: (val) {
                        print(val);
                        // if (val = true) {
                        //   setState(() {
                        //     switchValue = true;
                        //   });
                        // }
                        // if (val = false) {
                        //   setState(() {
                        //     switchValue = false;
                        //   });
                        // }
                      },
                    ),
                  ],
                ),
              ],
            ),
            Column(
              children: [
                const Text(
                  'Discover',
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'New Articles',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 20),
                SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: categories
                        .map(
                          (data) => InkWell(
                            onTap: () {
                              setState(() {
                                _selectedCategory = data;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 6),
                              margin: const EdgeInsets.only(right: 10),
                              decoration: BoxDecoration(
                                color: _selectedCategory == data
                                    ? primaryColor
                                    : Colors.transparent,
                                border: Border.all(
                                  color: Colors.grey,
                                ),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Text(
                                data,
                                style: TextStyle(
                                  color: _selectedCategory == data
                                      ? Colors.white
                                      : primaryColor,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
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

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const ScrollPhysics(),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    return _selectedCategory == 'Any'
                        ? PostCard(
                            snap: snapshot.data!.docs[index].data(),
                            index: index)
                        : _selectedCategory ==
                                snapshot.data!.docs[index].data()['category']
                            ? PostCard(
                                snap: snapshot.data!.docs[index].data(),
                                index: index)
                            : const SizedBox();
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
