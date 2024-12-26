import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../common/app_button.dart';
import '../../enums/onboarding_item.dart';
import '../../providers/active_onboarding_item_provider.dart';
import '../../../../../utils/extension_functions.dart';

class CarousalControlButton extends ConsumerWidget {
  final void Function(OnboardingItem item)? onClick;

  const CarousalControlButton({
    super.key,
    this.onClick,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final active = ref.watch(activeOnboardingItemProvider);
    return AppButton(
      text: active.isEnd
          ? context.appLocalization.get_started
          : context.appLocalization.next,
      trailing: !active.isEnd ? Icons.arrow_right_alt : null,
      margin: const EdgeInsets.symmetric(
        horizontal: 16.0,
      ),
      onPressed: () {
        onClick?.call(active);
      },
    );
  }
}
