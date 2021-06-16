import 'package:flutter/material.dart';
import '../../core/core.dart';

class MyTab extends StatelessWidget {
  final String title;
  final bool isSelected;
  final Function onTap;

  MyTab({
    Key? key,
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return InkWell(
      onTap: () => onTap(),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          //indicator
          isSelected
              ? Container(
                  height: 5,
                  width: 5,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: KonnectTheme.SECONDARY_COLOR,
                  ),
                )
              : SizedBox.shrink(),
          //spacing
          SizedBox(width: 8.0),
          //title
          Text(
            title,
            style: isSelected
                ? textTheme.headline4!.copyWith(color: Colors.white)
                : textTheme.headline3!.copyWith(
                    color: Colors.white.withOpacity(0.7),
                  ),
          ),
        ],
      ),
    );
  }
}
