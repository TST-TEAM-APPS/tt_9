import 'dart:convert';
import 'package:get_ip_address/get_ip_address.dart';

import 'package:http/http.dart';
import 'package:tt_9/models/network.dart';

class NetworkService {
  static const String _url = 'https://pro.ip-api.com/json/';
  late final Network _network;

  Future<void> init(String apiKey) async {
    try {
      final address = await IpAddress().getIpAddress();
      final response = await get(
        Uri.parse('$_url/$address?key=$apiKey'),
      );
      if (response.statusCode == 200) {
        final code =
            (jsonDecode(response.body) as Map<String, dynamic>)['countryCode'];
        _network = Network(code: code);
      } else {
        throw Exception('No connection');
      }
    } catch (e) {
      rethrow;
    }
  }

  Network get network => _network;
}
