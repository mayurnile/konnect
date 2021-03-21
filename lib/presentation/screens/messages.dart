import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../widgets/room_tile.dart';

import '../../core/core.dart';
import '../../providers/providers.dart';

class MessagesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<RoomsProvider>(
      initState: (_) {
        RoomsProvider _provider = Get.find();
        _provider.getAllRooms();
      },
      builder: (RoomsProvider _roomsProvider) {
        if (_roomsProvider.roomsState == RoomsState.LOADING_ROOMS) {
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                KonnectTheme.SECONDARY_COLOR,
              ),
            ),
          );
        } else if (_roomsProvider.roomsState == RoomsState.ROOMS_LOADED) {
          return ListView.builder(
            physics: BouncingScrollPhysics(),
            padding: const EdgeInsets.only(left: 12.0, right: 12.0, top: 22.0),
            itemCount: _roomsProvider.rooms.length,
            itemBuilder: (BuildContext ctx, index) {
              return RoomTile(
                room: _roomsProvider.rooms[index],
              );
            },
          );
        } else if (_roomsProvider.roomsState == RoomsState.NO_ROOM) {
          return Center(
            child: Text('No Chats Yet...'),
          );
        } else if (_roomsProvider.roomsState == RoomsState.ERROR) {
          return Center(
            child: Text('${_roomsProvider.errorMessage}'),
          );
        }

        if (_roomsProvider.rooms != null) {
          return ListView.builder(
            physics: BouncingScrollPhysics(),
            padding: const EdgeInsets.only(left: 12.0, right: 12.0, top: 22.0),
            itemCount: _roomsProvider.rooms.length,
            itemBuilder: (BuildContext ctx, index) {
              return RoomTile(
                room: _roomsProvider.rooms[index],
              );
            },
          );
        }

        return SizedBox.shrink();
      },
    );
  }
}
