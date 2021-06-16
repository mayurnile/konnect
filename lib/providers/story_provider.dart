import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../core/models/models.dart';

class StoryProvider extends GetxController {
  late FirebaseFirestore _firestore;
  late FirebaseStorage _firebaseStorage;

  List<Story> _stories = [];
  StoriesState _state = StoriesState.LOADING;

  @override
  void onInit() {
    super.onInit();

    //initialize firebase
    _firestore = FirebaseFirestore.instance;
    _firebaseStorage = FirebaseStorage.instance;
  }

  get stores => _stories;
  get storiesState => _state;

  Future<void> loadStories() async {
    _state = StoriesState.NO_STORIES;
    update();
  }
}

enum StoriesState { LOADING, LOADED, NO_STORIES }
