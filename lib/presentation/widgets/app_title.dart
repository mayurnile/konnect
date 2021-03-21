import 'package:flutter/material.dart';

class AppTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return SizedBox(
      width: screenSize.width * 0.5,
      child: FittedBox(
        alignment: Alignment.centerLeft,
        fit: BoxFit.scaleDown,
        child: Text(
          'Konnect',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 24.0,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
