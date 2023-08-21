import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/services.dart';
import 'package:nex/components/logo.dart';

import 'homepage.dart';

List<String> cartList = [];

class Orders extends StatefulWidget {
  const Orders({Key? key}) : super(key: key);
  @override
  State<Orders> createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  //initialise database
  final DatabaseReference ref = FirebaseDatabase.instance.ref();
  String databaseJSON = '';
  int i = 1;
  String sendOrder = "";

  //variables to get customer details
  String fname = "";
  String lname = "";
  String cname = "";
  String gst = "";
  String email = "";

  //all variables to get size value from user
  String size = 'Select a size or search';
  bool customSize = false;
  List<String> sizeList = [
    "Select a size or search",
    "Custom Size",
    "6 x 6",
    "9 x 6",
    "9 x 9",
    "12 x 6",
    "12 x 9",
    "12 x 12",
    "15 x 9",
    "15 x 12",
    "15 x 15",
    "18 x 12",
    "18 x 15",
    "21 x 9",
    "21 x 12",
    "21 x 15",
    "21 x 18",
    "24 x 9",
    "24 x 12",
    "24 x 15",
    "24 x 18",
    "24 x 21",
    "27 x 12",
    "27 x 15",
    "27 x 18",
    "27 x 21",
    "27 x 24",
    "30 x 18",
    "30 x 21",
    "30 x 24",
    "30 x 27",
    "30 x 30",
    "33 x 27",
    "36 x 18",
    "36 x 21",
    "36 x 24",
    "36 x 30",
    "40 x 30",
    "40 x 36",
    "40 x 40",
    "45 x 30",
    "45 x 36",
    "45 x 40",
    "45 x 45",
    "50 x 50",
    "60 x 40",
    "60 x 60",
  ];

  //all variables to get gsm from user
  String gsm = "Select GSM";
  List<String> gsmList = [
    "Select GSM",
    "70",
    "90",
    "120",
    "150",
    "200",
    "250",
    "300"
  ];

  //all variables to get color from user
  String color = "Select color";
  List<String> colorList = [
    "Select color",
    "Blue",
    "Yellow",
    "Red",
    "Olive Green",
    "Silver Black",
    "Black"
  ];

  //all variables to store cart items in list
  String selectedGSM = "";
  String selectedColor = "";
  int orders = 0;
  final TextEditingController width = TextEditingController();
  final TextEditingController height = TextEditingController();
  final TextEditingController quantity = TextEditingController();
  var snackBar = const SnackBar(
    content: Text(""),
  );

  void dispMessage() {
    snackBar = SnackBar(
      content: Text(
        sendOrder,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontFamily: 'Poppins',
          fontSize: 13.0,
          letterSpacing: 0.4,
          fontWeight: FontWeight.w800,
          color: Colors.white,
        ),
      ),
      backgroundColor: Colors.black,
      showCloseIcon: true,
      closeIconColor: Colors.white,
      padding: const EdgeInsets.fromLTRB(5, 10, 5, 10),
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      duration: const Duration(milliseconds: 400),
      behavior: SnackBarBehavior.floating,
      // action: SnackBarAction(
      //   label: 'Hide',
      //   onPressed: () {},
      //   textColor: Colors.blue,
      //   disabledTextColor: Colors.black,
      // ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void getCustomerDetails() {
    int begin = 0;
    int end = 0;
    var snapshot_ = "";
    ref
        .child('customers')
        .child(cNumber.toString())
        .child('details')
        .once()
        .then((event) {
      setState(() {
        snapshot_ = event.snapshot.value.toString();
        //gets all details

        // setting last name
        begin = snapshot_.indexOf('last name') + 12;
        end = snapshot_.indexOf('phone no') - 2;
        lname = snapshot_.substring(begin, end);

        // setting gst number

        begin = snapshot_.indexOf('gst') + 12;
        end = snapshot_.indexOf('company name') - 2;
        gst = snapshot_.substring(begin, end);

        // setting company name

        begin = end + 2 + 14;
        end = snapshot_.indexOf('first name') - 2;
        cname = snapshot_.substring(begin, end);

        // setting first name

        begin = end + 2 + 13;
        end = snapshot_.indexOf('email') - 2;
        fname = snapshot_.substring(begin, end);

        // setting email

        begin = end + 2 + 7;
        end = snapshot_.indexOf('}');
        email = snapshot_.substring(begin, end);
      });
    });
  }

  //method to put order in table of customer
  Future<void> setOrder() async {
    sendOrder = "Updating tables...";
    await ref
        .child("customers")
        .child(cNumber.toString())
        .child('orders')
        .child(i.toString())
        .set({
      "GSM": gsm,
      "Color": color,
      "Quantity": quantity.text,
      "Size": size,
    });
    sendOrder = "Order sent successfully";
  }

  String whatSize() {
    if (size == "") {
      return sizeList[0];
    } else {
      return size;
    }
  }

  void items() {
    orders = (cartList.length) ~/ 4;
  }

  @override
  Widget build(BuildContext context) {
    items();
    if (size == 'Custom Size') {
      customSize = true;
    } else {
      customSize = false;
    }
    getCustomerDetails();

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
              'Orders',
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
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                      Colors.blue.shade800,
                      Colors.blue.shade400,
                      Colors.indigo.shade400,
                      Colors.indigo.shade900
                    ]),
                    borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(40.0),
                        bottomRight: Radius.circular(40.0),
                        topLeft: Radius.circular(40.0),
                        bottomLeft: Radius.circular(40.0)),
                  ),
                  child: Column(
                    children: [
                      //DISPLAYING CUSTOMER INFORMATION
                      Container(
                        margin:
                            const EdgeInsets.only(left: 10, right: 10, top: 10),
                        padding: const EdgeInsets.fromLTRB(60, 50, 60, 90),
                        decoration: const BoxDecoration(
                          color: Colors.transparent,
                          image: DecorationImage(
                            image: AssetImage("images/bg1.jpg"),
                            opacity: 0.2,
                            fit: BoxFit.fill,
                          ),
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(20.0),
                              bottomRight: Radius.circular(20.0),
                              topLeft: Radius.circular(20.0),
                              bottomLeft: Radius.circular(200.0)),
                        ),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text(
                                'Customer Info',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 30.0,
                                  letterSpacing: 1.0,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                '\n\nCustomer ID : \n$cNumber',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 18.0,
                                  overflow: TextOverflow.clip,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                '\nFirst Name : \n$fname',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 18.0,
                                  overflow: TextOverflow.clip,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                '\nLast name : \n$lname',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 18.0,
                                  overflow: TextOverflow.clip,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                '\nCompany : \n$cname',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 18.0,
                                  overflow: TextOverflow.clip,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                '\nEmail : \n$email',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 18.0,
                                  overflow: TextOverflow.clip,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,
                                ),
                              ),
                            ]),
                      ),
                      const SizedBox(
                        height: 35.0,
                      ),
                      const Text(
                        'Orders',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 25.0,
                          letterSpacing: 1.0,
                          fontWeight: FontWeight.w900,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(
                        height: 15.0,
                      ),

                      //OPTION TO SELECT GSM
                      Container(
                        margin: const EdgeInsets.only(left: 20, right: 20),
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(20.0),
                              bottomRight: Radius.circular(20.0),
                              topLeft: Radius.circular(20.0),
                              bottomLeft: Radius.circular(20.0)),
                        ),
                        child: DropdownSearch<String>(
                          popupProps: const PopupProps.menu(
                            showSelectedItems: true,
                            showSearchBox: true,
                          ),
                          items: gsmList,
                          dropdownDecoratorProps: const DropDownDecoratorProps(
                            dropdownSearchDecoration: InputDecoration(
                              labelText: "GSM",
                              hintText: "Choose GSM",
                            ),
                          ),
                          onChanged: (newText) {
                            setState(() {
                              gsm = newText!;
                              selectedGSM = gsm;
                            });
                          },
                          selectedItem: selectedGSM,
                        ),
                      ),

                      //CONSTRAINT MESSAGE FOR ABOVE CONTAINER
                      const SizedBox(
                        height: 5,
                      ),
                      Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          gsm == "Select GSM" || gsm == ""
                              ? '*GSM cannot be null*\n'
                              : '',
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 15.0,
                            letterSpacing: 0.2,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        ),
                      ),

                      //OPTION TO SELECT COLOR
                      Container(
                        margin: const EdgeInsets.only(left: 20, right: 20),
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(20.0),
                              bottomRight: Radius.circular(20.0),
                              topLeft: Radius.circular(20.0),
                              bottomLeft: Radius.circular(20.0)),
                        ),
                        child: DropdownSearch<String>(
                          popupProps: const PopupProps.menu(
                            showSelectedItems: true,
                          ),
                          items: colorList,
                          dropdownDecoratorProps: const DropDownDecoratorProps(
                            dropdownSearchDecoration: InputDecoration(
                              labelText: "Color",
                            ),
                          ),
                          onChanged: (newText) {
                            if (newText != "Select color") {
                              setState(() {
                                color = newText!;
                                selectedColor = color;
                              });
                            }
                          },
                          selectedItem: selectedColor,
                        ),
                      ),

                      //CONSTRAINT MESSAGE FOR ABOVE CONTAINER
                      const SizedBox(
                        height: 5,
                      ),
                      Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          color == "Select color" || color == ""
                              ? '*Color cannot be null*\n'
                              : '',
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 15.0,
                            letterSpacing: 0.2,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                      ),

                      const SizedBox(
                        height: 10,
                      ),

                      //CONTAINER FOR SIZE OPTION SELECTION FOR ORDER

                      Container(
                        margin: const EdgeInsets.only(left: 20, right: 20),
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(20.0),
                              bottomRight: Radius.circular(20.0),
                              topLeft: Radius.circular(20.0),
                              bottomLeft: Radius.circular(20.0)),
                        ),
                        child: DropdownSearch<String>(
                          popupProps: const PopupProps.menu(
                            showSelectedItems: true,
                            showSearchBox: true,
                          ),
                          items: sizeList,
                          dropdownDecoratorProps: const DropDownDecoratorProps(
                            dropdownSearchDecoration: InputDecoration(
                              labelText: "Size",
                            ),
                          ),
                          onChanged: (newText) {
                            setState(() {
                              size = newText!;
                              if (!sizeList.contains(newText)) {
                                sizeList.add(newText);
                              }
                            });
                          },
                          selectedItem: whatSize(),
                        ),
                      ),

                      //CONSTRAINT MESSAGE FOR ABOVE CONTAINER
                      const SizedBox(
                        height: 5,
                      ),
                      Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          size == 'Select a size or search'
                              ? '*Size cannot be null*\n'
                              : size == 'Custom Size'
                                  ? '\n--Enter custom size--'
                                  : '',
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 15.0,
                            letterSpacing: 0.2,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                      ),

                      //OPTION TO SELECT CUSTOM SIZE AND THEN PUTS IT INTO SIZE BOX
                      Visibility(
                        visible: customSize,
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 15.0,
                            ),
                            Container(
                              margin:
                                  const EdgeInsets.only(left: 100, right: 100),
                              child: TextField(
                                controller: width,
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.number,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                cursorColor: Colors.black,
                                enabled: customSize,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Colors.white,
                                      width: 10.0,
                                    ),
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  labelText: 'Width',
                                  fillColor: Colors.white,
                                  filled: true,
                                  labelStyle: const TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 15.0,
                                    letterSpacing: 0.2,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 25,
                            ),
                            Container(
                              margin:
                                  const EdgeInsets.only(left: 100, right: 100),
                              child: TextField(
                                keyboardType: TextInputType.number,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly
                                ], // Onl
                                controller: height,
                                onSubmitted: (newText) {
                                  setState(() {
                                    String width_ = width.text;
                                    String height_ = height.text;
                                    sizeList.add('$width_ x $height_');
                                    setState(() {
                                      size = '$width_ x $height_';
                                    });
                                  });
                                },
                                cursorColor: Colors.black,
                                enabled: customSize,
                                // controller: _emailController,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Colors.white,
                                      width: 10.0,
                                    ),
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  labelText: 'Height',
                                  fillColor: Colors.white,
                                  filled: true,
                                  labelStyle: const TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 15.0,
                                    letterSpacing: 0.2,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 35,
                            ),
                          ],
                        ),
                      ),

                      //OPTION TO SELECT QUANTITY
                      Container(
                        margin: const EdgeInsets.only(left: 20, right: 20),
                        child: TextField(
                          controller: quantity,
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly
                          ], // Onl
                          cursorColor: Colors.black,
                          // controller: _emailController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors.white,
                                width: 10.0,
                              ),
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            labelText: 'Quantity',
                            fillColor: Colors.white,
                            filled: true,
                            labelStyle: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 15.0,
                              letterSpacing: 0.2,
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),

                      //CONSTRAINT MESSAGE FOR ABOVE CONTAINER
                      const SizedBox(
                        height: 5,
                      ),
                      Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          quantity.text == "0" || quantity.text == ""
                              ? '*Quantity cannot be null*\n'
                              : '',
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 15.0,
                            letterSpacing: 0.2,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      GestureDetector(
                        onTap: () {
                          if (size != "Select a size or search" &&
                              gsm != "Select GSM" &&
                              color != "Select color" &&
                              quantity.text != "" &&
                              quantity.text != "0") {
                            sendOrder = "Adding to cart...";
                            dispMessage();
                            setState(() {
                              cartList.add(gsm);
                              cartList.add(color);
                              cartList.add(size);
                              cartList.add(quantity.text);
                              // print(cartList);
                            });
                            Future.delayed(const Duration(milliseconds: 100),
                                () {
                              sendOrder = "Added to cart";
                              dispMessage();
                              Future.delayed(const Duration(seconds: 1), () {
                                setState(() {
                                  gsm = gsmList[0];
                                  selectedGSM = "";
                                  color = colorList[0];
                                  selectedColor = "";
                                  size = sizeList[0];
                                  quantity.text = "";
                                  items();
                                });
                              });
                            });
                          } else {
                            sendOrder = "Field(s) cannot be empty!";
                            dispMessage();
                          }
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
                                'ADD TO CART',
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
                        height: 15.0,
                      ),
                      GestureDetector(
                        onTap: () async {
                          Future.delayed(const Duration(milliseconds: 10), () {
                            sendOrder = "Fields cleared!";
                            dispMessage();
                            Future.delayed(const Duration(seconds: 1), () {
                              gsm = gsmList[0];
                              selectedGSM = "";
                              color = colorList[0];
                              selectedColor = "";
                              size = sizeList[0];
                              quantity.text = "";
                            });
                          });
                        },
                        child: SizedBox(
                          height: 45.0,
                          child: Material(
                            borderRadius: BorderRadius.circular(20.0),
                            shadowColor: Colors.black,
                            color: Colors.red[300],
                            elevation: 10,
                            child: const Center(
                              child: Text(
                                'CLEAR FIELDS',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 15.0,
                                  letterSpacing: 0.2,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 15.0,
                      ),

                      GestureDetector(
                        onTap: () async {
                          if (cartList.isNotEmpty) {
                            Navigator.of(context).pushNamed('/cart');
                          } else {
                            sendOrder = "Cart is empty!";
                            dispMessage();
                            Future.delayed(const Duration(milliseconds: 100),
                                () {
                              Navigator.of(context).pushNamed('/cart');
                            });
                          }
                        },
                        child: SizedBox(
                          height: 45.0,
                          child: Material(
                            borderRadius: BorderRadius.circular(20.0),
                            shadowColor: Colors.black,
                            color: Colors.green[800],
                            elevation: 10,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 5, 10, 5),
                                  height: 55.0,
                                  child: Material(
                                    borderRadius: BorderRadius.circular(10.0),
                                    shadowColor: Colors.black,
                                    color: Colors.red,
                                    elevation: 10,
                                    child: Container(
                                      padding: const EdgeInsets.fromLTRB(
                                          15, 5, 15, 5),
                                      child: Text(
                                        "$orders",
                                        style: const TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 17.0,
                                          letterSpacing: 0.5,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const Center(
                                  child: Text(
                                    'VIEW CART',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 15.0,
                                      letterSpacing: 0.2,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                IconButton(
                                    onPressed: () {
                                      Navigator.of(context).pushNamed('/cart');
                                    },
                                    icon: const Icon(
                                        Icons.shopping_cart_outlined)),
                              ],
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(
                        height: 30.0,
                      ),
                      GestureDetector(
                        onTap: () async {
                          cartList = [];
                          Navigator.of(context).pop();
                        },
                        child: SizedBox(
                          height: 45.0,
                          child: Material(
                            type: MaterialType.transparency,
                            borderRadius: BorderRadius.circular(20.0),
                            shadowColor: Colors.black,
                            elevation: 10,
                            child: const Center(
                              child: Text(
                                'BACK',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 15.0,
                                  letterSpacing: 0.2,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
