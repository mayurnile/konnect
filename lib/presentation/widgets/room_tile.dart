import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/core.dart';

import '../../core/models/models.dart';

class RoomTile extends StatelessWidget {
  final Room room;

  RoomTile({@required this.room});

  @override
  Widget build(BuildContext context) {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final Size screenSize = MediaQuery.of(context).size;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return InkWell(
      onTap: () {
        KonnectContact friendContact = KonnectContact(
          name: room.name,
          email: '',
          isRegistered: true,
          phone: room.phone,
          photoURL: room.photoURL,
        );

        locator.get<NavigationService>().navigateToNamed(
          CHAT_ROUTE,
          arguments: {
            'roomId': room.id,
            'receiverContact': friendContact,
          },
        );
      },
      child: SizedBox(
        width: screenSize.width,
        height: screenSize.height * 0.11,
        child: Padding(
          padding: const EdgeInsets.only(top: 14.0),
          child: StreamBuilder<List<Message>>(
            stream: firestore
                .collection('rooms')
                .doc(room.id)
                .collection('messages')
                .orderBy('timestamp', descending: true)
                .limit(1)
                .snapshots()
                .map(
                  (event) => event.docs
                      .map((doc) => Message.fromJSON(doc.data()))
                      .toList(),
                ),
            builder:
                (BuildContext context, AsyncSnapshot<List<Message>> snapshot) {
              if (snapshot.hasData) {
                Message message;
                message = snapshot.data.isNotEmpty
                    ? snapshot.data.first
                    : Message(
                        createdTime: null,
                        message: '',
                        sender: '',
                      );

                //name and message
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      //circle avatar
                      Transform.translate(
                        offset: Offset(0, -8.0),
                        child: _buildRoomAvatar(),
                      ),
                      //spacing
                      SizedBox(
                        width: 16.0,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            //sender name
                            SizedBox(
                              width: screenSize.width * 0.6,
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  room.name,
                                  key: ValueKey('receiver'),
                                  style: textTheme.headline4
                                      .copyWith(fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                            //latest message
                            SizedBox(
                              width: screenSize.width * 0.6,
                              height: screenSize.height * 0.05,
                              child: Text(
                                room.latestMessage,
                                key: ValueKey('message'),
                                softWrap: true,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: textTheme.subtitle2.copyWith(
                                    color: KonnectTheme.FONT_LIGHT_COLOR),
                              ),
                            ),
                          ],
                        ),
                      ),
                      //message details
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          //message time
                          FittedBox(
                            child: Text(
                              room.timestamp.getChatMessageTimeFormat(),
                              key: ValueKey('timestamp'),
                            ),
                          ),
                          //spacing
                          SizedBox(height: 8.0),
                          //new message count
                          /*Container(
                            height: screenSize.height * 0.03,
                            width: screenSize.height * 0.03,
                            padding: const EdgeInsets.all(2.0),
                            decoration: BoxDecoration(
                              color: SacredGrovesTheme.FONT_PRIMARY_DARK_COLOR,
                              borderRadius: BorderRadius.circular(24.0),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              '1',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),*/
                        ],
                      ),
                    ],
                  ),
                );
              } else if (snapshot.hasError) {
                return Text(snapshot.error.toString());
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildRoomAvatar() {
    return room.photoURL != null
        ? CircleAvatar(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(52.0),
              child: Image.network(room.photoURL),
            ),
          )
        : CircleAvatar(
            backgroundColor: KonnectTheme.SECONDARY_COLOR,
            child: Text(
              room.name.substring(0, 1),
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
  }
}
