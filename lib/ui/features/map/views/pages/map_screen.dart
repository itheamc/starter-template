import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naxa_maplibre_gl/naxa_maplibre_gl.dart';

import '../../../../../core/styles/app_colors.dart';
import '../../../../common/shimmer.dart';
import '../../../../../ui/features/map/providers/map_state_provider.dart';
import '../../../../../ui/features/map/models/queried_feature.dart';
import '../../../../../utils/logger.dart';

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        body: Stack(
          children: [
            NaxaMap(
              initialCameraPosition: const CameraPosition(
                target: LatLng(24.76, 28.9),
              ),
              onMapCreated: (controller) =>
                  ref.read(mapStateProvider.notifier).onMapCreated(
                        controller,
                        onFeatureClick: _handleOnFeatureClicked,
                      ),
              onStyleLoadedCallback:
                  ref.read(mapStateProvider.notifier).onStyleLoaded,
            ),
            // Shimmer Animation
            Consumer(
              builder: (context, ref1, child) {
                final state = ref1.watch(mapStateProvider);
                return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 275),
                  child: state.fullyLoaded
                      ? const SizedBox()
                      : Shimmer(
                          opacity: 0.25,
                          child: Shimmer.loadingContainer(
                            context,
                            color: AppColors.white,
                            radius: 0,
                          ),
                        ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  /// Method to handle on Feature Click
  ///
  Future<void> _handleOnFeatureClicked(
    LatLng? latLng,
    QueriedFeature? feature,
  ) async {
    // Handle on feature click here
    Logger.logMessage(feature?.properties?.toString() ?? "null");
  }
}
