import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:nex_1/orders.dart';
import 'package:screen/screen.dart';


import 'cart.dart';
import 'signup.dart';
import 'homepage.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;


void main() async{
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
      home: const MyHomePage(title: 'Welcome To Nex'),
      debugShowCheckedModeBanner: false,
      routes: <String, WidgetBuilder>{
        '/signup' : (BuildContext context) => const SignUpPage(),
        '/homepage' : (BuildContext context) => const HomePage(),
        '/orders' : (BuildContext context) => const Orders(),
        '/cart' : (BuildContext context) => const Cart(),
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


  void _signIn() async{
    try {
      final User user = (await
      _auth.signInWithEmailAndPassword(
          email: _emailController.text, password: _passwordController.text))
          .user as User;
      setState(() {
        _success = 2;
        message= 'Successfully signed in ' + _userEmail;
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
    }
    catch(e) {
      // Handle Errors here.
      _passwordController.text = "";
      error = e.toString();
      int end = error.indexOf(']')+2;
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
    Screen.keepOn(true);
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if(!currentFocus.hasPrimaryFocus){
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,

        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                color: Colors.white,
                padding: const EdgeInsets.fromLTRB(10, 90, 10, 20),
                child: const Center(
                  child: Image(
                    image: AssetImage('images/logo.jpg'),
                    height: 80.0,
                  ),
                ),
              ),
              const SizedBox(height: 15,),
              Container(
                margin: const EdgeInsets.only(left: 20, right: 20),
                padding: const EdgeInsets.fromLTRB(20, 50, 20, 30),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.blue.shade300, Colors.blue.shade700, Colors.pink.shade400]),
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
                          speed: const Duration(milliseconds: 500),
                        ),
                      ],

                      repeatForever: false,
                      totalRepeatCount: 2,
                      pause: const Duration(milliseconds: 3000),
                      displayFullTextOnTap: true,
                      stopPauseOnTap: true,
                    ),
                    const SizedBox(height: 55.0,),
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
                          borderSide: const BorderSide(color: Colors.white, width: 30.0,),
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
                    const SizedBox(height: 30.0,),
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
                                ?  Icons.visibility_off_outlined
                                :  Icons.visibility_outlined,
                            size: 25.0,
                            color: Colors.black,

                          ),
                        ),
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.white, width: 30.0),
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
                    ),
                    const SizedBox(height: 15.0,),
                    Container(
                      padding: const EdgeInsets.only(top: 10, left: 20),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            txt = "Contact admin/owner";
                            Future.delayed(const Duration(milliseconds: 2000), () {
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
                    const SizedBox(height: 13,),
                    Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        _success == 1
                            ? message
                            : (
                            _success == 2
                                ? message
                                : error),
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 15.0,
                          letterSpacing: 0.2,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),

                    ),
                    const SizedBox(height: 20.0,),
                    GestureDetector(
                      onTap: () {
                        _success =1;
                        setState(() {
                          message = " . . . . ";
                        });
                        _signIn();
                      },
                      child: SizedBox(
                        height: 45.0,
                        child: Material(
                          borderRadius: BorderRadius.circular(20.0),
                          shadowColor: Colors.black,
                          color: Colors.black,
                          elevation: 10,
                          child: const Center(
                            child: Text(
                              'LOG IN',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 15.0,
                                letterSpacing: 0.2,
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20.0,),
                    GestureDetector(
                      onTap: () async{
                        Navigator.of(context).pushNamed('/signup');
                      },
                      child: SizedBox(
                        height: 45.0,
                        child: Material(
                          borderRadius: BorderRadius.circular(20.0),
                          shadowColor: Colors.black,
                          color: Colors.black,
                          elevation: 10,
                          child: const Center(
                            child: Text(
                              'SIGN UP',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 15.0,
                                letterSpacing: 0.2,
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10.0,),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

