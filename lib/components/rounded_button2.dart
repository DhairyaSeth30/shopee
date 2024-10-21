import 'package:flutter/material.dart';

class RoundedButton2 extends StatelessWidget {
  const RoundedButton2({
    required this.colour,
    required this.title,
    required this.onPressed,
    this.border,
    required this.textColor,
  });

  final Color colour;
  final String title;
  final Function onPressed;
  final Color? border;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 5.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(
                color: border ?? Colors.transparent,
                width: 1.0,
              ),
            ),
            child: Material(
              color: colour,
              borderRadius: BorderRadius.circular(8.0),
              child: MaterialButton(
                onPressed: () {
                  onPressed();
                },
                minWidth: 200.0,
                height: 56.0,
                child: Text(
                  title,
                  style: TextStyle(
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w600,
                    fontSize: 16.0,
                    color: textColor,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
