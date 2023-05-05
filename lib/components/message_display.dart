import 'package:flutter/material.dart';

class MessagePrint extends StatelessWidget {
  final int success;
  final String message;
  final String error;
  const MessagePrint({
    Key? key,
    required this.success,
    required this.message,
    required this.error,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        success == 1 ? message : (success == 2 ? message : error),
        style: const TextStyle(
          fontFamily: 'Poppins',
          fontSize: 15.0,
          letterSpacing: 0.2,
          fontWeight: FontWeight.w400,
          color: Colors.white,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
