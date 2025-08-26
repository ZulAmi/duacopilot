import 'package:duacopilot/core/routing/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('GoRouter Integration Tests', () {
    testWidgets('Router provider should create GoRouter instance', (
      tester,
    ) async {
      final container = ProviderContainer();

      final router = container.read(goRouterProvider);

      expect(router, isNotNull);
      expect(router.configuration.routes, isNotEmpty);

      container.dispose();
    });

    testWidgets('Router should have correct initial location', (tester) async {
      final container = ProviderContainer();

      final router = container.read(goRouterProvider);

      expect(router.routerDelegate.currentConfiguration.uri.path, equals('/'));

      container.dispose();
    });

    testWidgets('Router should have premium routes configured', (tester) async {
      final container = ProviderContainer();

      final router = container.read(goRouterProvider);

      // Check if premium routes exist by trying to navigate
      final routeInformation = RouteInformation(uri: Uri.parse('/premium'));
      final routeConfig = await router.routeInformationParser
          .parseRouteInformation(routeInformation);

      expect(routeConfig, isNotNull);

      container.dispose();
    });

    testWidgets('Router should handle subscription route', (tester) async {
      final container = ProviderContainer();

      final router = container.read(goRouterProvider);

      // Check subscription route
      final routeInformation = RouteInformation(
        uri: Uri.parse('/subscription'),
      );
      final routeConfig = await router.routeInformationParser
          .parseRouteInformation(routeInformation);

      expect(routeConfig, isNotNull);

      container.dispose();
    });
  });
}
