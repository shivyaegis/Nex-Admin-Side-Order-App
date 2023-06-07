import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:skull/components/logo.dart';

import 'package:skull/orders.dart';

late int cNumber;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DatabaseReference ref = FirebaseDatabase.instance.ref();
  String databaseJSON = '';
  String message = '';
  late int location;
  bool valid = false;
  bool fetch = false;

  final TextEditingController fName = TextEditingController();
  final TextEditingController lName = TextEditingController();
  final TextEditingController cName = TextEditingController();
  final TextEditingController gst = TextEditingController();
  final TextEditingController phNo = TextEditingController();
  final TextEditingController email = TextEditingController();

  //functions start here

  //function to create entry in database
  Future<void> createTable() async {
    try {
      List<String> s = [];
      int i = 1;
      bool exist = true;
      String child = "";
      setState(() {
        message = "Creating entry...";
      });
      while (exist && i < 100) {
        child = i.toString();
        await ref.child("customers").child(child).once().then((event) {
          final dataSnapshot = event.snapshot;

          setState(() {
            databaseJSON = dataSnapshot.value.toString();
          });
          if (databaseJSON == 'null') {
            s.add('null');
            exist = false;
          } else {
            s.add(child);
          }
        });
        i++;
      }
      final int lsNull = s.indexOf('null');
      String childFinal = (lsNull + 1).toString();

      // THIS CODE IS TO CREATE CUSTOMER DETAILS IN TABLE (imp)

      ref.child("customers").child(childFinal).child('details').set({
        "first name ": fName.text,
        "last name ": lName.text,
        "company name": cName.text,
        "gst number": gst.text,
        "phone no": phNo.text,
        "email": email.text,
      });
      setState(() {
        message = "Successfully created customer entry !";
      });
      Future.delayed(const Duration(milliseconds: 2500), () {
        setState(() {
          message = "";
        });
      });
    } catch (e) {
      message = e.toString();
    }
  }

  //function to check if entry valid and move to order page
  void order() {
    setState(() {
      message = 'Checking validity...';
    });
    if (phNo.text != "" &&
        phNo.text != "0" &&
        valid &&
        fName.text != "" &&
        gst.text != "") {
      message = 'Valid entry';
      Future.delayed(const Duration(milliseconds: 500), () {
        Navigator.of(context).pushNamed('/orders');
      });
    } else {
      message = 'Error. Ensure user detail is fetched';
      Future.delayed(const Duration(milliseconds: 2500), () {
        setState(() {
          message = "";
        });
      });
    }
  }

  //function to check if data exists using phone no, if not then create entry in database
  Future<void> isExists() async {
    List<String> s = [];
    int i = 1;
    bool exist = true;
    String child = "";
    message = '. . . . .';
    FocusScopeNode currentFocus = FocusScope.of(context);
    currentFocus.unfocus();
    while (exist && i < 100) {
      child = i.toString();
      await ref.child("customers").child(child).once().then((event) {
        final dataSnapshot = event.snapshot;

        setState(() {
          databaseJSON = dataSnapshot.value.toString();
          message = "Contacting server...";
        });
        if (databaseJSON == 'null') {
          s.add('null');
          exist = false;
        } else {
          s.add(child);
        }
      });
      i++;
    }
    final int lsNull = s.indexOf('null');
    exist = false;

    for (int i = 1; i <= lsNull; i++) {
      //fetching all customer details one by one
      await ref
          .child('customers')
          .child(i.toString())
          .child('details')
          .once()
          .then((event) {
        final dataSnapshot = event.snapshot;
        setState(() {
          databaseJSON = dataSnapshot.value.toString();
          message = "Fetching details...";
        });
      });

      // if phone number exists then fetch details

      if ((databaseJSON.contains(phNo.text) &&
              databaseJSON.contains(gst.text)) ||
          databaseJSON.contains(phNo.text)) {
        int begin = 0;
        int end = 0;
        exist = true;
        var snapshot_ = "";
        ref
            .child('customers')
            .child(i.toString())
            .child('details')
            .once()
            .then((event) {
          setState(() {
            snapshot_ = event.snapshot.value.toString();
            //gets all details

            // setting last name
            begin = snapshot_.indexOf('last name') + 12;
            end = snapshot_.indexOf('phone no') - 2;
            lName.text = snapshot_.substring(begin, end);

            // setting phone number
            begin = snapshot_.indexOf('phone no') + 10;
            end = snapshot_.indexOf('gst') - 2;
            phNo.text = snapshot_.substring(begin, end);

            // setting gst number

            begin = snapshot_.indexOf('gst') + 12;
            end = snapshot_.indexOf('company name') - 2;
            gst.text = snapshot_.substring(begin, end);

            // setting company name

            begin = end + 2 + 14;
            end = snapshot_.indexOf('first name') - 2;
            cName.text = snapshot_.substring(begin, end);

            // setting first name

            begin = end + 2 + 13;
            end = snapshot_.indexOf('email') - 2;
            fName.text = snapshot_.substring(begin, end);

            // setting email

            begin = end + 2 + 7;
            end = snapshot_.indexOf('}');
            email.text = snapshot_.substring(begin, end);
            message =
                "Phone number and gst number exists, customer details imported";
            valid = true;
            cNumber = i;
          });
        });
        break;
      } else {
        continue;
      }
    }

    if (exist == false) {
      if ((fName.text != "" || lName.text != "") &&
          (phNo.text != "" && gst.text != "") &&
          fetch == false) {
        createTable();
        valid = true;
        cNumber = i - 1;
      } else if (fetch == true) {
        setState(() {
          message = "Details not available for this number";
          Future.delayed(const Duration(milliseconds: 2500), () {
            setState(() {
              message = "";
            });
          });
        });
      } else {
        setState(() {
          message = 'Field(s) cannot be empty, record not created';
          Future.delayed(const Duration(milliseconds: 2500), () {
            setState(() {
              message = "";
            });
          });
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    cartList = [];
    <String, WidgetBuilder>{
      '/orders': (BuildContext context) => const Orders(),
    };
    return GestureDetector(
      onTap: () {
        // to hide keyboard when pressed elsewhere
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.black,
          centerTitle: true,
          toolbarOpacity: 1,
          toolbarHeight: 50,
          title: const Text(
            'Customer Details',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 15.0,
              letterSpacing: 0.2,
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 20,
              ),
              Container(
                margin: const EdgeInsets.only(left: 20, right: 20),
                padding: const EdgeInsets.fromLTRB(20, 30, 20, 30),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.blue.shade100,
                        Colors.blue.shade300,
                        Colors.blue.shade500,
                        Colors.blue.shade700,
                        Colors.blue.shade500,
                        Colors.blue.shade300,
                        Colors.blue.shade100,
                        Colors.pink.shade100,
                        Colors.pink.shade300,
                        Colors.pink.shade500,
                        Colors.pink.shade700,
                        Colors.pink.shade900,
                        Colors.grey.shade500,
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
                          'Details',
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
                    const SizedBox(
                      height: 45.0,
                    ),
                    TextField(
                      textInputAction: TextInputAction.next,
                      cursorColor: Colors.black,
                      controller: fName,
                      // controller: _emailController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.account_circle_outlined,
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
                        labelText: ' First Name',
                        fillColor: Colors.transparent,
                        filled: true,
                        labelStyle: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 20.0,
                          letterSpacing: 0.2,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                        hintText: 'first name',
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
                      textInputAction: TextInputAction.next,
                      controller: lName,
                      cursorColor: Colors.black,
                      // controller: _emailController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.account_circle_outlined,
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
                        labelText: ' Last Name',
                        fillColor: Colors.transparent,
                        filled: true,
                        labelStyle: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 20.0,
                          letterSpacing: 0.2,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                        hintText: 'last name',
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
                      textInputAction: TextInputAction.next,
                      controller: cName,
                      cursorColor: Colors.black,
                      // controller: _emailController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.house_siding,
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
                        labelText: ' Company Name',
                        fillColor: Colors.transparent,
                        filled: true,
                        labelStyle: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 20.0,
                          letterSpacing: 0.2,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                        hintText: 'SAIL Pvt Limited',
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
                      textInputAction: TextInputAction.next,
                      controller: gst,
                      cursorColor: Colors.black,
                      // controller: _emailController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.import_contacts_sharp,
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
                        labelText: ' GST number',
                        fillColor: Colors.transparent,
                        filled: true,
                        labelStyle: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 20.0,
                          letterSpacing: 0.2,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                        hintText: '22AAAAA0000A1Z5',
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
                      textInputAction: TextInputAction.next,
                      controller: phNo,
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ], // Only numbers can be entered
                      cursorColor: Colors.black,
                      // controller: _emailController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.phone_outlined,
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
                        labelText: ' Phone no',
                        fillColor: Colors.transparent,
                        filled: true,
                        labelStyle: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 20.0,
                          letterSpacing: 0.2,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                        hintText: '1234567890',
                        hintStyle: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 15.0,
                          letterSpacing: 1.0,
                          fontWeight: FontWeight.w400,
                          color: Colors.black54,
                        ),
                      ),
                      // onEditingComplete: () async {
                      //   setState(() {
                      //     fetch = true;
                      //     message = "...";
                      //   });
                      //   await isExists();
                      //   fetch = false;
                      // },
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    TextField(
                      textInputAction: TextInputAction.done,
                      controller: email,
                      cursorColor: Colors.black,
                      // controller: _emailController,
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
                        fillColor: Colors.transparent,
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
                    Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        message,
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 16.0,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    GestureDetector(
                      //THIS BUTTON PUSHES DATA INTO DATABASE
                      onTap: () {
                        setState(() {
                          message = "...";
                        });
                        isExists();
                      },
                      child: SizedBox(
                        height: 45.0,
                        child: Material(
                          borderRadius: BorderRadius.circular(20.0),
                          shadowColor: Colors.black,
                          color: Colors.blue.shade100,
                          elevation: 10,
                          child: const Center(
                            child: Text(
                              'Register Customer',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 15.0,
                                letterSpacing: 0.2,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    GestureDetector(
                      //THIS BUTTON FETCHES DATA FROM DATABASE
                      onTap: () async {
                        setState(() {
                          fetch = true;
                          message = "...";
                        });
                        await isExists();
                        fetch = false;
                      },
                      child: SizedBox(
                        height: 45.0,
                        child: Material(
                          borderRadius: BorderRadius.circular(20.0),
                          shadowColor: Colors.black,
                          color: Colors.blue.shade300,
                          elevation: 10,
                          child: const Center(
                            child: Text(
                              'Fetch Customer',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 15.0,
                                letterSpacing: 0.2,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    GestureDetector(
                      //THIS BUTTON CLEARS FIELDS
                      onTap: () {
                        phNo.text = "";
                        fName.text = "";
                        lName.text = "";
                        cName.text = "";
                        gst.text = "";
                        email.text = "";
                        setState(() {
                          message = "Fields cleared";
                        });
                      },
                      child: SizedBox(
                        height: 45.0,
                        child: Material(
                          borderRadius: BorderRadius.circular(20.0),
                          shadowColor: Colors.black,
                          color: Colors.blue.shade600,
                          elevation: 10,
                          child: const Center(
                            child: Text(
                              'Clear Fields',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 15.0,
                                letterSpacing: 0.2,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          message = '. . .';
                        });
                        order();
                      },
                      child: SizedBox(
                        height: 45.0,
                        child: Material(
                          borderRadius: BorderRadius.circular(20.0),
                          shadowColor: Colors.black,
                          color: Colors.blue.shade900,
                          elevation: 10,
                          child: const Center(
                            child: Text(
                              'Continue to orders',
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
                  ],
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              const Logo(),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
