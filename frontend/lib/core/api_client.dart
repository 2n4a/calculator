import 'package:openapi/openapi.dart';

class ApiClientProvider {
  static Openapi? _client;

  static Openapi getClient() {
    const String backendUrl = String.fromEnvironment(
      'BACKEND_URL',
      defaultValue: 'http://127.0.0.1:8000',
    );

    _client ??= Openapi(basePathOverride: backendUrl);
    return _client!;
  }
}
