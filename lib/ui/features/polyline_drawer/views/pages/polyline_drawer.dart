import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naxa_maplibre_gl/naxa_maplibre_gl.dart';

import '../../../map/enums/map_styles.dart';
import '../../../../common/shimmer.dart';
import '../../../../../../utils/extension_functions.dart';
import '../../../map/views/widgets/map_control_rounded_icon_button.dart';
import '../../providers/polyline_drawer_state_provider.dart';

class PolylineDrawer extends ConsumerStatefulWidget {
  const PolylineDrawer({super.key});

  @override
  ConsumerState<PolylineDrawer> createState() => _PolylineDrawerState();
}

class _PolylineDrawerState extends ConsumerState<PolylineDrawer> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        NaxaMap(
          initialCameraPosition: CameraPosition(
            target: const LatLng(
              23.78,
              85.78,
            ),
          ),
          styleString: context.isDarkTheme
              ? MapStyles.dark.styleString
              : MapStyles.light.styleString,
          compassEnabled: false,
          onMapCreated: (controller) => ref
              .read(polylineDrawerStateProvider.notifier)
              .onMapCreated(controller),
          onStyleLoadedCallback: ref
              .read(polylineDrawerStateProvider.notifier)
              .onStyleLoadedCallback,
          onMapClick: ref.read(polylineDrawerStateProvider.notifier).onMapClick,
          onMapLongClick:
              ref.read(polylineDrawerStateProvider.notifier).onMapLongClick,
          trackCameraPosition: true,
        ),
        Consumer(
          builder: (_, ref1, child) {
            final polygonDrawerState = ref1.watch(polylineDrawerStateProvider);

            return Stack(
              children: [
                if (!polygonDrawerState.isMapReady)
                  Shimmer(
                    loading: true,
                    opacity: 0.25,
                    child: Shimmer.loadingContainer(
                      context,
                      color: context.theme.colorScheme.surface,
                      opacity: 0.5,
                      radius: 0.0,
                    ),
                  ),
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: context.mediaQuery.padding.top + 8.0,
                      right: 16.0,
                    ),
                    child: Consumer(
                      builder: (_, ref, child) {
                        final state = ref.watch(polylineDrawerStateProvider);
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          spacing: 8.0,
                          children: [
                            MapControlRoundedIconButton(
                              icon: state.drawable
                                  ? Icons.close
                                  : Icons.draw_outlined,
                              onClick: ref
                                  .read(polylineDrawerStateProvider.notifier)
                                  .toggleDrawable,
                            ),
                            if (state.drawable) ...[
                              MapControlRoundedIconButton(
                                icon: Icons.undo,
                                onClick: state.histories.isNotEmpty
                                    ? ref
                                        .read(polylineDrawerStateProvider
                                            .notifier)
                                        .handleUndo
                                    : null,
                              ),
                              MapControlRoundedIconButton(
                                icon: Icons.redo,
                                onClick: state.historiesOfUndo.isNotEmpty
                                    ? ref
                                        .read(polylineDrawerStateProvider
                                            .notifier)
                                        .handleRedo
                                    : null,
                              ),
                            ],
                          ],
                        );
                      },
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: EdgeInsets.only(
                      bottom: 24.0,
                      right: 16.0,
                    ),
                    child: Consumer(
                      builder: (_, ref, child) {
                        final state = ref.watch(polylineDrawerStateProvider);
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          spacing: 8.0,
                          children: [
                            if (state.drawable && state.points.length > 1)
                              MapControlRoundedIconButton(
                                icon: Icons.save,
                                onClick: () {
                                  ref
                                      .read(
                                          polylineDrawerStateProvider.notifier)
                                      .toggleDrawable(false);
                                },
                              ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
