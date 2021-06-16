import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import '../../../core/core.dart';
import '../text_input.dart';
import '../../../providers/auth_provider.dart';

class Login extends StatelessWidget {
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
            SizedBox(height: screenSize.height * 0.05),
            //title
            SizedBox(
              width: screenSize.width,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text.rich(
                  TextSpan(
                    text: 'Welcome Back,\n',
                    style: textTheme.headline1!
                        .copyWith(fontWeight: FontWeight.w300),
                    children: [
                      TextSpan(
                        text: 'Sign in to continue',
                        style: textTheme.headline2,
                      ),
                    ],
                  ),
                ),
              ),
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
            //social login options
            _buildSocialLoginOptions(),
            //bottom spacing
            SizedBox(height: screenSize.height * 0.05),
          ],
        ),
      );
    });
  }

  Widget _buildSocialLoginOptions() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        //facebook login
        SizedBox(
          width: 32.0,
          child: TextButton(
            onPressed: _facebookLogin,
            style: TextButton.styleFrom(
              padding: const EdgeInsets.all(0.0),
            ),
            child: SvgPicture.asset(
              Assets.FACEBOOK,
              height: 32.0,
              width: 32.0,
            ),
          ),
        ),
        //spacing
        SizedBox(width: 42.0),
        //google login
        SizedBox(
          width: 32.0,
          child: TextButton(
            onPressed: _googleLogin,
            style: TextButton.styleFrom(
              padding: const EdgeInsets.all(0.0),
            ),
            child: SvgPicture.asset(
              Assets.GOOGLE,
              height: 32.0,
              width: 32.0,
            ),
          ),
        ),
      ],
    );
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
            //login button
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
                      : () => _login(_authProvider),
                ),
              ),
            ),
            //forget password button
            Positioned(
              top: 0,
              left: 22.0,
              child: TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.all(0.0),
                ),
                child: Text(
                  'Forget Password ?',
                  style: TextStyle(
                    color: KonnectTheme.FONT_DARK_COLOR,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  void _login(AuthProvider provider) async {
    final bool result = await provider.login();
    print(result);
    if (result) {
      print('Navigate to OTP Screen');
      // Fluttertoast.showToast(msg: 'Login Success !');
      locator.get<NavigationService>().navigateToNamed(VERIFY_PHONE_ROUTE);
    } else {
      Fluttertoast.showToast(msg: 'Something went wrong...');
    }
  }

  void _googleLogin() async {
    AuthProvider _authProvider = Get.find();
    await _authProvider.loginWithGoogle();

    if (_authProvider.authState == AuthState.AUTHENTICATED) {
      // Fluttertoast.showToast(msg: 'Login Success !');
      locator.get<NavigationService>().navigateToNamed(VERIFY_PHONE_ROUTE);
    } else if (_authProvider.authState == AuthState.UNAUTHENTICATED) {
      Fluttertoast.showToast(msg: 'Error while logging in...');
    } else if (_authProvider.authState == AuthState.ERROR) {
      Fluttertoast.showToast(msg: 'Something went wrong...');
    }
  }

  void _facebookLogin() {}
}
