import 'package:flutter/material.dart';

class Message {
  final String message;
  final String sender;
  final DateTime createdTime;

  Message({
    @required this.message,
    @required this.sender,
    @required this.createdTime,
  });

  factory Message.fromJSON(Map<String, dynamic> data) {
    return Message(
      message: data['message'],
      sender: data['sender'],
      createdTime: DateTime.parse(data['created_time']),
    );
  }

  static Map<String, dynamic> toJSON(Message message) {
    return {
      'message': message.message,
      'sender' : message.sender,
      'created_time': message.createdTime.toIso8601String(),
    };
  }
}
