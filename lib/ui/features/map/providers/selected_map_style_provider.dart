import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../enums/map_styles.dart';

final selectedMapStyleProvider =
    StateNotifierProvider<SelectedMapStyleStateNotifier, MapStyles>((ref) {
  return SelectedMapStyleStateNotifier(
    MapStyles.light,
  );
});

class SelectedMapStyleStateNotifier extends StateNotifier<MapStyles> {
  SelectedMapStyleStateNotifier(
    super.state,
  );

  /// Method to update the map Style
  ///
  void updateStyle(MapStyles style) {
    // If already selected, just return from here
    if (state == style) return;

    // Update the state with new style
    state = style;
  }
}
