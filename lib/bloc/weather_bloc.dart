import 'package:flutter_weather/bloc/bloc_provider.dart';
import 'package:flutter_weather/configs/application.dart';
import 'package:flutter_weather/model/weather_model.dart';
import 'package:flutter_weather/utils/api.dart';
import 'package:flutter_weather/utils/logger.dart';
import 'package:rxdart/rxdart.dart';

class WeatherBloc extends BaseBloc {
  final _logger = Logger('WeatherBloc');

  WeatherModel _weather; // 天气情况

  String _background = WeatherApi.DEFAULT_BACKGROUND; // 背景

  WeatherModel get weather => _weather;

  String get background => _background;

  BehaviorSubject<WeatherModel> _weatherController = BehaviorSubject();

  BehaviorSubject<String> _backgroundController = BehaviorSubject();

  Observable<WeatherModel> get weatherStream => Observable(_weatherController.stream);

  Observable<String> get backgroundStream => Observable(_backgroundController.stream);

  updateWeather(WeatherModel weather) {
    _weather = weather;
    _weatherController.add(_weather);
  }

  updateBackground(String background) {
    _background = background;
    _backgroundController.add(_background);
  }

  Future<WeatherModel> requestWeather(String id) async {
    var resp = await Application.http
        .getRequest(WeatherApi.WEATHER_STATUS, params: {'cityid': id, 'key': WeatherApi.WEATHER_KEY}, callback: (msg) => _logger.log(msg, 'weather'));
    return WeatherModel.fromMap(resp.data);
  }

  Future<String> requestBackground() async {
    var resp = await Application.http.getRequest(WeatherApi.WEATHER_BACKGROUND, callback: (msg) => _logger.log(msg, 'background'));
    return resp == null || resp.data == null ? WeatherApi.DEFAULT_BACKGROUND : resp.data;
  }

  @override
  void dispose() {
    _weatherController?.close();
    _backgroundController?.close();
  }
}
