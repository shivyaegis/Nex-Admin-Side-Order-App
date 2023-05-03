import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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

  void _register() async {
    try{
      final User user = (
          await _auth.createUserWithEmailAndPassword(email: _emailController.text, password: _passwordController.text)
      ).user as User;
      setState(() {
        _success = true;
        _userEmail = user.email.toString();
      });

    }catch(e){
      setState(() {
        _passwordController.text = "";
        _success = false;
        setState(() {
          errormess = e.toString();
          int end = errormess.indexOf(']')+2;
          errormess = errormess.replaceRange(0, end, '');
        });
      });

    }

  }

  @override
  Widget build(BuildContext context) {
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
              const SizedBox(height: 35,),
              Container(
                margin: const EdgeInsets.only(left: 20, right: 20),
                padding: const EdgeInsets.fromLTRB(20, 50, 20, 30),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.blue.shade700, Colors.blue.shade300, Colors.pink.shade300, Colors.pink.shade400]),
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
                          speed: const Duration(milliseconds: 500),
                        ),
                      ],

                      totalRepeatCount: 2,
                      repeatForever: false,
                      pause: const Duration(milliseconds: 3000),
                      displayFullTextOnTap: true,
                      stopPauseOnTap: true,
                    ),
                    const SizedBox(height: 35.0,),
                    TextField(
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
                    const SizedBox(height: 20.0,),
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
                      obscureText: true,
                    ),

                    const SizedBox(height: 20.0,),

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
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),

                    const SizedBox(height: 10.0,),

                    GestureDetector(
                      onTap: () async{
                        _register();
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
                    const SizedBox(height: 20.0,),
                    GestureDetector(
                      onTap: () async{
                        Navigator.of(context).pop();
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
                              'GO BACK',
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
                    const SizedBox(height: 15.0,),
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