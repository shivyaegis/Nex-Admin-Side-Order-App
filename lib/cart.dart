import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:nex/components/logo.dart';
import 'package:nex/homepage.dart';
import 'package:nex/orders.dart';

class Cart extends StatefulWidget {
  const Cart({Key? key}) : super(key: key);

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  //all methods and variables here
  List<String> sno_ = [];
  List<String> gsm_ = [];
  List<String> color_ = [];
  List<String> size_ = [];
  List<String> quantity_ = [];
  bool isdispose = false;

  @override
  void dispose() {
    isdispose = true;
    super.dispose();
  }

  //initialise database
  final DatabaseReference ref = FirebaseDatabase.instance.ref();
  String databaseJSON = '';

  String date = "";
  String time = "";

  String printing = '';
  int sNo = 0;
  int i = 1;

  void date_() {
    DateTime dateToday = DateTime.now();
    date = dateToday.toString().substring(0, 10);
    String day = date.substring(8, 10);
    String month = date.substring(5, 7);
    String year = date.substring(0, 4);
    setState(() {
      date = "$day/$month/$year";
      time = dateToday.toString().substring(11, 16);
      time = time.replaceAll(":", "");
    });
  }

  void findSNo() {
    sNo = ((cartList.length) / 4).floor();
  }

  void orderBuilder() {
    sno_ = [];
    gsm_ = [];
    color_ = [];
    size_ = [];
    quantity_ = [];
    bool stillList = true;
    List<String> myList = List.from(cartList);
    while (stillList) {
      if (sNo == 0) {
        stillList = false;
      }
      for (int i = 0; i < sNo; i++) {
        String gsm = "";
        String color = "";
        String size = "";
        String quantity = "";
        gsm = myList[(i * 4) + 0];
        color = myList[(i * 4) + 1];
        size = myList[(i * 4) + 2];
        quantity = myList[(i * 4) + 3];
        sno_.add("${i + 1}.");
        gsm_.add(gsm);
        color_.add(color);
        size_.add(size);
        quantity_.add(quantity);
      }
      stillList = false;
    }
  }

// all functions to build the order table

  Widget buildTable() {
    orderBuilder();
    return DataTable(
      columnSpacing: 30,
      horizontalMargin: 10,
      showBottomBorder: true,
      dividerThickness: 5.0,
      headingTextStyle: const TextStyle(
        fontFamily: 'Poppins',
        fontSize: 12.0,
        letterSpacing: 0.9,
        fontWeight: FontWeight.w800,
        color: Colors.black,
      ),
      dataTextStyle: TextStyle(
        fontFamily: 'Poppins',
        fontSize: MediaQuery.of(context).size.width / (25 + 5),
        letterSpacing: 0.0,
        fontWeight: FontWeight.w400,
        color: Colors.black,
      ),
      sortColumnIndex: 1,
      sortAscending: true,
      columns: const [
        DataColumn(label: Text('Sno')),
        DataColumn(label: Text('GSM')),
        DataColumn(label: Text('Color')),
        DataColumn(label: Text('Size')),
        DataColumn(label: Text('Quantity')),
      ],
      rows: buildRow(),
    );
  }

  List<DataRow> buildRow() {
    // List<DataRow> zeroList = [];
    List<DataRow> zeroList = List<DataRow>.filled(
        sNo,
        const DataRow(cells: [
          DataCell(Text("")),
        ]),
        growable: true);
    int count = 1;
    while (count <= sNo) {
      zeroList[count - 1] = data();
      count++;
    }
    return zeroList;
  }

  DataRow data() {
    return DataRow(cells: [
      buildCell(sno_),
      buildCell(gsm_),
      buildCell(color_),
      buildCell(size_),
      buildCell(quantity_),
    ]);
  }

  DataCell buildCell(x) {
    String txt = x[0];
    x.removeAt(0);
    return DataCell(Text(txt));
  }

  //method to give unique order number to customer
  Future<void> orderNo() async {
    // sendOrder = "Getting order number...";
    String databaseJSON = '';
    // sendOrder = "Referencing database...";
    await ref
        .child('customers')
        .child(cNumber.toString())
        .child('orders')
        .child(i.toString())
        .once()
        .then((event) {
      final dataSnapshot = event.snapshot;
      if (!isdispose) {
        setState(() {
          databaseJSON = dataSnapshot.value.toString();
        });
      }

      if (databaseJSON == "null") {
      } else {
        if (!isdispose) {
          setState(() {
            i = i + 1;
          });
        }

        // print("checking order part $i");
      }
    });
  }

  //method to put order in table of customer
  Future<void> setOrder(gsm, color, quantity, size) async {
    // sendOrder = "Updating tables...";
    await ref
        .child("customers")
        .child(cNumber.toString())
        .child('orders')
        .child(i.toString())
        .set({
      "Order Date": date,
      "Order Time": time,
      "Order Number": i,
      "GSM": gsm,
      "Color": color,
      "Quantity": quantity,
      "Size": size,
    });
    // sendOrder = "Order sent successfully";
  }

  void update() {
    if (!isdispose) {
      date_();
      findSNo();
      orderNo();
    }
  }

  @override
  Widget build(BuildContext context) {
    update();
    return SafeArea(
      child: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.black,
            centerTitle: true,
            toolbarOpacity: 1,
            toolbarHeight: 50,
            title: const Text(
              'Your Cart',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 15.0,
                letterSpacing: 0.2,
                fontWeight: FontWeight.w400,
                color: Colors.white,
              ),
            ),
          ),
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Logo(),
                Container(
                  margin: const EdgeInsets.only(left: 10, right: 10),
                  padding: const EdgeInsets.fromLTRB(10, 30, 10, 30),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.blue.shade800,
                          Colors.blue.shade600,
                          Colors.blue.shade300,
                          Colors.lightBlue.shade600,
                          Colors.lightBlue.shade400,
                          Colors.lightBlue.shade100,
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
                            'Cart',
                            textStyle: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 30.0,
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
                      Container(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                        decoration: const BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(10.0),
                              bottomRight: Radius.circular(10.0),
                              topLeft: Radius.circular(10.0),
                              bottomLeft: Radius.circular(10.0)),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Container(
                              padding:
                                  const EdgeInsets.fromLTRB(10, 20, 10, 10),
                              color: Colors.transparent,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text(
                                    "Order number ${i - 1}",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 25.0,
                                      letterSpacing: 0.2,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.pink.shade700,
                                    ),
                                  ),
                                  Text(
                                    "\nDate: $date",
                                    textAlign: TextAlign.right,
                                    style: const TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 12.0,
                                      letterSpacing: 0.1,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Text(
                                    "Time: $time Hours",
                                    textAlign: TextAlign.right,
                                    style: const TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 12.0,
                                      letterSpacing: 0.1,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            buildTable(),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      GestureDetector(
                        onTap: () async {
                          // sendOrder = "Preparing order...";
                          // update();
                          while (cartList.isNotEmpty) {
                            String gsm = "";
                            String color = "";
                            String size = "";
                            String quantity = "";
                            gsm = cartList[0];
                            color = cartList[1];
                            size = cartList[2];
                            quantity = cartList[3];
                            await setOrder(gsm, color, quantity, size);
                            cartList.removeRange(0, 4);
                          }
                          // cartList = [];
                        },
                        child: SizedBox(
                          height: 45.0,
                          child: Material(
                            borderRadius: BorderRadius.circular(20.0),
                            shadowColor: Colors.black,
                            color: Colors.pink.shade900,
                            elevation: 10,
                            child: const Center(
                              child: Text(
                                'CONFIRM ORDER',
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
                      const SizedBox(
                        height: 20.0,
                      ),
                      GestureDetector(
                        onTap: () async {
                          setState(() {
                            cartList = [];
                          });
                          Navigator.of(context).pop();
                        },
                        child: SizedBox(
                          height: 45.0,
                          child: Material(
                            borderRadius: BorderRadius.circular(20.0),
                            shadowColor: Colors.black,
                            color: Colors.pink.shade500,
                            elevation: 10,
                            child: const Center(
                              child: Text(
                                'CANCEL ORDER',
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
                      const SizedBox(
                        height: 20.0,
                      ),
                      GestureDetector(
                        onTap: () async {
                          setState(() {
                            cartList = [];
                          });
                          Navigator.of(context)
                              .pushReplacementNamed('/full list');
                        },
                        child: SizedBox(
                          height: 45.0,
                          child: Material(
                            borderRadius: BorderRadius.circular(20.0),
                            shadowColor: Colors.black,
                            color: Colors.pink.shade200,
                            elevation: 10,
                            child: const Center(
                              child: Text(
                                'VIEW ALL ORDERS',
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
                      const SizedBox(
                        height: 30.0,
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 30.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
