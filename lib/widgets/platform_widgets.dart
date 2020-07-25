import 'dart:io';
import 'package:flutter/material.dart';

abstract class PlatformWidget extends StatelessWidget {
  Widget buildCupertinoWidgets(BuildContext context);
  Widget buildMaterialWidgets(BuildContext context);
  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return buildCupertinoWidgets(context);
    }
    return buildMaterialWidgets(context);
  }
}
