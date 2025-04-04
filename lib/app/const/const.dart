import 'dart:io';

import 'package:flutter/material.dart';

var defaultPrimaryColor = Colors.purple;

class ServerConstant {
  static String serverURL = Platform.isAndroid
      ? 'http://192.168.31.72:8000/api'
      : 'http://192.168.31.72:8000/api';
}
