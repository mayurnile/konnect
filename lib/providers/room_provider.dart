import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../core/core.dart';
import '../core/models/room.dart';
import 'auth_provider.dart';
import '../core/models/models.dart';

class RoomsProvider extends GetxController {
  late FirebaseFirestore _firestore;

  List<Room> _rooms = [];
  List<Message> _messages = [];
  RoomsState _state = RoomsState.LOADING_ROOMS;
  String _errorMessage = '';

  String _message = '';

  @override
  void onInit() {
    super.onInit();

    //initialize firebase
    _firestore = FirebaseFirestore.instance;
  }

  //setters
  set setMessage(String msg) => _message = msg;

  //getters
  get rooms => _rooms;
  get messages => _messages;
  get message => _message;
  get roomsState => _state;
  get errorMessage => _errorMessage;

  Future<void> sendMessage(String roomId, Message message) async {
    try {
      await _firestore
          .collection('rooms')
          .doc('$roomId')
          .collection('messages')
          .add(Message.toJSON(message: message));

      _message = '';
      update();
    } catch (e) {
      Fluttertoast.showToast(msg: '$e');
    }
  }

  Stream chatsStream(String roomId) {
    return _firestore
        .collection('rooms')
        .doc('$roomId')
        .collection('messages')
        .orderBy('created_time', descending: true)
        .limit(20)
        .snapshots();
  }

  List<Message> mapChatDocsToList(messagesQuerySnapshot) {
    List<Message> _listOfMessages = [];
    try {
      if (messagesQuerySnapshot.docs.length == 0) {
        _state = RoomsState.NO_CHAT;
        update();
        return _listOfMessages;
      }

      messagesQuerySnapshot.docs.forEach((messageDoc) {
        Map<String, dynamic>? data = messageDoc.data() as Map<String, dynamic>?;
        if (data != null) {
          Message message = Message.fromJSON(data);
          _listOfMessages.add(message);
        }
      });

      return _listOfMessages;
    } catch (e) {}
    return _listOfMessages;
  }

  Future<void> getAllMessagesFromRoom(String roomId) async {
    _messages = [];
    try {
      _state = RoomsState.LOADING_CHAT;

      QuerySnapshot messagesQuerySnapshot = await _firestore
          .collection('rooms')
          .doc('$roomId')
          .collection('messages')
          .get();

      if (messagesQuerySnapshot.docs.length == 0) {
        _state = RoomsState.NO_CHAT;
        update();
        return;
      }

      messagesQuerySnapshot.docs.forEach((messageDoc) {
        Map<String, dynamic>? data = messageDoc.data() as Map<String, dynamic>?;
        if (data != null) {
          Message message = Message.fromJSON(data);
          _messages.add(message);
        }
      });

      _messages.sort((a, b) => a.createdTime.isAfter(b.createdTime) ? 0 : 1);

      _state = RoomsState.CHAT_LOADED;
      update();
    } catch (e) {
      _state = RoomsState.ERROR;
      _errorMessage = 'Something went wrong...';
      update();
    }
  }

  Future<void> getAllRooms() async {
    _rooms = [];
    // try {
    _state = RoomsState.LOADING_ROOMS;
    update();

    await Future.delayed(Duration(seconds: 1));

    AuthProvider _authProvider = Get.find();
    String phoneNumber = _authProvider.phoneNumber;

    DocumentSnapshot roomsListSnapshot =
        await _firestore.collection('users').doc('$phoneNumber').get();

    List<dynamic>? roomsList = [];
    if (roomsListSnapshot.data() != null) {
      Map<String, dynamic> data =
          roomsListSnapshot.data() as Map<String, dynamic>;
      roomsList = data['rooms'];
    }

    if (roomsList != null) {
      for (int i = 0; i < roomsList.length; i++) {
        DocumentSnapshot membersSnapshot =
            await _firestore.collection('rooms').doc('${roomsList[i]}').get();
        Map<String, dynamic>? membersData;
        if (membersSnapshot.exists)
          membersData = membersSnapshot.data() as Map<String, dynamic>;
        List<dynamic> roomMembers =
            membersData != null ? membersData['members'] : [];
        String roomMemberNumber = '';
        roomMembers.forEach((member) {
          if (member != phoneNumber) roomMemberNumber = member;
        });

        DocumentSnapshot? memberSnapshot;
        if (roomMemberNumber.length != 0)
          memberSnapshot = await _firestore
              .collection('users')
              .doc('$roomMemberNumber')
              .get();

        if (memberSnapshot != null && memberSnapshot.exists) {
          Map<String, dynamic> memberData =
              memberSnapshot.data() as Map<String, dynamic>;

          String memberName = memberData['name'] ?? '';
          String photoURL = memberData['avatar'] ?? '';
          String phone = memberData['phoneNumber'] ?? '';
          QuerySnapshot messagesSnapshot = await _firestore
              .collection('rooms')
              .doc('${roomsList[i]}')
              .collection('messages')
              .orderBy('created_time', descending: true)
              .limit(1)
              .get();

          Map<String, dynamic> messageData = {};
          if (messagesSnapshot.docs.isNotEmpty)
            messageData =
                messagesSnapshot.docs.first.data() as Map<String, dynamic>;
          String latestMessage = messagesSnapshot.docs.isEmpty
              ? 'No messages yet...'
              : messageData['message'];
          DateTime timestamp = messagesSnapshot.docs.isEmpty
              ? DateTime(1999)
              : DateTime.parse(messageData['created_time']);

          Room incomingRoom = Room(
            id: roomsList[i],
            name: memberName,
            photoURL: photoURL,
            latestMessage: latestMessage,
            timestamp: timestamp,
            phone: phone,
          );

          _rooms.add(incomingRoom);
        }
        // _rooms.sort((a, b) => a.timestamp.isAfter(b.timestamp) ? 0 : 1);

        _state = RoomsState.ROOMS_LOADED;
        update();
      }
    } else {
      _state = RoomsState.NO_ROOM;
      update();
    }
    // } catch (e) {
    //   _state = RoomsState.ERROR;
    //   _errorMessage = 'Something went wrong...';
    //   update();
    // }
  }

  Future<void> createRoom(
    KonnectContact friendContact,
    String myNumber,
    String friendPhone,
  ) async {
    try {
      DocumentSnapshot snapshot =
          await _firestore.collection('users').doc('$myNumber').get();

      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

      List<String> _friends = [];
      if (data['friends'] != null) _friends = List.from(data['friends']);
      // if (_friends.length > 0) {
      //   data['friends'].forEach((dat) {
      //     String d = dat as String;
      //     _friends.add(d);
      //   });
      // }

      bool isPresent = false;

      if (_friends.length > 0)
        isPresent = _friends.contains(friendPhone.trim());

      if (isPresent) {
        QuerySnapshot roomSnapshot = await _firestore
            .collection('rooms')
            .where('members', arrayContains: friendContact.phone.trim())
            .get();

        roomSnapshot.docs.forEach((room) {
          Map<String, dynamic> roomData = room.data() as Map<String, dynamic>;

          List<dynamic> roomMembers = roomData['members'];
          if (roomMembers.contains(myNumber)) {
            String roomId = room.id;
            locator.get<NavigationService>().navigateToNamed(
              CHAT_ROUTE,
              arguments: {
                'roomId': roomId,
                'receiverContact': friendContact,
              },
            );
          }
        });
      } else {
        await _firestore.collection('rooms').add({
          'members': [myNumber, friendPhone],
        }).then((docRef) async {
          String roomId = docRef.id;
          DocumentSnapshot userSnapshot =
              await _firestore.collection('users').doc('$myNumber').get();

          DocumentSnapshot friendSnapshot =
              await _firestore.collection('users').doc('$friendPhone').get();

          Map<String, dynamic> userData =
              userSnapshot.data() as Map<String, dynamic>;

          Map<String, dynamic> friendData =
              friendSnapshot.data() as Map<String, dynamic>;
          List<String> userRooms = userData['rooms'] == null
              ? []
              : List<String>.from(userData['rooms']);
          List<String> friendRooms = friendData['rooms'] == null
              ? []
              : List<String>.from(friendData['rooms']);

          userRooms.add(roomId);
          friendRooms.add(roomId);

          List<String> userFriends = userData['friends'] == null
              ? []
              : List<String>.from(userData['friends']);
          List<String> friendsFriends = friendData['friends'] == null
              ? []
              : List<String>.from(friendData['friends']);

          userFriends.add('$friendPhone');
          friendsFriends.add('$myNumber');

          await _firestore.collection('users').doc('$myNumber').update({
            'rooms': userRooms,
          });
          await _firestore.collection('users').doc('$friendPhone').update({
            'rooms': friendRooms,
          });
          await _firestore.collection('users').doc('$myNumber').update({
            'friends': userFriends,
          });
          await _firestore.collection('users').doc('$friendPhone').update({
            'friends': friendsFriends,
          });
          locator.get<NavigationService>().navigateToNamed(
            CHAT_ROUTE,
            arguments: {
              'roomId': roomId,
              'receiverContact': friendContact,
            },
          );
        });
      }
    } catch (e) {
      print(e);
    }
  }
}

enum RoomsState {
  LOADING_ROOMS,
  LOADING_CHAT,
  ROOMS_LOADED,
  CHAT_LOADED,
  NO_ROOM,
  NO_CHAT,
  ERROR
}
