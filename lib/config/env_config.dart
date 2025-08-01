class EnvConfig {
  static const String _devUrl = 'https://ggugitt-dev.web.app/';
  static const String _prodUrl = 'https://ggugitt.com/';

  static String get baseUrl {
    const env =
        String.fromEnvironment('ENVIRONMENT', defaultValue: 'development');

    switch (env) {
      case 'production':
        return _prodUrl;
      case 'staging':
        return _devUrl;
      case 'development':
      default:
        return _devUrl;
    }
  }

  static String get environment {
    return const String.fromEnvironment('ENVIRONMENT',
        defaultValue: 'development');
  }

  static bool get isProduction => environment == 'production';
  static bool get isStaging => environment == 'staging';
  static bool get isDevelopment => environment == 'development';
}
