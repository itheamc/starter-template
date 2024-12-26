import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/services/storage/storage_keys.dart';
import '../core/services/storage/storage_service_provider.dart';

class L10n {
  static const Locale en = Locale('en', 'US'); // American English
  static const Locale ne = Locale('ne', 'NP'); // Nepali
  static const Locale bn = Locale('bn', 'BD'); // Bengali

  static final all = [
    en,
    ne,
    bn,
  ];

  static Locale fromLanguageCode(String code) {
    if (code == ne.languageCode) return ne;
    if (code == bn.languageCode) return bn;
    return en;
  }
}

/// Locale Provider
///
final localeStateProvider =
    StateNotifierProvider<LocaleStateNotifier, Locale>((ref) {
  final lCode = ref.read(storageServiceProvider).get(
        StorageKeys.locale,
        defaultValue: L10n.en.languageCode,
      );
  return LocaleStateNotifier(
    L10n.fromLanguageCode(lCode ?? L10n.en.languageCode),
    ref,
  );
});

/// Locale State Notifier Class
///
class LocaleStateNotifier extends StateNotifier<Locale> {
  LocaleStateNotifier(super.state, this._ref);

  /// Ref
  ///
  final Ref<Locale> _ref;

  /// Change/Update locale
  ///
  Future<void> changeLocale(Locale? locale) async {
    final storageService = _ref.read(storageServiceProvider);

    final newLocale = L10n.fromLanguageCode((locale ?? L10n.en).languageCode);

    if (state.languageCode != newLocale.languageCode) {
      storageService
          .set(StorageKeys.locale, newLocale.languageCode)
          .then((value) => state = newLocale);
    }
  }
}
