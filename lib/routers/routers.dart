import 'package:fluro/fluro.dart';
import 'package:flutter_weather/routers/handler.dart';

class Routers {
  static const root = '/';
  static const weather = '/weather';
  static const china = '/china';
  static const provinces = '/provinces';
  static const cities = '/cities';

  static configureRouters(Router router) {
    router.notFoundHandler = notFoundHandler;

    router.define(root, handler: rootHandler);

    router.define(china, handler: chinaHandler);

    router.define(provinces, handler: provinceHandler);

    router.define(cities, handler: cityHandler);
  }

  static generateWeatherRouterPath(String cityId) => '$weather?city_id=$cityId';

  static generateProvinceRouterPath(String provinceId) => '$provinces?province_id=$provinceId';

  static generateCityRouterPath(String provinceId, String cityId) => '$cities?province_id=$provinceId&city_id=$cityId';
}
