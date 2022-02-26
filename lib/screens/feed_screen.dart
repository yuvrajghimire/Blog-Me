// import 'package:blog_me/utils/colors.dart';
import 'package:blog_me/utils/colors.dart';
import 'package:blog_me/utils/variables_constants.dart';
import 'package:blog_me/widgets/post_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

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
              children: [
                // logo
                const Expanded(
                  child: Text(
                    'BlogMe',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                // switch
                Expanded(
                  child: Switch(
                    value: switchValue,
                    onChanged: (val) {
                      if (val = false) {
                        setState(() {
                          switchValue = true;
                        });
                      } else {
                        setState(() {
                          switchValue = false;
                        });
                      }
                    },
                  ),
                ),
                // search
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () {},
                    ),
                  ),
                ),
              ],
            ),
            Column(
              children: [
                const Text(
                  'Discover',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'New Articles',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 20),
                SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
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
                                  fontSize: 14,
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
              stream:
                  FirebaseFirestore.instance.collection('posts').snapshots(),
              builder: (context,
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: ScrollPhysics(),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    return PostCard(snap: snapshot.data!.docs[index].data());
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
