import '../../env/env.dart';
import '../../env/env_keys.dart';
import '../configuration.dart';
import '../flavor.dart';

class ProductionConfiguration extends Configuration {
  /// Private internal constructor
  ///
  ProductionConfiguration._internal()
      : super(
          maxCacheAge: const Duration(days: 45),
          dioCacheForceRefreshKey: "naxa_app_dio_cache_force_refresh_key",
          hiveBoxName: Env.instance.valueOf(EnvKeys.productionStorageBoxName) ?? '',
          baseUrl: Env.instance.valueOf(EnvKeys.productionBaseUrl) ?? '',
          privacyPolicyUrl: Env.instance.valueOf(EnvKeys.productionPrivacyPolicyUrl) ?? '',
        );

  /// Singleton instance of this class
  ///
  static final ProductionConfiguration instance =
      ProductionConfiguration._internal();

  @override
  Flavor get flavor => Flavor.production;
}
