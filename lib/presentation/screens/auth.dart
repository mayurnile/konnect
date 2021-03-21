import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/core.dart';

import '../widgets/widgets.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen>
    with SingleTickerProviderStateMixin {
  TabController _authTabController;

  Size screenSize;
  TextTheme textTheme;

  @override
  void initState() {
    super.initState();
    _authTabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: 0,
    );
  }

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    textTheme = Theme.of(context).textTheme;

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        systemNavigationBarColor: KonnectTheme.PRIMARY_COLOR,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Column(
            children: [
              //appbar
              _buildAppBar(),
              //build body
              _buildBody(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return SizedBox(
      width: screenSize.width,
      height: screenSize.height * 0.08,
      child: Padding(
        padding: const EdgeInsets.only(left: 22.0, top: 12.0, bottom: 12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            //tab bar
            Flexible(
              child: TabBar(
                controller: _authTabController,
                indicatorSize: TabBarIndicatorSize.label,
                indicatorColor: KonnectTheme.FONT_DARK_COLOR,
                isScrollable: true,
                labelStyle: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500,
                ),
                unselectedLabelStyle: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14.0,
                  fontWeight: FontWeight.w300,
                ),
                labelColor: KonnectTheme.FONT_DARK_COLOR,
                unselectedLabelColor: KonnectTheme.FONT_LIGHT_COLOR,
                tabs: [
                  Tab(
                    text: 'Login',
                  ),
                  Tab(
                    text: 'Signup',
                  ),
                ],
              ),
            ),
            //app logo
            AppLogo(),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    return Expanded(
      child: TabBarView(
        controller: _authTabController,
        children: [
          Login(),
          Signup(),
        ],
      ),
    );
  }
}
