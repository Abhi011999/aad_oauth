import 'package:example_new/main.dart';
import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';

final router = GoRouter(
  initialLocation: '/',
  urlPathStrategy: UrlPathStrategy.path,
  routes: [
    GoRoute(
      path: '/',
      pageBuilder: (context, state) => MaterialPage(
        key: state.pageKey,
        fullscreenDialog: true,
        child: const MyHomePage(title: "AAD OAuth Home"),
      )
    ),
  ],
);
