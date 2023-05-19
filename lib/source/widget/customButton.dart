import 'package:flutter/material.dart';
import 'package:flutter_maps_apar/source/widget/color.dart';

class CustomButton extends StatelessWidget {
  final String? text;
  final Color? splashColor, color;
  final VoidCallback? onTap;
  final TextStyle? textStyle;
  CustomButton({super.key, this.text, this.splashColor, this.color, this.onTap, this.textStyle});

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 4.0,
      borderRadius: BorderRadius.circular(6.0),
      child: InkWell(
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
      ),
    );
  }
}
