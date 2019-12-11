import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// rewrite as a service created by Provider

class HideUiOverlays extends StatelessWidget {

  final Widget child;
  HideUiOverlays({this.child}){
    SystemChrome.setEnabledSystemUIOverlays([]);
  }

  @override
  Widget build(BuildContext context) {
    return child;
  }
}