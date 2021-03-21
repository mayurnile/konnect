import 'package:flutter/material.dart';

class TransparentButton extends StatelessWidget {
  final String title;
  final Function onPressed;

  TransparentButton({
    Key key,
    @required this.title,
    @required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 2.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32.0),
          color: Colors.white.withOpacity(0.5),
        ),
        child: Text(
          title,
          style: Theme.of(context).textTheme.headline3.copyWith(
                color: Colors.white,
              ),
        ),
      ),
    );
  }
}
