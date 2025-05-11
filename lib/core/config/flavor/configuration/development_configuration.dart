import '../../env/env_keys.dart';
import '../../env/env.dart';
import '../configuration.dart';
import '../flavor.dart';

class DevelopmentConfiguration extends Configuration {
  /// Private internal constructor
  ///
  DevelopmentConfiguration._internal()
      : super(
          maxCacheAge: const Duration(minutes: 30),
          dioCacheForceRefreshKey: "dio_cache_force_refresh_key_dev",
          hiveBoxName: Env.instance.valueOf(EnvKeys.devStorageBoxName) ?? '',
          baseUrl: Env.instance.valueOf(EnvKeys.devBaseUrl) ?? '',
          privacyPolicyUrl:
              Env.instance.valueOf(EnvKeys.devPrivacyPolicyUrl) ?? '',
        );

  /// Singleton instance of this class
  ///
  static final DevelopmentConfiguration instance =
      DevelopmentConfiguration._internal();

  @override
  String get apiBaseUrl => apiBaseUrlV1;

  @override
  Flavor get flavor => Flavor.dev;
}
