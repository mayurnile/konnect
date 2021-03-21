import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../core/core.dart';

class AppLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return SvgPicture.asset(
      Assets.LOGO,
      width: screenSize.width * 0.25,
    );
  }
}
