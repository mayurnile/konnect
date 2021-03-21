import 'dart:async';

import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../core/core.dart';

class AuthProvider extends GetxController {
  FirebaseAuth _firebaseAuth;

  String _name;
  String _email;
  String _phoneNumber;
  String _otp;
  String _phoneVerificationId;
  String _photoURL;
  String _password;
  String _confirmPassword;
  bool _showPassword;
  bool _showConfirmPassword;
  AuthState _state;
  String _errorMessage;
  bool _isLoggingIn = false;

  @override
  void onInit() {
    super.onInit();

    //initialize firebase
    _firebaseAuth = FirebaseAuth.instance;

    //initialize variables
    _name = '';
    _email = '';
    _phoneNumber = '';
    _otp = '';
    _phoneVerificationId = '';
    _photoURL = '';
    _password = '';
    _confirmPassword = '';
    _errorMessage = '';
    _showPassword = true;
    _showConfirmPassword = true;
    _state = AuthState.UNAUTHENTICATED;
  }

  //setter
  set setName(String nm) => _name = nm;
  set setEmail(String em) => _email = em;
  set setPhone(String ph) => _phoneNumber = ph;
  set setOTP(String otp) => _otp = otp;
  set setPassword(String pw) => _password = pw;
  set setConfirmPassword(String cpw) => _confirmPassword = cpw;
  void toggleShowPassword() {
    _showPassword = !_showPassword;
    update();
  }

  void toggleShowConfirmPassword() {
    _showConfirmPassword = !_showConfirmPassword;
    update();
  }

  //getters
  get name => _name;
  get email => _email;
  get phoneNumber => _phoneNumber;
  get photoURL => _photoURL;
  get password => _password;
  get confirmPassword => _confirmPassword;
  get authState => _state;
  get authError => _errorMessage;
  get showPassword => _showPassword;
  get showConfirmPassword => _showConfirmPassword;
  get firebaseAuth => _firebaseAuth;

  ///[Login method]
  ///Return true if login is success or false if unsuccess
  Future<bool> login() async {
    _isLoggingIn = true;
    _setLoadingState();
    try {
      final User user = (await _firebaseAuth.signInWithEmailAndPassword(
              email: email, password: password))
          .user;

      if (user != null) {
        _state = AuthState.AUTHENTICATED;
        update();
        return true;
      } else {
        _state = AuthState.ERROR;
        _errorMessage = 'Something went wrong';
        update();
        return false;
      }
    } catch (_) {
      _state = AuthState.UNAUTHENTICATED;
      update();
    }
    return false;
  }

  Future<void> loginWithGoogle() async {
    _setLoadingState();
    try {
      GoogleSignIn _googleSignIn = GoogleSignIn();

      bool isSignedIn = await _googleSignIn.isSignedIn();

      if (isSignedIn) {
        _state = AuthState.AUTHENTICATED;
        update();
      } else {
        final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        final User user =
            (await _firebaseAuth.signInWithCredential(credential)).user;

        isSignedIn = await _googleSignIn.isSignedIn();

        if (isSignedIn) {
          _name = user.displayName;
          _email = user.email;
          _photoURL = user.photoURL;

          _state = AuthState.AUTHENTICATED;
          update();
        } else {
          _state = AuthState.UNAUTHENTICATED;
          update();
        }
      }
    } catch (e) {
      print(e);
      _state = AuthState.ERROR;
      update();
    }
  }

  Future<void> sendOTP() async {
    PhoneVerificationCompleted verificationCompleted =
        (PhoneAuthCredential phoneAuthCredential) async {
      _state = AuthState.PHONE_AUTHENTICATED;
      update();

      await addUserData();

      locator.get<NavigationService>().removeAllAndPush(HOME_ROUTE);
    };

    PhoneVerificationFailed verificationFailed =
        (FirebaseAuthException authException) {
      _state = AuthState.PHONE_AUTHENTICATION_ERROR;
      update();
    };

    PhoneCodeSent codeSent =
        (String verificationId, [int forceResendingToken]) async {
      _phoneVerificationId = verificationId;
      _state = AuthState.OTP_SENT;
      update();
    };

    PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) {
      _phoneVerificationId = verificationId;
      _state = AuthState.OTP_SENT;
      update();
    };

    try {
      await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: '+91 ${_phoneNumber.trim()}',
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
      );

      _state = AuthState.OTP_SENT;
      update();
    } catch (_) {
      _state = AuthState.PHONE_AUTHENTICATION_ERROR;
      update();
    }
  }

  Future<void> verifyOTP() async {
    _state = AuthState.AUTHENTICATING_PHONE;
    update();

    try {
      final AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _phoneVerificationId,
        smsCode: _otp,
      );

      final User user =
          (await _firebaseAuth.signInWithCredential(credential)).user;

      if (user != null) {
        if (_isLoggingIn)
          await fetchUserDetails(user.email);
        else
          await addUserData();
        _state = AuthState.PHONE_AUTHENTICATED;
        update();
      } else {
        _state = AuthState.PHONE_AUTHENTICATION_ERROR;
        _errorMessage = 'Invalid OTP';
        update();
      }
    } catch (e) {
      print('$e');
      _state = AuthState.PHONE_AUTHENTICATION_ERROR;
      _errorMessage = 'Invalid OTP';
      update();
    }
  }

  Future<void> addUserData() async {
    FirebaseFirestore _firestore = FirebaseFirestore.instance;

    DocumentSnapshot snapshot =
        await _firestore.collection('users').doc('$_phoneNumber').get();

    if (!snapshot.exists) {
      await _firestore.collection('users').doc('$_phoneNumber').set({
        'name': _name,
        'email': _email,
        'avatar': _photoURL,
        'phoneNumber': _phoneNumber,
      });
    } else {
      if (_name == null) {
        await _firestore.collection('users').doc('$_phoneNumber').update({
          'email': _email,
          'avatar': _photoURL,
          'phoneNumber': _phoneNumber,
        });
      } else if (_name == null && _email == null) {
        await _firestore.collection('users').doc('$_phoneNumber').update({
          'avatar': _photoURL,
          'phoneNumber': _phoneNumber,
        });
      } else if (_name == null && _email == null && _photoURL == null) {
        await _firestore.collection('users').doc('$_phoneNumber').update({
          'phoneNumber': _phoneNumber,
        });
      } else {
        await _firestore.collection('users').doc('$_phoneNumber').update({
          'name': _name,
          'email': _email,
          'avatar': _photoURL,
          'phoneNumber': _phoneNumber,
        });
      }
    }
  }

  ///[Signup method]
  ///Return true if signup is success or false if unsuccess
  Future<bool> signup() async {
    _setLoadingState();
    try {
      final User user = (await _firebaseAuth.createUserWithEmailAndPassword(
              email: email, password: password))
          .user;

      if (user != null) {
        _email = user.email;
        _photoURL = user.photoURL;

        await _firebaseAuth.signOut();

        _state = AuthState.AUTHENTICATED;
        update();
        return true;
      } else {
        _state = AuthState.ERROR;
        _errorMessage = 'Something went wrong';
        update();
        return false;
      }
    } catch (_) {
      _state = AuthState.UNAUTHENTICATED;
      update();
    }
    return false;
  }

  ///[Logout method]
  ///Return true if logout is success or false if unsuccess
  Future<bool> logout() async {
    _setLoadingState();
    try {
      await _firebaseAuth.signOut();

      _state = AuthState.UNAUTHENTICATED;
      update();
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<void> fetchUserDetails(String phoneNumber) async {
    FirebaseFirestore _firestore = FirebaseFirestore.instance;

    String searchString =
        phoneNumber.contains('+91') ? phoneNumber.substring(3) : phoneNumber;
    DocumentSnapshot snapshot =
        await _firestore.collection('users').doc('$searchString').get();

    Map<String, dynamic> data = snapshot.data();

    _email = data['email'];
    _name = data['name'];
    _phoneNumber = data['phoneNumber'];
    update();
  }

  ///[Setting State as Loading]
  void _setLoadingState() {
    _state = AuthState.AUTHENTICATING;
    update();
  }
}

enum AuthState {
  AUTHENTICATED,
  UNAUTHENTICATED,
  AUTHENTICATING,
  AUTHENTICATING_PHONE,
  OTP_SENT,
  PHONE_AUTHENTICATED,
  PHONE_AUTHENTICATION_ERROR,
  ERROR,
}
