import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../enums/onboarding_item.dart';

final activeOnboardingItemProvider =
    StateNotifierProvider<ActiveOnboardingItemNotifier, OnboardingItem>(
  (ref) {
    return ActiveOnboardingItemNotifier(
      OnboardingItem.item1,
      ref,
    );
  },
);

/// ActiveOnboardingItemNotifier
///
class ActiveOnboardingItemNotifier extends StateNotifier<OnboardingItem> {
  ActiveOnboardingItemNotifier(
    super.state,
    this._ref,
  );

  /// Ref
  ///
  final StateNotifierProviderRef<ActiveOnboardingItemNotifier, OnboardingItem>
      _ref;

  /// Method to get the user profile
  ///
  void onActiveItemChanged(OnboardingItem item) {
    if (item != state) {
      state = item;
    }
  }
}
