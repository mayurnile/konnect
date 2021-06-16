import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../../core/core.dart';
import '../../core/models/models.dart';
import '../../providers/providers.dart';

class ChatBubble extends StatelessWidget {
  final Message message;

  ChatBubble({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final TextTheme textTheme = Theme.of(context).textTheme;

    AuthProvider _authProvider = Get.find();

    bool _isMyMessage = message.sender == _authProvider.phoneNumber;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 12.0),
      child: Column(
        crossAxisAlignment:
            _isMyMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment:
                _isMyMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              //message
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: screenSize.width * 0.7,
                ),
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: _isMyMessage
                        ? KonnectTheme.RECEIVER_CARD_COLOR
                        : KonnectTheme.SENDER_CARD_COLOR,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12.0),
                      topRight: Radius.circular(12.0),
                      bottomLeft: Radius.circular(_isMyMessage ? 12.0 : 0.0),
                      bottomRight: Radius.circular(_isMyMessage ? 0.0 : 12.0),
                    ),
                  ),
                  child: Text(
                    message.message,
                    style: textTheme.headline5,
                  ),
                ),
              ),
            ],
          ),
          //time
          Text(message.createdTime.getChatMessageTimeFormat()),
        ],
      ),
    );
  }
}
