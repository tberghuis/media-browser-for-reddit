import 'package:flutter/material.dart';
import 'screens/subreddit_browser.dart';
import 'screens/subreddit_choice.dart';
import 'widgets/hide_ui_overlays.dart';

void main() {
  runApp(
    MaterialApp(
      title: 'Media Browser for Reddit',
      initialRoute: '/',
      routes: {
        '/': (context) => SubredditChoice(),
        '/pageviewdemo': (context) => HideUiOverlays(
              child: SubredditBrowser(),
            ),
      },
    ),
  );
}
