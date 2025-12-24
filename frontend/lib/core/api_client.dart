import 'package:openapi/openapi.dart';
import 'package:dio/dio.dart';

class ApiClientProvider {
  static Openapi? _client;

  static String get defaultBackendUrl {
    return 'https://calc.elteammate.space/api';
  }

  static Openapi getClient() {
    final String backendUrl = const String.fromEnvironment(
      'BACKEND_URL',
      defaultValue: '',
    ).isNotEmpty
        ? const String.fromEnvironment('BACKEND_URL')
        : defaultBackendUrl;

    print('URL: $backendUrl');

    _client ??= Openapi(
      basePathOverride: backendUrl,
      dio: createDio(backendUrl),
    );
    return _client!;
  }

  static createDio(String baseUrl) {
    final dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 50),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
    ));

    dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
      logPrint: (object) {
        print('🌐 HTTP: $object');
      },
    ));

    return dio;
  }
}
