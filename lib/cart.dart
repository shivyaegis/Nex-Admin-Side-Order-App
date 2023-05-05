import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:skull/orders.dart';

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

  String date = "";
  String time = "";
  String printing = '';
  int sNo = 0;

  void date_() {
    DateTime dateToday = DateTime.now();
    date = dateToday.toString().substring(0, 10);
    String day = date.substring(8, 10);
    String month = date.substring(5, 7);
    String year = date.substring(0, 4);
    date = "$day/$month/$year";
    time = dateToday.toString().substring(11, 16);
    time = time.replaceAll(":", "");
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

      List myList1 = myList;
      for (int i = 0; i < sNo; i++) {
        String gsm = "";
        String color = "";
        String size = "";
        String quantity = "";

        gsm = myList1[0];
        myList1.remove(myList1[0]);

        color = myList1[0];
        myList1.remove(myList1[0]);

        size = myList1[0];
        myList1.remove(myList1[0]);

        quantity = myList1[0];
        myList1.remove(myList1[0]);

        sno_.add("${i + 1}.");
        gsm_.add(gsm);
        color_.add(color);
        size_.add(size);
        quantity_.add(quantity);
      }
      if (myList1.isEmpty) {
        stillList = false;
      }
    }
  }

// all functions to build the order table

  Widget buildTable() {
    return DataTable(
      columnSpacing: 20,
      horizontalMargin: 10,
      showBottomBorder: true,
      headingTextStyle: const TextStyle(
        fontFamily: 'Poppins',
        fontSize: 15.0,
        letterSpacing: 0.9,
        fontWeight: FontWeight.w800,
        color: Colors.black,
      ),
      dataTextStyle: const TextStyle(
        fontFamily: 'Poppins',
        fontSize: 15.0,
        letterSpacing: 0.0,
        fontWeight: FontWeight.w400,
        color: Colors.black,
      ),
      sortColumnIndex: 2,
      dataRowHeight: 55,
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

  bool some = true;
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

  @override
  Widget build(BuildContext context) {
    date_();
    findSNo();
    orderBuilder();
    return GestureDetector(
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
              Container(
                color: Colors.white,
                padding: const EdgeInsets.fromLTRB(0, 20, 0, 10),
                child: const Center(
                  child: Image(
                    image: AssetImage('images/logo new stretch.png'),
                    height: 150.0,
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Container(
                margin: const EdgeInsets.only(left: 10, right: 10),
                padding: const EdgeInsets.fromLTRB(10, 30, 10, 30),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.blue.shade300,
                        Colors.blue.shade600,
                        Colors.blue.shade800
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
                        color: Colors.white,
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
                            padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
                            width: 350,
                            color: Colors.transparent,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                const Text(
                                  "Order no: -",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 25.0,
                                    letterSpacing: 0.2,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.red,
                                  ),
                                ),
                                Text(
                                  "\nDate: $date",
                                  textAlign: TextAlign.right,
                                  style: const TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 10.0,
                                    letterSpacing: 0.1,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black,
                                  ),
                                ),
                                Text(
                                  "Time: $time Hours",
                                  textAlign: TextAlign.right,
                                  style: const TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 10.0,
                                    letterSpacing: 0.1,
                                    fontWeight: FontWeight.w400,
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
                      onTap: () async {},
                      child: SizedBox(
                        height: 45.0,
                        child: Material(
                          borderRadius: BorderRadius.circular(20.0),
                          shadowColor: Colors.black,
                          color: Colors.green,
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
                    const SizedBox(
                      height: 10.0,
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
    );
  }
}
