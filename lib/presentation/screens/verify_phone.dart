import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../../core/core.dart';
import '../widgets/widgets.dart';
import '../../providers/providers.dart';

class VerifyPhoneScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          leading: BackButton(
            color: KonnectTheme.FONT_DARK_COLOR,
          ),
          title: Text(
            'Verify Phone',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 16.0,
              color: KonnectTheme.FONT_DARK_COLOR,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //main body
            Expanded(child: _buildMainBody(screenSize, textTheme)),
            //bottom bar
            _buildBottomBar(screenSize, textTheme),
          ],
        ),
      ),
    );
  }

  Widget _buildMainBody(Size screenSize, TextTheme textTheme) {
    return GetBuilder<AuthProvider>(
      builder: (AuthProvider _authProvider) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              //top spacing
              SizedBox(height: screenSize.height * 0.0),
              //title
              SizedBox(
                width: screenSize.width,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text.rich(
                    TextSpan(
                      text: 'Just there...\n',
                      style: textTheme.headline1!
                          .copyWith(fontWeight: FontWeight.w300),
                      children: [
                        TextSpan(
                          text:
                              'Enter your phone number, we\'ll send\nan OTP for verification',
                          style: textTheme.headline2,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              //phone input
              MyTextField(
                hint: 'Phone Number',
                prefix: Text(
                  '+ 91      ',
                  textAlign: TextAlign.center,
                ),
                inputType: TextInputType.number,
                onChanged: (String? value) =>
                    _authProvider.setPhone = value!.trim(),
                suffix: InkWell(
                  onTap: () => _sendOTP(_authProvider),
                  child: Text(
                    'SEND',
                    style: textTheme.button!.copyWith(
                      color: KonnectTheme.PRIMARY_COLOR,
                      letterSpacing: 1.2,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              //otp input
              MyTextField(
                hint: 'OTP here',
                inputType: TextInputType.number,
                onChanged: (String? value) =>
                    _authProvider.setOTP = value!.trim(),
              ),
              //bottom spacing
              SizedBox(height: screenSize.height * 0.1),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBottomBar(Size screenSize, TextTheme textTheme) {
    return GetBuilder<AuthProvider>(
      builder: (AuthProvider _authProvider) {
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
                    child: _authProvider.authState ==
                            AuthState.AUTHENTICATING_PHONE
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
                    onPressed: _authProvider.authState ==
                            AuthState.AUTHENTICATING_PHONE
                        ? null
                        : () => _verifyPhone(_authProvider),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _sendOTP(AuthProvider provider) async {
    await provider.sendOTP();

    if (provider.authState == AuthState.PHONE_AUTHENTICATION_ERROR) {
      Fluttertoast.showToast(msg: 'Cannot send otp...');
    } else if (provider.authState == AuthState.OTP_SENT) {
      Fluttertoast.showToast(msg: 'OTP Sent Successfully !');
    }
  }

  void _verifyPhone(AuthProvider provider) async {
    await provider.verifyOTP();

    if (provider.authState == AuthState.PHONE_AUTHENTICATED) {
      Fluttertoast.showToast(msg: 'Login Success!');
      locator.get<NavigationService>().removeAllAndPush(HOME_ROUTE);
    } else if (provider.authState == AuthState.PHONE_AUTHENTICATION_ERROR) {
      Fluttertoast.showToast(msg: '${provider.authError}');
    }
  }
}
