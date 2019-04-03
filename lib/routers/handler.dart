import 'package:fluro/fluro.dart';
import 'package:flutter_weather/pages/splash_page.dart';

Handler notFoundHandler = Handler(handlerFunc: (_, params) {
  print('not found page');
});

Handler rootHandler = Handler(handlerFunc: (_, params) => SplashPage());

Handler weatherHandler = Handler(handlerFunc: (_, params) {
  String cityId = params['city_id']?.first;
});

Handler chinaHandler = Handler(handlerFunc: (_, params) {});

Handler provinceHandler = Handler(handlerFunc: (_, params) {
  String provinceId = params['province_id']?.first;
});

Handler cityHandler = Handler(handlerFunc: (_, params) {
  String provinceId = params['province_id']?.first;
  String cityId = params['city_id']?.first;
});
