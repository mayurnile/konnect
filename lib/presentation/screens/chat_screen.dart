import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../widgets/widgets.dart';

import '../../core/core.dart';
import '../../core/models/models.dart';
import '../../providers/providers.dart';

class ChatScreen extends StatefulWidget {
  final String roomId;
  final KonnectContact receiverContact;

  ChatScreen({
    Key key,
    @required this.roomId,
    @required this.receiverContact,
  }) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: KonnectTheme.PRIMARY_COLOR,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //app title
            _buildAppBar(screenSize, textTheme),
            //build chats
            _buildChats(),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(Size screenSize, TextTheme textTheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          //back button
          BackButton(
            color: Colors.white,
          ),
          //spacing
          SizedBox(width: 12.0),
          //avatar
          _buildUserAvatar(),
          //spacing
          SizedBox(width: 8.0),
          //name
          SizedBox(
            width: screenSize.width * 0.4,
            child: Text(
              widget.receiverContact.name,
              style: textTheme.headline4.copyWith(color: Colors.white),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          //spacing
          Spacer(),
          //call button
          CircularButton(
            onPressed: () {},
            icon: Assets.CALL,
            isSmall: true,
          ),
        ],
      ),
    );
  }

  Widget _buildUserAvatar() {
    return widget.receiverContact.photoURL != null
        ? CircleAvatar(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(52.0),
              child: Image.network(widget.receiverContact.photoURL),
            ),
          )
        : CircleAvatar(
            backgroundColor: KonnectTheme.SECONDARY_COLOR,
            child: Text(
              widget.receiverContact.name.substring(0, 1),
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
  }

  Widget _buildChats() {
    return Expanded(
      child: Stack(
        children: [
          //chats
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(22.0),
                  topRight: Radius.circular(22.0),
                ),
              ),
              child: GetBuilder<RoomsProvider>(
                initState: (_) {
                  RoomsProvider _roomsProvider = Get.find();
                  _roomsProvider.getAllMessagesFromRoom(widget.roomId);
                },
                builder: (RoomsProvider _roomsProvider) {
                  if (_roomsProvider.roomsState == RoomsState.LOADING_CHAT) {
                    return Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          KonnectTheme.SECONDARY_COLOR,
                        ),
                      ),
                    );
                  } else if (_roomsProvider.roomsState ==
                      RoomsState.CHAT_LOADED) {
                    return ListView.builder(
                      reverse: true,
                      physics: BouncingScrollPhysics(),
                      padding: const EdgeInsets.only(bottom: 72.0),
                      itemCount: _roomsProvider.messages.length,
                      itemBuilder: (BuildContext ctx, index) {
                        return ChatBubble(
                          message: _roomsProvider.messages[index],
                        );
                      },
                    );
                  } else if (_roomsProvider.roomsState == RoomsState.NO_CHAT) {
                    return Center(
                      child: Text('No Chats Yet...'),
                    );
                  } else if (_roomsProvider.roomsState == RoomsState.ERROR) {
                    return Center(
                      child: Text('${_roomsProvider.errorMessage}'),
                    );
                  }

                  return SizedBox.shrink();
                },
              ),
            ),
          ),
          //message input
          Positioned(
            left: 22.0,
            right: 22.0,
            bottom: 12.0,
            child: _buildMessageInput(),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return GetBuilder<RoomsProvider>(builder: (RoomsProvider _roomsProvider) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(52.0),
          color: KonnectTheme.CARD_COLOR,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //mesage input
            Flexible(
              child: TextFormField(
                controller: _messageController,
                onChanged: (String value) =>
                    _roomsProvider.setMessage = value.trim(),
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  hintText: 'Type your message',
                  border: InputBorder.none,
                ),
              ),
            ),
            //send button
            InkWell(
              onTap: () async {
                AuthProvider _authProvider = Get.find();
                Message message = Message(
                  createdTime: DateTime.now(),
                  message: _roomsProvider.message,
                  sender: _authProvider.phoneNumber,
                );

                await _roomsProvider.sendMessage(widget.roomId, message);
                _messageController.text = '';
                _roomsProvider.getAllMessagesFromRoom(widget.roomId);
              },
              child: Container(
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: KonnectTheme.PRIMARY_COLOR,
                ),
                alignment: Alignment.center,
                child: SvgPicture.asset(
                  Assets.SEND,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
