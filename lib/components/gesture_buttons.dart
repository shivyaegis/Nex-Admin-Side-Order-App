import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ClickableButton extends StatelessWidget {
  final Function()? onTap;
  final String text;
  final Color c;

  const ClickableButton({
    Key? key,
    required this.onTap,
    required this.text,
    required this.c,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        height: 45.0,
        child: Material(
          borderRadius: BorderRadius.circular(20.0),
          shadowColor: Colors.black,
          color: c,
          elevation: 10,
          child: Center(
            child: Text(
              text,
              style: const TextStyle(
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
    );
  }
}
