import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:nex/components/logo.dart';
import 'package:nex/homepage.dart';

class ViewList extends StatefulWidget {
  const ViewList({Key? key}) : super(key: key);

  @override
  State<ViewList> createState() => _ViewListState();
}

class _ViewListState extends State<ViewList> {
  //initialise database
  final DatabaseReference ref = FirebaseDatabase.instance.ref();
  TextEditingController cid = TextEditingController();
  var list = ["one", "two", "three", "four"];
  List<String> orderHeader = ["Order Header"];

  List<String> orderTrailer = [
    "Your orders will be displayed here\n\nEnter Customer ID to view"
  ];

  Future<void> getOrders(c) async {
    // sendOrder = "Getting orders...";
    String databaseJSON = '';

    orderTrailer = [];
    orderHeader = [];
    await ref
        .child('customers')
        .child(c.toString())
        .child('orders')
        .once()
        .then((event) {
      final dataSnapshot = event.snapshot;
      setState(() {
        databaseJSON = dataSnapshot.value.toString();
        // print(databaseJSON);
        // print("");
      });
      if (databaseJSON == "null") {
        orderTrailer = ["No orders to display :/"];
        orderHeader = ["No orders to display :/"];
      } else if (databaseJSON[1] == "n") {
        List<String> orders = [];
        List<String> temp = databaseJSON.split(", {");
        // print("Going here omg");
        for (int i = 0; i < temp.length; i++) {
          // print("---" * 10);
          // print("Loop number $i");
          // print(temp[i]);
          // print(temp[i][temp[i].length - 1]);
          if (temp[i][0] == "[") {
            // print("here");
          } else if (temp[i][temp[i].length - 1] == "}") {
            // print("here2");
            orders.add(temp[i].substring(0, temp[i].length - 1));
          } else if (temp[i][temp[i].length - 1] == "l") {
            // print("here3");
            orders.add(temp[i].substring(0, temp[i].indexOf("}")));
          } else if (temp[i][temp[i].length - 1] == "]") {
            // print("here4");
            orders.add(temp[i].substring(0, temp[i].length - 2));
          }
        }
        // print("---" * 10);
        // print(orders);
        // print(orders.length);

        for (int i = 0; i < orders.length; i++) {
          orderHeader.add(
              "${orders[i].substring(orders[i].indexOf("Order Date:"), orders[i].length)}\n");
          orderTrailer.add(
              "${orders[i].substring(0, orders[i].indexOf("Order Date:") - 2)}\n");
        }
        // print(orderHeader);
        // print(orderTrailer);
      } else {
        List<String> orders = [];
        List<String> temp = databaseJSON.split(": {");
        for (int i = 0; i < temp.length; i++) {
          // print("Loop number $i");
          // print(temp[i]);
          // print(temp[i][temp[i].length - 1]);

          if (temp[i].length == 2) {
            // print("Going here");
          } else if (temp[i][temp[i].length - 1] == "}") {
            orders.add(temp[i].substring(0, temp[i].length - 2));
            // print("Going here 2----------");
          } else if (temp[i][temp[i].length - 2] == " ") {
            orders.add(temp[i].substring(0, temp[i].length - 4));
            // print("Going here 3 -------------------");
          }
        }
        // print(orders.length);

        for (int i = 0; i < orders.length; i++) {
          orderHeader.add(
              "${orders[i].substring(orders[i].indexOf("Order Date:"), orders[i].length)}\n");
          orderTrailer.add(
              "${orders[i].substring(0, orders[i].indexOf("Order Date:") - 2)}\n");
        }
        // print(orderHeader);
        // print(orderTrailer);
      }
    });
  }

  List<Widget> generateCardList(List<String> heads, List<String> trails) {
    List<Widget> cardList = [];
    for (int i = 0; i < heads.length; i++) {
      Card card = Card(
        color: Colors.transparent,
        child: Column(
          children: <Widget>[
            ListTile(
              leading: const Icon(
                Icons.airport_shuttle_rounded,
                size: 20.0,
                color: Colors.blue,
              ),
              title: Text(
                heads[i],
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 13.0,
                  letterSpacing: 1.0,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
              subtitle: Text(
                trails[i],
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 12.0,
                  letterSpacing: 1.0,
                  fontWeight: FontWeight.w400,
                  color: Colors.white.withOpacity(0.5),
                ),
              ),
              textColor: Colors.black,
              enableFeedback: true,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Divider(
                  height: 5.0,
                  color: Colors.grey,
                  thickness: 1.0,
                ),
                TextButton(
                  child: const Text(
                    'DELETE RECORD',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 15.0,
                      letterSpacing: 0.1,
                      fontWeight: FontWeight.w600,
                      color: Colors.blue,
                    ),
                  ),
                  onPressed: () async {
                    await deleteEntry(heads[i][heads[i].length - 2]);
                    await getOrders(cid.text);
                  },
                ),
                const SizedBox(width: 8),
              ],
            ),
          ],
        ),
      );
      cardList.add(card);
      cardList.add(const SizedBox(
        height: 30.0,
      ));
    }
    return cardList;
  }

  Future<void> deleteEntry(String orderNumber) async {
    // Your Firebase delete code here
    // Use the orderNumber argument to determine which order to delete
    // Example:
    try {
      // print(orderNumber);
      await ref
          .child('customers')
          .child(cid.text)
          .child('orders')
          .child(orderNumber)
          .remove();
      // print('Order $orderNumber deleted successfully.');
    } catch (e) {
      print(e);
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
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Logo(),
                Container(
                  margin: const EdgeInsets.only(left: 20, right: 20),
                  padding: const EdgeInsets.fromLTRB(20, 30, 20, 30),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color.fromARGB(255, 107, 68, 248),
                          Color.fromARGB(255, 126, 64, 212),
                        ]),
                    borderRadius: BorderRadius.only(
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
                            'Orders List',
                            textStyle: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 25.0,
                              letterSpacing: 1.0,
                              fontWeight: FontWeight.w400,
                              color: Colors.white,
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
                        controller: cid,
                        cursorColor: Colors.green,
                        cursorWidth: 2.0,
                        onSubmitted: (value) => getOrders(value),
                        decoration: InputDecoration(
                          prefixIcon: const Icon(
                            Icons.person_2_outlined,
                            size: 28.0,
                            color: Colors.green,
                          ),
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.green, width: 30.0),
                            borderRadius: BorderRadius.circular(35.0),
                          ),
                          labelText: ' Customer ID',
                          fillColor: Colors.white,
                          filled: true,
                          hintText: "Recent Customer ID is: $cNumber",
                          labelStyle: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 15.0,
                            letterSpacing: 0.2,
                            color: Colors.black,
                          ),
                        ),
                        obscureText: false,
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      GestureDetector(
                        //THIS BUTTON PUSHES DATA INTO DATABASE
                        onTap: () async {
                          if (cid.text == "") {
                            cid.text = cNumber.toString();
                          }
                          getOrders(cid.text);
                        },
                        child: SizedBox(
                          height: 45.0,
                          child: Material(
                            borderRadius: BorderRadius.circular(20.0),
                            shadowColor: Colors.black,
                            color: Colors.white,
                            elevation: 10,
                            child: const Center(
                              child: Text(
                                'Fetch Customer',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 13.0,
                                  letterSpacing: 0.2,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,
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
                  height: 30,
                ),
                Container(
                  margin: const EdgeInsets.only(left: 20, right: 20),
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color.fromARGB(255, 53, 55, 182),
                          Color.fromARGB(255, 232, 127, 253),
                        ]),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: generateCardList(orderHeader, orderTrailer),
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
