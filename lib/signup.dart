import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nex/components/gesture_buttons.dart';
import 'package:nex/components/logo.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);
  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _success = false;
  late String _userEmail;
  late String errormess = "";

  void _signIn() async {
    try {
      final User user = (await _auth.signInWithEmailAndPassword(
              email: _emailController.text, password: _passwordController.text))
          .user as User;
      setState(() {
        _userEmail = user.email.toString();
        Future.delayed(const Duration(milliseconds: 800), () {
          setState(() {
            _emailController.text = "";
            _passwordController.text = "";
          });
          Navigator.of(context).pushNamed('/homepage');
        });
      });
    } catch (e) {
      // Handle Errors here.
      _passwordController.text = "";
      errormess = e.toString();
      int end = errormess.indexOf(']') + 2;
      errormess = errormess.replaceRange(0, end, '');
    }
  }

  void _register() async {
    try {
      final User user = (await _auth.createUserWithEmailAndPassword(
              email: _emailController.text, password: _passwordController.text))
          .user as User;
      setState(() {
        FocusScopeNode currentFocus = FocusScope.of(context);
        currentFocus.unfocus();
        _success = true;
        _userEmail = user.email.toString();
      });
      _signIn();
    } catch (e) {
      setState(() {
        FocusScopeNode currentFocus = FocusScope.of(context);
        currentFocus.unfocus();
        _passwordController.text = "";
        _success = false;
        errormess = e.toString();
        int end = errormess.indexOf(']') + 2;
        errormess = errormess.replaceRange(0, end, '');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Logo(),
              const SizedBox(
                height: 25,
              ),
              Container(
                margin: const EdgeInsets.only(left: 20, right: 20),
                padding: const EdgeInsets.fromLTRB(20, 50, 20, 30),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.blue.shade700,
                        Colors.blue.shade300,
                        Colors.pink.shade300,
                        Colors.pink.shade400
                      ]),
                  borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(40.0),
                      bottomRight: Radius.circular(40.0),
                      topLeft: Radius.circular(40.0),
                      bottomLeft: Radius.circular(40.0)),
                ),
                child: Column(
                  children: [
                    AnimatedTextKit(
                      animatedTexts: [
                        TypewriterAnimatedText(
                          'Sign in',
                          textStyle: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 25.0,
                            letterSpacing: 1.0,
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                          ),
                          speed: const Duration(milliseconds: 300),
                        ),
                      ],
                      totalRepeatCount: 2,
                      repeatForever: false,
                      pause: const Duration(milliseconds: 3000),
                      displayFullTextOnTap: true,
                      stopPauseOnTap: true,
                    ),
                    const SizedBox(
                      height: 35.0,
                    ),
                    TextField(
                      textInputAction: TextInputAction.next,
                      cursorColor: Colors.black,
                      controller: _emailController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.mail_outline,
                          size: 25.0,
                          color: Colors.black,
                        ),
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.white,
                            width: 30.0,
                          ),
                          borderRadius: BorderRadius.circular(35.0),
                        ),
                        labelText: ' Email',
                        fillColor: Colors.blue.shade200,
                        filled: true,
                        labelStyle: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 20.0,
                          letterSpacing: 0.2,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                        hintText: 'username@gmail.com',
                        hintStyle: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 15.0,
                          letterSpacing: 1.0,
                          fontWeight: FontWeight.w400,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    TextField(
                      cursorColor: Colors.black,
                      controller: _passwordController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.lock_outlined,
                          size: 25.0,
                          color: Colors.black,
                        ),
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Colors.white, width: 30.0),
                          borderRadius: BorderRadius.circular(35.0),
                        ),
                        labelText: ' Password',
                        fillColor: Colors.blue.shade200,
                        filled: true,
                        labelStyle: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 20.0,
                          letterSpacing: 0.2,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                      ),
                      obscureText: true,
                      onEditingComplete: _register,
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        _success == true
                            ? 'Successfully signed in as $_userEmail'
                            : errormess,
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 15.0,
                          letterSpacing: 0.2,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    ClickableButton(
                        onTap: () async {
                          _register();
                        },
                        text: "SIGN UP",
                        c: Colors.black),
                    const SizedBox(
                      height: 20.0,
                    ),
                    ClickableButton(
                        onTap: () async {
                          Navigator.of(context).pop();
                        },
                        text: "LOG IN",
                        c: Colors.black),
                    const SizedBox(
                      height: 15.0,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 50,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
