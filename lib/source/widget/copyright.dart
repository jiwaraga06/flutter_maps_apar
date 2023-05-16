import 'package:flutter/material.dart';

class Copyright extends StatelessWidget {
  const Copyright({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      color: const Color(0XFF0F0E0E),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.copyright, color: Colors.white),
          Text(' IT DEPARTMENT | PT Sipatex Putri Lestari | ', style: TextStyle(color: Colors.white, fontSize: 15)),
          // Text('V 1.0', style: TextStyle(color: Colors.white, fontSize: 15)),
        ],
      ),
    );
  }
}
