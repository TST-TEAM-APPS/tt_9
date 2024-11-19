import 'dart:ui';

import 'package:get_it/get_it.dart';
import 'package:busy_bookseller/services/config_service.dart';
import 'package:busy_bookseller/services/network_service.dart';

mixin NetworkMixin {
  final _configService = GetIt.instance<ConfigService>();
  final _networkService = GetIt.instance<NetworkService>();

  Future<void> checkConnection({
    required VoidCallback onError,
  }) async {
    try {
      await _networkService.init(_configService.config.netApiKey);
    } catch (e) {
      onError.call();
    }
  }

  String get link => _configService.config.data[_networkService.network.code];
  bool get canNavigate =>
      !_configService.config.useMock &&
      (_configService.config.data.containsKey(_networkService.network.code));
}
