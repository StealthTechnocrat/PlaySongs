import 'package:get_it/get_it.dart';
import 'models/user_model.dart';


GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => UserDetailsModel());
}