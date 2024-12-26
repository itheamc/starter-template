import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../database/tables/users/user_schema.dart';
import '../../../../../utils/extension_functions.dart';
import '../../../../../utils/logger.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        floatingActionButton: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FloatingActionButton.small(
              heroTag: "locationPicker",
              onPressed: () async {},
              child: const Icon(Icons.location_pin),
            ),
            FloatingActionButton.small(
              heroTag: "languageSettings",
              onPressed: () async {
                final schema = UserSchema(
                    firstName: "Amit",
                    lastName: "Chaudhary",
                    username: "itheamc",
                    email: "itheamc@gmail.com");

                Logger.logMessage(jsonEncode(schema.toJson()));

                // final builder = SqlQueryBuilder()
                //     .table("tbl_users")
                //     .columns([
                //       UsersTable.columnId,
                //       UsersTable.columnFirstName,
                //     ])
                //     .where("${UsersTable.columnFirstName} LIKE LOWER(?)",
                //         args: ["%s%"])
                //     .orderBy("id ASC")
                //     .offset(0)
                //     .limit(20);
                //
                // final users =
                //     await UsersTable.instance.rawQuery(builder: builder);
                //
                // Logger.logMessage(users.map((e) => e.toJson()));
                // context.pushNamed(AppRouter.languages.toPathName);
              },
              child: const Icon(Icons.translate),
            ),
          ],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${context.appLocalization.tab_home} - ${context.flavorConfiguration.flavor.name}',
                style: context.textTheme.titleLarge,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
