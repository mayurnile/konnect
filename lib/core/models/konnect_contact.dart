import 'package:flutter/material.dart';

class KonnectContact {
  final String name;
  final String email;
  final String phone;
  final bool isRegistered;
  final String photoURL;

  KonnectContact({
    @required this.name,
    @required this.email,
    @required this.phone,
    @required this.isRegistered,
    @required this.photoURL,
  });
}
