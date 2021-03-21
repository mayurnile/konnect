import 'package:get/get.dart';
import '../../providers/auth_provider.dart';
import '../../providers/providers.dart';
import 'package:share/share.dart';
import 'package:flutter/material.dart';

import '../../core/core.dart';
import '../../core/models/models.dart';

class ContactTile extends StatelessWidget {
  final KonnectContact contact;

  ContactTile({Key key, @required this.contact}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: ListTile(
        leading: _buildLeadingWidget(),
        title: Text(
          contact.name,
          style: textTheme.headline4.copyWith(fontWeight: FontWeight.w600),
        ),
        trailing: _buildTrailingWidget(),
      ),
    );
  }

  Widget _buildLeadingWidget() {
    return contact.photoURL != null && contact.photoURL.length != 0
        ? CircleAvatar(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(100.0),
              child: Image.network(contact.photoURL),
            ),
          )
        : CircleAvatar(
            backgroundColor: KonnectTheme.PRIMARY_COLOR,
            child: Text(
              contact.name.substring(0, 1),
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
  }

  Widget _buildTrailingWidget() {
    return contact.isRegistered
        ? FlatButton(
            padding: const EdgeInsets.all(0.0),
            onPressed: () async {
              AuthProvider authProvider = Get.find();
              RoomsProvider provider = Get.find();
              await provider.createRoom(
                  contact, authProvider.phoneNumber, contact.phone);
            },
            child: Text(
              'Chat',
              style: TextStyle(color: KonnectTheme.SECONDARY_COLOR),
            ),
          )
        : FlatButton(
            padding: const EdgeInsets.all(0.0),
            onPressed: () {
              Share.share(
                'Join in to our community of privacy lovers, by using Konnect over other chat applications, here is the download link : *App Link*',
              );
            },
            child: Text(
              'Invite',
              style: TextStyle(color: KonnectTheme.PRIMARY_COLOR),
            ),
          );
  }
}
