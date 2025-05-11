import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:naxa_maplibre_gl/naxa_maplibre_gl.dart';

import '../../../../../core/styles/app_colors.dart';
import '../../../../common/app_button.dart';
import '../../../map/enums/map_styles.dart';
import '../../../../common/shimmer.dart';
import '../../providers/location_picker_state_provider.dart';
import '../../../../../../utils/extension_functions.dart';

class LocationPicker extends ConsumerStatefulWidget {
  final LatLng? latLng;

  const LocationPicker({super.key, this.latLng});

  @override
  ConsumerState<LocationPicker> createState() => _LocationPickerState();
}

class _LocationPickerState extends ConsumerState<LocationPicker> {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        extendBodyBehindAppBar: true,
        body: Stack(
          children: [
            NaxaMap(
              initialCameraPosition: CameraPosition(
                target: widget.latLng ??
                    const LatLng(
                      23.78,
                      85.78,
                    ),
              ),
              styleString: MapStyles.light.styleString,
              compassEnabled: false,
              onMapCreated: (controller) => ref
                  .read(locationPickerStateProvider.notifier)
                  .onMapCreated(controller, latLng: widget.latLng),
              onStyleLoadedCallback: ref
                  .read(locationPickerStateProvider.notifier)
                  .onStyleLoadedCallback,
              trackCameraPosition: true,
            ),
            Consumer(
              builder: (_, ref1, child) {
                final locationPickerState =
                    ref1.watch(locationPickerStateProvider);

                return Stack(
                  children: [
                    Center(
                      child: Container(
                        width: 1.0,
                        height: 1.0,
                        decoration: BoxDecoration(
                          color: context.theme.primaryColor.withValues(alpha: 0.30),
                          borderRadius: BorderRadius.circular(10.0),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 3.0,
                              spreadRadius: locationPickerState.isCameraMoving
                                  ? 4.0
                                  : 0.0,
                              offset: Offset.zero,
                              color:
                                  context.theme.primaryColor.withValues(alpha: 0.30),
                            )
                          ],
                        ),
                      ),
                    ),
                    Center(
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 175),
                        curve: Curves.bounceInOut,
                        transform: Matrix4.translationValues(
                            0,
                            locationPickerState.isCameraMoving ? -42.0 : -16.0,
                            0),
                        child: Icon(
                          Icons.location_on_rounded,
                          color: context.theme.primaryColor,
                          size: locationPickerState.isCameraMoving ? 50 : 40.0,
                        ),
                      ),
                    ),
                    AnimatedPositioned(
                      duration: const Duration(milliseconds: 175),
                      curve: Curves.linear,
                      bottom: locationPickerState.position == null ||
                              locationPickerState.isCameraMoving
                          ? -100.0
                          : 0,
                      left: 0,
                      right: 0,
                      child: Material(
                        color: AppColors.white,
                        shadowColor: context.theme.dividerColor,
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(20.0)),
                        elevation: 16.0,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 16.0),
                          child: AppButton(
                            text: 'Confirm',
                            width: double.maxFinite,
                            onPressed: () {
                              context.pop(ref
                                  .read(locationPickerStateProvider)
                                  .position);
                            },
                          ),
                        ),
                      ),
                    ),
                    if (!locationPickerState.isMapReady)
                      Shimmer(
                        loading: true,
                        opacity: 0.25,
                        child: Shimmer.loadingContainer(
                          context,
                          color: AppColors.white,
                          opacity: 0.5,
                          radius: 0.0,
                        ),
                      ),
                    Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: EdgeInsets.only(
                          top: context.mediaQuery.padding.top,
                          right: 20.0,
                        ),
                        child: SizedBox(
                          height: 40.0,
                          width: 40.0,
                          child: IconButton(
                            onPressed: () {
                              if (context.canPop()) context.pop();
                            },
                            splashRadius: 28.0,
                            icon: const Icon(
                              Icons.close_outlined,
                              color: AppColors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
