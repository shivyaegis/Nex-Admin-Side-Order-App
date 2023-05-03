import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/services.dart';

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
    "60 x 60"
  ];

  //all variables to get gsm from user
  String gsm = "Select GSM";
  List<String> gsmList = ["70", "90", "120", "150", "200", "250", "300"];

  //all variables to get color from user
  String color = "Select color";
  List<String> colorList = [
    "Blue",
    "Yellow",
    "Red",
    "Olive Green",
    "Silver Black",
    "Black"
  ];

  //all variables to store cart items in list
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
          fontSize: 15.0,
          letterSpacing: 0.2,
          fontWeight: FontWeight.w400,
          color: Colors.white,
        ),
      ),
      backgroundColor: Colors.black,
      padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
      duration: const Duration(milliseconds: 800),
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

  //method to give unique order number to customer
  Future<void> orderNo() async {
    sendOrder = "Getting order number...";
    i = 1;
    bool exist = true;
    String databaseJSON = '';
    while (exist && i < 100) {
      sendOrder = "Referencing database...";
      await ref
          .child('customers')
          .child(cNumber.toString())
          .child('orders')
          .child(i.toString())
          .once()
          .then((event) {
        final dataSnapshot = event.snapshot;
        setState(() {
          databaseJSON = dataSnapshot.value.toString();
        });
        if (databaseJSON == "null") {
          exist = false;
        } else {
          i++;
        }
      });
    }
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

  @override
  Widget build(BuildContext context) {
    if (size == 'Custom Size') {
      customSize = true;
    } else {
      customSize = false;
    }
    getCustomerDetails();

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
              Container(
                color: Colors.white,
                padding: const EdgeInsets.fromLTRB(10, 15, 10, 10),
                child: const Center(
                  child: Image(
                    image: AssetImage('images/logo.jpg'),
                    height: 40.0,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                margin: const EdgeInsets.only(left: 20, right: 20),
                padding: const EdgeInsets.fromLTRB(10, 30, 10, 20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [Colors.blue.shade700, Colors.blue.shade300]),
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
                      margin: const EdgeInsets.only(left: 10, right: 10),
                      padding: const EdgeInsets.fromLTRB(60, 70, 60, 90),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: const AssetImage("images/user2.png"),
                          fit: BoxFit.cover,
                          colorFilter: ColorFilter.mode(
                              Colors.black.withOpacity(0.05),
                              BlendMode.dstATop),
                        ),
                        color: Colors.white,
                        borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(10.0),
                            bottomRight: Radius.circular(200.0),
                            topLeft: Radius.circular(10.0),
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
                                fontSize: 25.0,
                                letterSpacing: 1.0,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              '\n\nCustomer ID : \t\t$cNumber',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 17.0,
                                overflow: TextOverflow.ellipsis,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              '\nFirst Name : \t\t$fname',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 17.0,
                                overflow: TextOverflow.ellipsis,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              '\nLast name : \t\t$lname',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 17.0,
                                overflow: TextOverflow.ellipsis,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              '\nCompany : \t\t$cname',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 17.0,
                                overflow: TextOverflow.ellipsis,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              '\nEmail : \t\t$email',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 17.0,
                                overflow: TextOverflow.ellipsis,
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
                        fontWeight: FontWeight.w400,
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
                          });
                        },
                        selectedItem: "70",
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
                            ? 'GSM cannot be null\n'
                            : '',
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 15.0,
                          letterSpacing: 0.2,
                          fontWeight: FontWeight.w400,
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
                            hintText: "Choose Color",
                          ),
                        ),
                        onChanged: (newText) {
                          setState(() {
                            color = newText!;
                          });
                        },
                        selectedItem: "Blue",
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
                            ? 'Color cannot be null\n'
                            : '',
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 15.0,
                          letterSpacing: 0.2,
                          fontWeight: FontWeight.w400,
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
                        popupProps: PopupProps.menu(
                          showSelectedItems: true,
                          disabledItemFn: (String s) => s.startsWith('I'),
                        ),
                        items: gsmList,
                        dropdownDecoratorProps: const DropDownDecoratorProps(
                          dropdownSearchDecoration: InputDecoration(
                            labelText: "Size",
                            hintText: "Choose size",
                          ),
                        ),
                        onChanged: (newText) {
                          setState(() {
                            size = newText!;
                          });
                        },
                        selectedItem: size,
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
                            ? 'Size cannot be null\n'
                            : size == 'Custom Size'
                                ? '\nEnter custom size'
                                : '',
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 15.0,
                          letterSpacing: 0.2,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        ),
                      ),
                    ),

                    //OPTION TO SELECT CUSTOM SIZE AND THEN PUTS IT INTO SIZE BOX
                    Visibility(
                      visible: customSize,
                      child: Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(left: 20, right: 20),
                            child: TextField(
                              controller: width,
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly
                              ], // Onl
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
                                hintText: 'Width',
                                hintStyle: const TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 15.0,
                                  letterSpacing: 1.0,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black54,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            margin: const EdgeInsets.only(left: 20, right: 20),
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
                                  size = '$width_ x $height_';
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
                                hintText: 'Height',
                                hintStyle: const TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 15.0,
                                  letterSpacing: 1.0,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black54,
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
                        textInputAction: TextInputAction.next,
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
                          hintText: 'Quantity',
                          hintStyle: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 15.0,
                            letterSpacing: 1.0,
                            fontWeight: FontWeight.w400,
                            color: Colors.black54,
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
                            ? 'Quantity cannot be null\n'
                            : '',
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 15.0,
                          letterSpacing: 0.2,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        ),
                      ),
                    ),

                    const SizedBox(
                      height: 15,
                    ),

                    // GestureDetector(
                    //   onTap: () async{
                    //     sendOrder = ". . . .";
                    //     Future.delayed(const Duration(seconds: 1), () async {
                    //       if(size!= "null" && gsm!="" && color!="" && quantity.text!="" && quantity.text!="0"){
                    //         sendOrder = "Preparing order...";
                    //         await orderNo();
                    //         setOrder();
                    //       }
                    //       else{
                    //         sendOrder = "Field(s) cannot be empty!";
                    //       }
                    //     });
                    //   },
                    //   child: SizedBox(
                    //     height: 45.0,
                    //     child: Material(
                    //       borderRadius: BorderRadius.circular(20.0),
                    //       shadowColor: Colors.black,
                    //       color: Colors.black,
                    //       elevation: 10,
                    //       child: const Center(
                    //         child: Text(
                    //           'SEND ORDER',
                    //           style: TextStyle(
                    //             fontFamily: 'Poppins',
                    //             fontSize: 15.0,
                    //             letterSpacing: 0.2,
                    //             fontWeight: FontWeight.w400,
                    //             color: Colors.white,
                    //           ),
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    const SizedBox(
                      height: 15,
                    ),
                    GestureDetector(
                      onTap: () async {
                        sendOrder = ". . . .";
                        dispMessage();

                        if (size != "null" &&
                            gsm != "" &&
                            color != "" &&
                            quantity.text != "" &&
                            quantity.text != "0") {
                          sendOrder = "Adding to cart...";
                          dispMessage();
                          cartList.add(gsm);
                          cartList.add(color);
                          cartList.add(size);
                          cartList.add(quantity.text);
                          print(cartList);
                          Future.delayed(const Duration(milliseconds: 500), () {
                            sendOrder = "Added to cart";
                            dispMessage();
                            size = "";
                            quantity.text = "";
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
                        sendOrder = "Clearing fields...";
                        dispMessage();
                        Future.delayed(const Duration(milliseconds: 500), () {
                          size = "Select a size or search";
                          gsm = "";
                          color = "";
                          quantity.text = "";
                          sendOrder = "Fields cleared";
                          dispMessage();
                        });
                      },
                      child: SizedBox(
                        height: 45.0,
                        child: Material(
                          borderRadius: BorderRadius.circular(20.0),
                          shadowColor: Colors.black,
                          color: Colors.red[600],
                          elevation: 10,
                          child: const Center(
                            child: Text(
                              'CLEAR FIELDS',
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
                        if (cartList.isNotEmpty) {
                          Navigator.of(context).pushNamed('/cart');
                        } else {
                          sendOrder = "Cart is empty";
                          dispMessage();
                        }
                      },
                      child: SizedBox(
                        height: 45.0,
                        child: Material(
                          borderRadius: BorderRadius.circular(20.0),
                          shadowColor: Colors.black,
                          color: Colors.green[600],
                          elevation: 10,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Center(
                                child: Text(
                                  '\t\t\t\t\t\t VIEW CART',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 15.0,
                                    letterSpacing: 0.2,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              IconButton(
                                  onPressed: () {
                                    Navigator.of(context).pushNamed('/cart');
                                  },
                                  icon:
                                      const Icon(Icons.shopping_cart_outlined)),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(
                      height: 20.0,
                    ),
                    GestureDetector(
                      onTap: () async {
                        cartList = [];
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
                              'BACK TO CUSTOMER REGISTRATION',
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
                height: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
