import 'package:blog_me/providers/user_provider.dart';
import 'package:blog_me/screens/create_post.dart';
import 'package:blog_me/screens/feed_screen.dart';
import 'package:blog_me/screens/profile_screen.dart';
import 'package:blog_me/screens/search_screen.dart';
import 'package:blog_me/utils/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:blog_me/models/user.dart' as model_user;

class MobileScreenLayout extends StatefulWidget {
  const MobileScreenLayout({Key? key}) : super(key: key);

  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout> {
  int _page = 0;
  late PageController pageController;
  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  void navigationTapped(int page) {
    pageController.jumpToPage(page);
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    final model_user.User? user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: user == null
          ? const Center(child: CircularProgressIndicator(color: primaryColor))
          : SafeArea(
              child: PageView(
                children: [
                  const FeedScreen(),
                  const SearchScreen(),
                  const CreatePost(),
                  ProfileScreen(uid: FirebaseAuth.instance.currentUser!.uid)
                ],
                controller: pageController,
                onPageChanged: onPageChanged,
              ),
            ),
      bottomNavigationBar: BottomNavigationBar(
        selectedIconTheme: const IconThemeData(color: secondaryColor),
        unselectedIconTheme: const IconThemeData(color: Colors.grey),
        currentIndex: _page,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
            backgroundColor: primaryColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
            backgroundColor: primaryColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle),
            label: 'Create Blog',
            backgroundColor: primaryColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
            backgroundColor: primaryColor,
          ),
        ],
        onTap: navigationTapped,
      ),
    );
  }
}
