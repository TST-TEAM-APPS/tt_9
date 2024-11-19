import 'dart:convert';

import 'package:flagsmith/flagsmith.dart';
import 'package:tt_9/models/config.dart';


class ConfigService {
  static const _apikey = 'BfF4Ln5bNynpMVcSoLZ8B7';

  late final FlagsmithClient _flagsmithClient;

  late final Config _config;

  Future<ConfigService> init() async {
    _flagsmithClient = await FlagsmithClient.init(
      apiKey: _apikey,
      config: const FlagsmithConfig(
        caches: true,
      ),
    );
    await _flagsmithClient.getFeatureFlags(reload: true);

    final json = jsonDecode(
        await _flagsmithClient.getFeatureFlagValue(ConfigKey.config.name) ??
            '') as Map<String, dynamic>;
    _config = Config.fromJson(json);
    return this;
  }

  void closeClient() => _flagsmithClient.close();

  Config get config => _config;
}
