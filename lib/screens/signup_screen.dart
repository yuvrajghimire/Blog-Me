import 'dart:typed_data';

import 'package:blog_me/resources/auth.dart';
import 'package:blog_me/responsive/mobile_screen_layout.dart';
import 'package:blog_me/responsive/reponsive_layout_screen.dart';
import 'package:blog_me/responsive/web_screen_layout.dart';
import 'package:blog_me/screens/login_screen.dart';
import 'package:blog_me/utils/colors.dart';
import 'package:blog_me/utils/utils.dart';
import 'package:blog_me/widgets/text_field_input.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/linecons_icons.dart';
import 'package:image_picker/image_picker.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();
  bool _isLoading = false;
  Uint8List? _image;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _userNameController.dispose();
  }

  selectImage() async {
    dynamic im = await pickImage(ImageSource.gallery);
    // set state because we need to display the image we selected on the circle avatar
    setState(() {
      _image = im;
    });
  }

  signUp() async {
    String res = await AuthMethods().signUpUser(
      email: _emailController.text,
      password: _passwordController.text,
      fullName: _nameController.text,
      userName: _userNameController.text,
      file: _image!,
    );
    if (res == 'success') {
      showSnackBar(context, res);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // logo
              // SizedBox(
              //   width: double.infinity,
              //   height: MediaQuery.of(context).size.height * 0.08,
              //   child: Stack(
              //     children: [
              //       Positioned(
              //         top: -10,
              //         left: -30,
              //         child: Opacity(
              //           opacity: 0.3,
              //           child: Container(
              //             width: MediaQuery.of(context).size.height * 0.08,
              //             height: MediaQuery.of(context).size.height * 0.08,
              //             decoration: BoxDecoration(
              //               borderRadius: BorderRadius.circular(
              //                   MediaQuery.of(context).size.height * 0.08),
              //               color: primaryColor,
              //             ),
              //           ),
              //         ),
              //       ),
              //       Positioned(
              //         top: -10,
              //         left: 10,
              //         child: Opacity(
              //           opacity: 0.3,
              //           child: Container(
              //             width: MediaQuery.of(context).size.height * 0.08,
              //             height: MediaQuery.of(context).size.height * 0.08,
              //             decoration: BoxDecoration(
              //               borderRadius: BorderRadius.circular(
              //                   MediaQuery.of(context).size.height * 0.08),
              //               color: primaryColor,
              //             ),
              //           ),
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              const SizedBox(height: 25),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // text
                    const Text(
                      'Sign Up',
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                    const Text(
                      "It's never late to join MeBLOG, we welcome you!",
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        _image != null
                            ? CircleAvatar(
                                radius: 30,
                                backgroundImage: MemoryImage(_image!),
                                backgroundColor: Colors.white,
                              )
                            : CircleAvatar(
                                radius: 30,
                                backgroundImage:
                                    const AssetImage('assets/images/user.png'),
                                backgroundColor: Colors.grey.shade200,
                              ),
                        IconButton(
                          onPressed: selectImage,
                          icon: const Icon(Icons.add_a_photo,
                              color: primaryColor, size: 20),
                        )
                      ],
                    ),
                    const SizedBox(height: 10),
                    // text field for full name
                    Text('Full name',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade600)),
                    const SizedBox(height: 10),
                    TextFieldInput(
                        textEditingController: _nameController,
                        textInputType: TextInputType.text,
                        hintText: 'Full Name',
                        icon: const Icon(Linecons.user,
                            size: 20, color: primaryColor)),
                    const SizedBox(height: 24),
                    Text('Username',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade600)),
                    const SizedBox(height: 10),
                    TextFieldInput(
                        textEditingController: _userNameController,
                        textInputType: TextInputType.text,
                        hintText: 'Username',
                        icon: const Icon(Linecons.user,
                            size: 20, color: primaryColor)),
                    const SizedBox(height: 24),
                    // text field for email
                    Text('Email address',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade600)),
                    const SizedBox(height: 10),
                    TextFieldInput(
                        textEditingController: _emailController,
                        textInputType: TextInputType.emailAddress,
                        hintText: 'Email',
                        icon: const Icon(Linecons.mail,
                            size: 20, color: primaryColor)),
                    const SizedBox(height: 24),
                    // text field for password
                    Text('Password',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade600)),
                    const SizedBox(height: 10),
                    TextFieldInput(
                        textEditingController: _passwordController,
                        textInputType: TextInputType.text,
                        hintText: 'Password',
                        isPass: true,
                        icon: const Icon(Linecons.lock,
                            size: 20, color: primaryColor)),
                    const SizedBox(height: 24),
                    // text field for password
                    Text('Confim Password',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade600)),
                    const SizedBox(height: 10),
                    TextFieldInput(
                        textEditingController: _passwordController,
                        textInputType: TextInputType.text,
                        hintText: 'Password',
                        isPass: true,
                        icon: const Icon(Linecons.lock,
                            size: 20, color: primaryColor)),
                    const SizedBox(
                      height: 24,
                    ),
                    // button for login
                    InkWell(
                      child: Container(
                        child: !_isLoading
                            ? const Text('Sign Up',
                                style: TextStyle(color: secondaryColor))
                            : const CircularProgressIndicator(
                                color: secondaryColor,
                              ),
                        width: double.infinity,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: const ShapeDecoration(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                          ),
                          color: primaryColor,
                        ),
                      ),
                      onTap: () async {
                        setState(() {
                          _isLoading = true;
                        });
                        String res = await AuthMethods().signUpUser(
                          email: _emailController.text,
                          password: _passwordController.text,
                          fullName: _nameController.text,
                          userName: _userNameController.text,
                          file: _image!,
                        );
                        setState(() {
                          _isLoading = false;
                        });
                        if (res == 'success') {
                          showSnackBar(context, res);
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const ResponsiveLayout(
                                  webScreenLayout: WebScreenLayout(),
                                  mobileScreenLayout: MobileScreenLayout())));
                        } else {
                          showSnackBar(context, 'Something went wrong!');
                        }
                      },
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            child: const Text(
                              'Already registered?',
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 8),
                          ),
                          GestureDetector(
                            onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const LoginScreen(),
                              ),
                            ),
                            child: Container(
                              child: Row(
                                children: const [
                                  Text(
                                    ' Log in',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    ' instead.',
                                  ),
                                ],
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 8),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
