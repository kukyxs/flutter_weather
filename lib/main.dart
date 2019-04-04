import 'dart:io';

import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_weather/configs/application.dart';
import 'package:flutter_weather/routers/routers.dart';
import 'package:flutter_weather/utils/api.dart';
import 'package:flutter_weather/utils/db_utils.dart';
import 'package:flutter_weather/utils/http_utils.dart';
import 'package:flutter_weather/weather_app.dart';

void main() {
  // 注册 fluro router
  Router router = Router();
  Routers.configureRouters(router);
  Application.router = router;

  // 初始化 http
  Application.http = HttpUtils(baseUrl: WeatherApi.WEATHER_HOST);

  // 初始化 db
  Application.db = DatabaseUtils.instance;

  // 强制竖屏
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]).then((_) {
    runApp(WeatherApp());

    if (Platform.isAndroid) {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    }
  });
}
