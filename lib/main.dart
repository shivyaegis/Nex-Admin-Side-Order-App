import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:nex/components/message_display.dart';
import 'package:nex/full%20list.dart';
import 'package:nex/orders.dart';
import 'package:nex/components/logo.dart';
import 'package:nex/components/gesture_buttons.dart';

import 'cart.dart';
import 'signup.dart';
import 'homepage.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nex',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Welcome To Skull'),
      debugShowCheckedModeBanner: false,
      routes: <String, WidgetBuilder>{
        '/signup': (BuildContext context) => const SignUpPage(),
        '/homepage': (BuildContext context) => const HomePage(),
        '/orders': (BuildContext context) => const Orders(),
        '/cart': (BuildContext context) => const Cart(),
        '/full list': (BuildContext context) => const ViewList(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  int _success = 1;
  String _userEmail = "";
  String txt = "Forgot Password?";
  late String error = '';
  bool obs = true;
  String message = '';

  get prefixIcon => null;

  void _signIn() async {
    try {
      final User user = (await _auth.signInWithEmailAndPassword(
              email: _emailController.text, password: _passwordController.text))
          .user as User;
      setState(() {
        FocusScopeNode currentFocus = FocusScope.of(context);
        currentFocus.unfocus();
        _success = 2;
        message = 'Successfully signed in $_userEmail';
        _userEmail = user.email.toString();
        Future.delayed(const Duration(milliseconds: 800), () {
          setState(() {
            message = "";
            _emailController.text = "";
            _passwordController.text = "";
          });
          homepage();
        });
      });
    } catch (e) {
      // Handle Errors here.
      FocusScopeNode currentFocus = FocusScope.of(context);
      currentFocus.unfocus();
      _passwordController.text = "";
      error = e.toString();
      int end = error.indexOf(']') + 2;
      error = error.replaceRange(0, end, '');
      setState(() {
        _success = 3;
      });
    }
  }

  void homepage() {
    Navigator.of(context).pushNamed('/homepage');
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
              Container(
                margin: const EdgeInsets.only(left: 20, right: 20),
                padding: const EdgeInsets.fromLTRB(20, 50, 20, 30),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.blue.shade300,
                        Colors.blue.shade700,
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
                          'Log in to continue',
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
                      repeatForever: false,
                      totalRepeatCount: 2,
                      pause: const Duration(milliseconds: 3000),
                      displayFullTextOnTap: true,
                      stopPauseOnTap: true,
                    ),
                    const SizedBox(
                      height: 55.0,
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
                      height: 30.0,
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
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              obs = !obs;
                            });
                          },
                          child: Icon(
                            obs
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            size: 25.0,
                            color: Colors.black,
                          ),
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
                      obscureText: obs,
                      onEditingComplete: _signIn,
                    ),
                    const SizedBox(
                      height: 15.0,
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 10, left: 20),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            txt = "Contact admin/owner";
                            Future.delayed(const Duration(milliseconds: 2000),
                                () {
                              setState(() {
                                txt = "Forgot Password?";
                              });
                            });
                          });
                        },
                        child: Text(
                          txt,
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 15.0,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 13,
                    ),
                    MessagePrint(
                        success: _success, message: message, error: error),
                    const SizedBox(
                      height: 20.0,
                    ),
                    ClickableButton(
                        onTap: () {
                          _success = 1;
                          setState(() {
                            message = " . . . . ";
                          });
                          _signIn();
                        },
                        text: "LOG IN",
                        c: Colors.black),
                    const SizedBox(
                      height: 20.0,
                    ),
                    ClickableButton(
                        onTap: () async {
                          Navigator.of(context).pushNamed('/signup');
                        },
                        text: "SIGN UP",
                        c: Colors.black),
                    const SizedBox(
                      height: 10.0,
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
