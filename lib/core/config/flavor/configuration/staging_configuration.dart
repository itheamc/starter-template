import '../../env/env.dart';
import '../../env/env_keys.dart';
import '../configuration.dart';
import '../flavor.dart';

class StagingConfiguration extends Configuration {
  /// Private internal constructor
  ///
  StagingConfiguration._internal()
      : super(
          maxCacheAge: const Duration(minutes: 30),
          dioCacheForceRefreshKey: "dio_cache_force_refresh_key_staging",
          hiveBoxName:
              Env.instance.valueOf(EnvKeys.stagingStorageBoxName) ?? '',
          baseUrl: Env.instance.valueOf(EnvKeys.stagingBaseUrl) ?? '',
          privacyPolicyUrl:
              Env.instance.valueOf(EnvKeys.stagingPrivacyPolicyUrl) ?? '',
        );

  /// Singleton instance of this class
  ///
  static final StagingConfiguration instance = StagingConfiguration._internal();

  @override
  String get apiBaseUrl => apiBaseUrlV1;

  @override
  Flavor get flavor => Flavor.staging;
}
