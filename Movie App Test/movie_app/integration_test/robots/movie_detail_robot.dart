import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class MovieDetailRobot {
  final WidgetTester tester;
  MovieDetailRobot(this.tester);

  Future<void> goBack() async {
    final backButton = find.byKey(const Key('backButton'));

    await tester.tap(backButton);

    //await tester.pageBack();
    await tester.pumpAndSettle();
    sleep(const Duration(seconds: 2));
  }

  Future<void> scrollPage({bool scrollUp = false}) async {
    final scrollViewFinder = find.byKey(const Key('movieDetailScrollView'));

    if (scrollUp) {
      await tester.fling(scrollViewFinder, const Offset(0, 500), 10000);
      await tester.pumpAndSettle();
    } else {
      await tester.fling(scrollViewFinder, const Offset(0, -500), 10000);
      await tester.pumpAndSettle();
    }
  }
}
