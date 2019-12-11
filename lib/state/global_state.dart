import 'package:flutter/material.dart';

class _Singleton {
  final GlobalKey<ScaffoldState> subredditChoiceScaffoldKey =
      new GlobalKey<ScaffoldState>();
}

// the reason that this way is bad is probably because difficult to test
var globalState = _Singleton();
