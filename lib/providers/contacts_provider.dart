import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:permission_handler/permission_handler.dart';

import '../core/models/models.dart';

class ContactsProvider extends GetxController {
  FirebaseFirestore _firestore;

  List<KonnectContact> _contacts = [];
  ContactsState _state;
  String _errorMessage;

  @override
  void onInit() {
    super.onInit();

    //initialize firebase
    _firestore = FirebaseFirestore.instance;

    //initialize variables
    _contacts = [];
    _errorMessage = '';
    _state = ContactsState.LOADING;
  }

  get contacts => _contacts;
  get contactsState => _state;
  get errorMessage => _errorMessage;

  Future<void> loadContacts() async {
    _contacts = [];
    try {
      _state = ContactsState.LOADING;
      update();

      Iterable<Contact> deviceContacts = [];

      Map<Permission, PermissionStatus> permissions = await [
        Permission.contacts,
      ].request();

      if (permissions[Permission.contacts] == PermissionStatus.granted) {
        deviceContacts = await ContactsService.getContacts(
          withThumbnails: false,
        );
      } else if (permissions[Permission.contacts] == PermissionStatus.denied) {
        _state = ContactsState.ERROR;
        _errorMessage = 'Contacts Permission Denied';
        update();
        return;
      }

      deviceContacts.forEach((contact) async {
        if (contact.phones.isNotEmpty) {
          String noSpacePhone =
              contact.phones.first.value.toString().replaceAll(' ', '');
          String noDashPhone = noSpacePhone.replaceAll('-', '');
          String searchString = noDashPhone.contains('+')
              ? noDashPhone.substring(3)
              : noDashPhone;

          DocumentSnapshot snapshot =
              await _firestore.collection('users').doc('$searchString').get();

          if (snapshot.exists) {
            Map<String, dynamic> data = snapshot.data();
            String name =
                data['name'].length == 0 ? contact.displayName : data['name'];
            String email = data['email'].length == 0 ? '' : data['email'];
            String phoneNumber = data['phoneNumber'];
            String photoURL = data['avatar'];

            KonnectContact myContact = KonnectContact(
              name: name,
              email: email,
              phone: phoneNumber,
              isRegistered: true,
              photoURL: photoURL,
            );

            _contacts.insert(0, myContact);
          } else {
            KonnectContact myContact = KonnectContact(
              name: contact.displayName,
              email:
                  contact.emails.isNotEmpty ? contact.emails.first.value : '',
              phone: contact.phones.first.value,
              isRegistered: false,
              photoURL: '',
            );

            _contacts.add(myContact);
          }
        }
      });

      await Future.delayed(Duration(seconds: 5));

      if (deviceContacts.isEmpty) {
        _state = ContactsState.NO_CONTACTS;
        update();
      } else {
        _state = ContactsState.LOADED;
        update();
      }
    } catch (e) {
      _state = ContactsState.ERROR;
      update();
      print(e);
    }
  }
}

enum ContactsState { LOADING, LOADED, NO_CONTACTS, ERROR }
