import 'package:get_it/get_it.dart';
import 'package:busy_bookseller/services/config_service.dart';

mixin ConfigMixin {
  final _configService = GetIt.instance<ConfigService>();

  String get privacyLink => _configService.config.privacyLink;

  String get termsLink => _configService.config.termsLink;
}
