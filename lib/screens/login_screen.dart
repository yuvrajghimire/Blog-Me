import 'package:blog_me/resources/auth.dart';
import 'package:blog_me/responsive/mobile_screen_layout.dart';
import 'package:blog_me/screens/signup_screen.dart';
import 'package:blog_me/utils/colors.dart';
import 'package:blog_me/utils/utils.dart';
import 'package:blog_me/widgets/text_field_input.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/linecons_icons.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
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
              SizedBox(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.14,
                child: Stack(
                  children: [
                    Positioned(
                      top: -10,
                      left: -30,
                      child: Opacity(
                        opacity: 0.3,
                        child: Container(
                          width: MediaQuery.of(context).size.height * 0.12,
                          height: MediaQuery.of(context).size.height * 0.12,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                                MediaQuery.of(context).size.height * 0.12),
                            color: primaryColor,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 10,
                      left: 20,
                      child: Opacity(
                        opacity: 0.3,
                        child: Container(
                          width: MediaQuery.of(context).size.height * 0.12,
                          height: MediaQuery.of(context).size.height * 0.12,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                                MediaQuery.of(context).size.height * 0.12),
                            color: primaryColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 60),
                    // text
                    const Text(
                      'Log in',
                      style:
                          TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
                    ),
                    const Text(
                      "Let's log in to your acoount and roll in to BlogMe!",
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey),
                    ),
                    // logo
                    const SizedBox(height: 40),

                    // const SizedBox(height: 60),
                    // Flexible(child: Container(), flex: 2),
                    Text('Email address',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade600)),
                    const SizedBox(height: 10),
                    // text field for email
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
                    const SizedBox(
                      height: 60,
                    ),
                    // button for login
                    InkWell(
                      child: Container(
                        child: !_isLoading
                            ? const Text('Log in',
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
                        String res = await AuthMethods().loginUser(
                            email: _emailController.text,
                            password: _passwordController.text);
                        setState(() {
                          _isLoading = false;
                        });
                        if (res == 'success') {
                          showSnackBar(context, 'Successful!');
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const MobileScreenLayout()));
                        } else {
                          showSnackBar(context, 'Invalid email or password!');
                        }
                      },
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    // transition to sign up
                    // Flexible(child: Container(), flex: 1),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            child: const Text(
                              'New to MeBlog?',
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 8),
                          ),
                          GestureDetector(
                            onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const SignupScreen(),
                              ),
                            ),
                            child: Container(
                              child: Row(
                                children: const [
                                  Text(
                                    ' Sign up',
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
                    // Flexible(child: Container(), flex: 3),
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
