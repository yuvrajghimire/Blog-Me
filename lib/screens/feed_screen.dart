import 'package:blog_me/utils/colors.dart';
import 'package:flutter/material.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  bool switchValue = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        shrinkWrap: true,
        slivers: [
          SliverAppBar(
            // pinned: true,
            // stretch: true,
            // expandedHeight: 200,
            // snap: true,
            floating: true,
            title: Text('BlogMe', style: TextStyle(color: primaryColor)),
            backgroundColor: secondaryColor,
            flexibleSpace: Container(
              height: 200,
              color: secondaryColor,
              child: Column(
                children: [
                  Switch(
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
                ],
              ),
            ),
            actions: [
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.search, color: primaryColor),
              ),
            ],
          ),
          ListViewWidget(),
        ],
      ),
    );
  }
}

class ListViewWidget extends StatelessWidget {
  const ListViewWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, index) {
          return Container(
              color: Colors.white,
              width: 200,
              height: 200,
              margin: EdgeInsets.only(bottom: 10),
              child: Center(child: Text(index.toString())));
        },
        childCount: 20,
      ),
    );
  }
}
