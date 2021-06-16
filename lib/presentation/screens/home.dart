import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import '../../core/core.dart';
import '../widgets/app_title.dart';
import '../widgets/circular_button.dart';
import '../widgets/my_tab.dart';
import '../widgets/transparent_button.dart';
import '../../providers/auth_provider.dart';

import 'screens.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthProvider authProvider = Get.find();

  int _currentIndex = 0;

  List<Widget> _screens = [];

  @override
  void initState() {
    super.initState();

    _currentIndex = 0;
    _screens = [
      MessagesScreen(),
      MyStoryScreen(),
      CallsScreen(),
      CreateMessageScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final TextTheme textTheme = Theme.of(context).textTheme;

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: KonnectTheme.PRIMARY_COLOR,
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );

    return Scaffold(
      backgroundColor: KonnectTheme.PRIMARY_COLOR,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //app title
            _buildAppBar(),
            //stories list
            _buildStoriesList(screenSize),
            //tab bar
            _buildTabBar(screenSize, textTheme),
            //main bodt
            _buildMainBody(),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: [
          //app title
          AppTitle(),
          //actions
          CircularButton(
            onPressed: _logout,
            icon: Assets.LOGOUT,
            isSmall: true,
          ),
        ],
      ),
    );
  }

  Widget _buildStoriesList(Size screenSize) {
    return Padding(
      padding: const EdgeInsets.only(left: 22.0),
      child: Row(
        children: [
          //search Icon
          CircularButton(
            onPressed: () {},
            icon: Assets.SEARCH,
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar(Size screenSize, TextTheme textTheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: SizedBox(
        width: screenSize.width,
        height: screenSize.height * 0.04,
        child: ListView(
          padding: const EdgeInsets.only(left: 22.0),
          scrollDirection: Axis.horizontal,
          children: [
            //messages tab
            MyTab(
              title: 'Messages',
              isSelected: _currentIndex == 0,
              onTap: () => setState(() => _currentIndex = 0),
            ),
            //spacing
            SizedBox(
              width: 22.0,
            ),
            //my story tab
            MyTab(
              title: 'My Story',
              isSelected: _currentIndex == 1,
              onTap: () => setState(() => _currentIndex = 1),
            ),
            //spacing
            SizedBox(
              width: 22.0,
            ),
            //calls tab
            MyTab(
              title: 'Calls',
              isSelected: _currentIndex == 2,
              onTap: () => setState(() => _currentIndex = 2),
            ),
            //spacing
            SizedBox(
              width: 22.0,
            ),
            //create chat button
            TransparentButton(
              title: 'Create',
              onPressed: () => setState(() => _currentIndex = 3),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainBody() {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(22.0),
            topRight: Radius.circular(22.0),
          ),
        ),
        child: _screens[_currentIndex],
      ),
    );
  }

  void _logout() async {
    final result = await authProvider.logout();

    if (result) {
      Fluttertoast.showToast(msg: 'Logout Success!');
      locator.get<NavigationService>().removeAllAndPush(AUTH_ROUTE);
    } else {
      Fluttertoast.showToast(msg: 'Someting went wrong...');
    }
  }
}
