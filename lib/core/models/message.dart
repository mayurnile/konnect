class Message {
  final String message;
  final String sender;
  final DateTime createdTime;

  Message({
    required this.message,
    required this.sender,
    required this.createdTime,
  });

  factory Message.fromJSON(Map<String, dynamic>? data) {
    return Message(
      message: data != null ? data['message'] ?? '' : '',
      sender: data != null ?  data['sender'] ?? '' : '',
      createdTime: data != null ? DateTime.parse(data['created_time']) : DateTime(1999),
    );
  }

  static Map<String, dynamic> toJSON({required Message message}) {
    return {
      'message': message.message,
      'sender' : message.sender,
      'created_time': message.createdTime.toIso8601String(),
    };
  }
}
