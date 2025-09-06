import 'package:openapi/openapi.dart';

class ApiClientProvider {
  static Openapi? _client;

  static Openapi getClient() {
    _client ??= Openapi(basePathOverride: 'http://127.0.0.1:8000');
    return _client!;
  }
}
