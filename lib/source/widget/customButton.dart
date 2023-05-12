import 'package:flutter/material.dart';
import 'package:flutter_maps_apar/source/widget/color.dart';

class CustomButon extends StatelessWidget {
  final String? text;
  CustomButon({super.key, this.text});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      splashColor: color2,
      borderRadius: BorderRadius.circular(6.0),
      child: Ink(
        height: 50,
        decoration: BoxDecoration(
          color: color1,
          borderRadius: BorderRadius.circular(6.0),
        ),
        child: Center(
          child: Text(text!, style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }
}
