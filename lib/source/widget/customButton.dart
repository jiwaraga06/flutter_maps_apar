import 'package:flutter/material.dart';
import 'package:flutter_maps_apar/source/widget/color.dart';

class CustomButon extends StatelessWidget {
  final String? text;
  final Color? splashColor, color;
  final VoidCallback? onTap;
  final TextStyle? textStyle;
  CustomButon({super.key, this.text, this.splashColor, this.color, this.onTap, this.textStyle});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      splashColor: splashColor,
      borderRadius: BorderRadius.circular(6.0),
      child: Ink(
        height: 45,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(6.0),
        ),
        child: Center(
          child: Text(text!, style: textStyle),
        ),
      ),
    );
  }
}
