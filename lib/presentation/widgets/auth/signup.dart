import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import '../../../core/core.dart';
import '../text_input.dart';
import '../../../providers/auth_provider.dart';

class Signup extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //main body
        Expanded(
          child: _buildMainBody(screenSize, textTheme),
        ),
        //bottom bar
        _buildBottomBar(screenSize, textTheme),
      ],
    );
  }

  Widget _buildMainBody(Size screenSize, TextTheme textTheme) {
    return GetBuilder<AuthProvider>(builder: (AuthProvider _authProvider) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            //top spacing
            SizedBox(height: screenSize.height * 0.02),
            //title
            SizedBox(
              width: screenSize.width,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text.rich(
                  TextSpan(
                    text: 'Hello There,\n',
                    style: textTheme.headline1!
                        .copyWith(fontWeight: FontWeight.w300),
                    children: [
                      TextSpan(
                        text:
                            'Signup by entering information or\nusing social account',
                        style: textTheme.headline2,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            //name input
            MyTextField(
              hint: 'Name',
              inputType: TextInputType.text,
              onChanged: (String? value) =>
                  _authProvider.setName = value!.trim(),
            ),
            //email input
            MyTextField(
              hint: 'Email address',
              inputType: TextInputType.emailAddress,
              onChanged: (String? value) =>
                  _authProvider.setEmail = value!.trim(),
            ),
            //password input
            MyTextField(
              hint: 'Password',
              inputType: TextInputType.visiblePassword,
              onChanged: (String? value) =>
                  _authProvider.setPassword = value!.trim(),
            ),
            //password  again input
            MyTextField(
              hint: 'Password again',
              inputType: TextInputType.visiblePassword,
              onChanged: (String? value) =>
                  _authProvider.setConfirmPassword = value!.trim(),
            ),
            //bottom spacing
            SizedBox(height: screenSize.height * 0.02),
          ],
        ),
      );
    });
  }

  Widget _buildBottomBar(Size screenSize, TextTheme textTheme) {
    return GetBuilder<AuthProvider>(builder: (AuthProvider _authProvider) {
      return SizedBox(
        width: screenSize.width,
        height: screenSize.height * 0.14,
        child: Stack(
          children: [
            //bar
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              top: 52.0,
              child: Container(
                color: KonnectTheme.PRIMARY_COLOR,
              ),
            ),
            //signup button
            Positioned(
              top: 16.0,
              right: 22.0,
              child: SizedBox(
                width: screenSize.width * 0.15,
                height: screenSize.width * 0.15,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 0.0,
                    primary: KonnectTheme.SECONDARY_COLOR,
                  ),
                  child: _authProvider.authState == AuthState.AUTHENTICATING
                      ? SizedBox(
                          height: 24.0,
                          width: 24.0,
                          child: Center(
                            child: CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          ),
                        )
                      : Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                        ),
                  onPressed: _authProvider.authState == AuthState.AUTHENTICATING
                      ? null
                      : () => _signup(_authProvider),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  void _signup(AuthProvider provider) async {
    final bool result = await provider.signup();

    if (result) {
      locator.get<NavigationService>().navigateToNamed(VERIFY_PHONE_ROUTE);
    } else {
      Fluttertoast.showToast(msg: 'Something went wrong...');
    }
  }
}
