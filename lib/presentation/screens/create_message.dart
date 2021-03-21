import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../widgets/contact_tile.dart';

import '../../core/core.dart';
import '../../providers/providers.dart';

class CreateMessageScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ContactsProvider>(
      initState: (_) {
        ContactsProvider contactsProvider = Get.find();
        contactsProvider.loadContacts();
      },
      builder: (ContactsProvider _contactsProvider) {
        if (_contactsProvider.contactsState == ContactsState.LOADING) {
          return Center(
            child: CircularProgressIndicator(
              valueColor:
                  AlwaysStoppedAnimation<Color>(KonnectTheme.SECONDARY_COLOR),
            ),
          );
        } else if (_contactsProvider.contactsState == ContactsState.ERROR) {
          return Center(
            child: Text('${_contactsProvider.errorMessage}'),
          );
        } else if (_contactsProvider.contactsState ==
            ContactsState.NO_CONTACTS) {
          return Center(
            child: Text('No Contacts Available...'),
          );
        } else if (_contactsProvider.contactsState == ContactsState.LOADED) {
          return ListView.builder(
            physics: BouncingScrollPhysics(),
            padding: const EdgeInsets.only(top: 32.0, left: 12.0),
            itemCount: _contactsProvider.contacts.length,
            itemBuilder: (BuildContext ctx, int index) {
              return ContactTile(
                contact: _contactsProvider.contacts[index],
              );
            },
          );
        }
        return SizedBox.shrink();
      },
    );
  }
}
