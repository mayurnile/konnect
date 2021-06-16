import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CircularButton extends StatelessWidget {
  final String icon;
  final Function onPressed;
  final bool isSmall;

  CircularButton({
    Key? key,
    required this.icon,
    required this.onPressed,
    this.isSmall = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return InkWell(
      onTap: () => onPressed(),
      child: Container(
        height: isSmall ? screenSize.width * 0.1 : screenSize.width * 0.15,
        width: isSmall ? screenSize.width * 0.1 : screenSize.width * 0.15,
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withOpacity(0.5),
        ),
        alignment: Alignment.center,
        child: SvgPicture.asset(
          icon,
          color: Colors.white,
        ),
      ),
    );
  }
}
