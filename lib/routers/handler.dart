import 'package:fluro/fluro.dart';
import 'package:flutter_weather/bloc/bloc_provider.dart';
import 'package:flutter_weather/bloc/weather_bloc.dart';
import 'package:flutter_weather/pages/cities_page.dart';
import 'package:flutter_weather/pages/districts_page.dart';
import 'package:flutter_weather/pages/provinces_page.dart';
import 'package:flutter_weather/pages/splash_page.dart';
import 'package:flutter_weather/pages/settings_page.dart';
import 'package:flutter_weather/pages/weather_page.dart';
import 'package:flutter_weather/utils/fluro_convert_util.dart';
import 'package:flutter_weather/utils/logger.dart';

Handler notFoundHandler = Handler(handlerFunc: (_, params) {
  Logger('RouterHandler:').log('Not Found Router');
});

Handler rootHandler = Handler(handlerFunc: (_, params) => SplashPage());

Handler weatherHandler = Handler(handlerFunc: (_, params) {
  String cityId = params['city_id']?.first;
  return BlocProvider(child: WeatherPage(city: cityId), bloc: WeatherBloc());
});

Handler provincesHandler = Handler(handlerFunc: (_, params) => ProvinceListPage());

Handler citiesHandler = Handler(handlerFunc: (_, params) {
  String provinceId = params['province_id']?.first;
  String name = params['name']?.first;
  return CityListPage(provinceId: provinceId, name: FluroConvertUtils.fluroCnParamsDecode(name));
});

Handler districtsHandler = Handler(handlerFunc: (_, params) {
  String provinceId = params['province_id']?.first;
  String cityId = params['city_id']?.first;
  String name = params['name']?.first;
  return DistrictListPage(provinceId: provinceId, cityId: cityId, name: FluroConvertUtils.fluroCnParamsDecode(name));
});

Handler settingsHandler = Handler(handlerFunc: (_, params) => SettingsPage());
