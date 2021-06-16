class Story {
  final String? id;
  final String photoURL;
  final String email;
  final String name;
  final DateTime? createdTime;

  Story({
    this.id,
    required this.photoURL,
    required this.email,
    required this.name,
    required this.createdTime,
  });

  factory Story.fromJSON(Map<String, dynamic> json, String id) {
    return Story(
      id: id,
      photoURL: json['photoURL'],
      email: json['email'],
      name: json['name'],
      createdTime: DateTime.tryParse(json['created_time'] as String),
    );
  }

  static Map<String, dynamic> toJSON({required Story storyModel}) {
    return {
      "id": storyModel.id,
      "photoURL": storyModel.photoURL,
      "email": storyModel.email,
      "name": storyModel.name,
      "created_time": storyModel.createdTime!.toIso8601String(),
    };
  }
}
