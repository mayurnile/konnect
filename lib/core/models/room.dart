class Room {
  final String id;
  final String name;
  final String photoURL;
  final String phone;
  final String latestMessage;
  final DateTime timestamp;

  Room({
    required this.id,
    required this.name,
    required this.photoURL,
    required this.phone,
    required this.latestMessage,
    required this.timestamp,
  });
}
