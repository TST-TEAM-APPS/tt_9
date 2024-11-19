import 'package:get_it/get_it.dart';
import 'package:busy_bookseller/services/config_service.dart';
import 'package:busy_bookseller/services/network_service.dart';

class ServiceLocator {
  static Future<void> setup() async {
    GetIt.instance.registerLazySingletonAsync<ConfigService>(()=> ConfigService().init());
    await GetIt.instance.isReady<ConfigService>();
    GetIt.instance.registerSingleton<NetworkService>(NetworkService());
  }
}
