import 'package:get/get.dart';

import 'locator.dart';
import '../../providers/providers.dart';

void initProviders() {
  //auth Provider
  AuthProvider authProvider = Get.put(AuthProvider());
  locator.registerLazySingleton(() => authProvider);

  //contact Provider
  ContactsProvider contactsProvider = Get.put(ContactsProvider());
  locator.registerLazySingleton(() => contactsProvider);

  //story provider
  StoryProvider storyProvider = Get.put(StoryProvider());
  locator.registerLazySingleton(() => storyProvider);

  //rooms provider
  RoomsProvider roomsProvider = Get.put(RoomsProvider());
  locator.registerSingleton(() => roomsProvider);
}
