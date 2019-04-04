import 'package:fluro/fluro.dart';
import 'package:flutter_weather/routers/handler.dart';

/// fluro 路由管理类
class Routers {
  static const root = '/';
  static const weather = '/weather';
  static const provinces = '/provinces';
  static const cities = '/cities';
  static const districts = '/districts';
  static const settings = '/settings';

  static configureRouters(Router router) {
    router.notFoundHandler = notFoundHandler;

    router.define(root, handler: rootHandler);

    router.define(weather, handler: weatherHandler);

    router.define(provinces, handler: provincesHandler);

    router.define(cities, handler: citiesHandler);

    router.define(districts, handler: districtsHandler);

    router.define(settings, handler: settingsHandler);
  }

  static generateWeatherRouterPath(String cityId) => '$weather?city_id=$cityId';

  static generateProvinceRouterPath(int provinceId, String name) => '$cities?province_id=$provinceId&name=$name';

  static generateCityRouterPath(int provinceId, int cityId, String name) => '$districts?province_id=$provinceId&city_id=$cityId&name=$name';
}
