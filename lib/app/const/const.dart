import 'dart:io';

import 'package:flutter/material.dart';

var defaultPrimaryColor = Colors.purple;

class ServerConstant {
  static String serverURL = Platform.isAndroid
      ? 'https://prayashee.com/api'
      : 'https://prayashee.com/api';

  static String baseUrl = 'https://prayashee.com';
}
