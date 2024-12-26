import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/services/connectivity/connectivity_status_provider.dart';
import '../../provider/user_profile_state_provider.dart';
import '../../../../../utils/extension_functions.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timestamp) {
      _fetchUserProfile();
    });
  }

  /// Method to fetch user profile
  ///
  Future<void> _fetchUserProfile() async {
    if (mounted) {
      ref.read(userProfileStateProvider.notifier).fetchProfile();
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProfileState = ref.watch(userProfileStateProvider);
    final connected = ref.watch(connectivityStatusProvider);
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {},
        child: Center(
          child: Text(
            "${context.appLocalization.internet_connected}: ${connected ? '✅' : '⚠️'}",
          ),
        ),
      ),
    );
  }
}
