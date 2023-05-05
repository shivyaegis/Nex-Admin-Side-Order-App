import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  const Logo({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
        color: Colors.white,
        padding: const EdgeInsets.fromLTRB(0, 40, 0, 20),
        child: const Center(
          child: Image(
            image: AssetImage('images/logo new stretch.png'),
            height: 200.0,
          ),
        ),
      ),
      const SizedBox(
        height: 15,
      ),
    ]);
  }
}
