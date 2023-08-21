import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  const Logo({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Container(
        width: 200,
        height: 150,
        color: Colors.white,
        padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
        child: const Center(
          child: Image(
            image: AssetImage('images/logo2.jpg'),
            height: 250.0,
          ),
        ),
      ),
      const SizedBox(
        height: 15,
      ),
    ]);
  }
}
