import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_weather/bloc/bloc_provider.dart';
import 'package:flutter_weather/bloc/weather_bloc.dart';
import 'package:flutter_weather/configs/application.dart';
import 'package:flutter_weather/model/weather_model.dart';
import 'package:flutter_weather/routers/routers.dart';
import 'package:flutter/cupertino.dart';

class WeatherPage extends StatelessWidget {
  final String city;

  WeatherPage({Key key, this.city}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _bloc = BlocProvider.of<WeatherBloc>(context);
    _bloc.requestBackground().then((b) => _bloc.updateBackground(b));
    _bloc.requestWeather(city).then((w) => _bloc.updateWeather(w));

    return Scaffold(
      body: StreamBuilder(
          stream: _bloc.backgroundStream,
          initialData: _bloc.background,
          builder: (_, AsyncSnapshot<String> snapshot) => Container(
                padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 20.0),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  image: DecorationImage(image: NetworkImage(_bloc.background), fit: BoxFit.cover),
                ),
                child: StreamBuilder(
                    initialData: _bloc.weather,
                    stream: _bloc.weatherStream,
                    builder: (_, AsyncSnapshot<WeatherModel> snapshot) => !snapshot.hasData
                        ? CupertinoActivityIndicator(radius: 12.0)
                        : SafeArea(
                            child: RefreshIndicator(
                                child: CustomScrollView(
                                  slivers: <Widget>[
                                    SliverToBoxAdapter(
                                      // 头部切换地点等
                                      child: HeaderActions(snapshot: snapshot),
                                    ),
                                    // 实时天气
                                    SliverPadding(
                                      padding: const EdgeInsets.symmetric(vertical: 30.0),
                                      sliver: SliverToBoxAdapter(
                                        child: CurrentWeatherState(snapshot: snapshot),
                                      ),
                                    ),
                                    // 天气预报
                                    WeatherForecast(snapshot: snapshot),
                                    // 空气质量
                                    SliverPadding(
                                      padding: const EdgeInsets.symmetric(vertical: 30.0),
                                      sliver: SliverToBoxAdapter(child: AirQuality(snapshot: snapshot)),
                                    ),
                                    // 生活建议
                                    SliverToBoxAdapter(child: LifeSuggestions(snapshot: snapshot))
                                  ],
                                ),
                                onRefresh: () async {
                                  _bloc.requestWeather(city).then((w) => _bloc.updateWeather(w));
                                  return null;
                                }),
                          )),
              )),
    );
  }
}

class HeaderActions extends StatelessWidget {
  final AsyncSnapshot<WeatherModel> snapshot;

  HeaderActions({Key key, this.snapshot}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        IconButton(
            icon: Icon(Icons.home, color: Colors.white, size: 32.0),
            onPressed: () => Application.router.navigateTo(context, Routers.provinces, transition: TransitionType.inFromLeft)),
        Text('${snapshot.data.HeWeather[0].basic.location}', style: TextStyle(fontSize: 28.0, color: Colors.white)),
        IconButton(icon: Icon(Icons.color_lens, color: Colors.white, size: 32.0), onPressed: () {})
      ],
    );
  }
}

class CurrentWeatherState extends StatelessWidget {
  final AsyncSnapshot<WeatherModel> snapshot;

  CurrentWeatherState({Key key, this.snapshot}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _now = snapshot.data.HeWeather[0].now;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Text('${_now.tmp}℃', style: TextStyle(fontSize: 50.0, color: Colors.white)),
        Text('${_now.cond_txt}', style: TextStyle(fontSize: 24.0, color: Colors.white))
      ],
    );
  }
}

class WeatherForecast extends StatelessWidget {
  final AsyncSnapshot<WeatherModel> snapshot;

  WeatherForecast({Key key, this.snapshot}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _forecastList = snapshot.data.HeWeather[0].daily_forecast;

    return SliverFixedExtentList(
        delegate: SliverChildBuilderDelegate(
          (_, index) => Container(
              color: Colors.black54,
              padding: const EdgeInsets.all(12.0),
              alignment: Alignment.centerLeft,
              child: index == 0
                  ? Text('预报', style: TextStyle(fontSize: 24.0, color: Colors.white))
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(_forecastList[index - 1].date, style: TextStyle(fontSize: 16.0, color: Colors.white)),
                        Expanded(
                            child: Center(child: Text(_forecastList[index - 1].cond.txt_d, style: TextStyle(fontSize: 16.0, color: Colors.white))),
                            flex: 2),
                        Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(_forecastList[index - 1].tmp.max, style: TextStyle(fontSize: 16.0, color: Colors.white)),
                                Text(_forecastList[index - 1].tmp.min, style: TextStyle(fontSize: 16.0, color: Colors.white)),
                              ],
                            ),
                            flex: 1)
                      ],
                    )),
          childCount: _forecastList.length + 1,
        ),
        itemExtent: 50.0);
  }
}

class AirQuality extends StatelessWidget {
  final AsyncSnapshot<WeatherModel> snapshot;

  AirQuality({Key key, this.snapshot}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var quality = snapshot.data.HeWeather[0].aqi.city;
    return Container(
        padding: const EdgeInsets.all(12.0),
        color: Colors.black54,
        alignment: Alignment.centerLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(padding: const EdgeInsets.only(bottom: 20.0), child: Text('空气质量', style: TextStyle(fontSize: 24.0, color: Colors.white))),
            Row(
              children: <Widget>[
                Expanded(
                    child: Center(
                  child: Column(
                    children: <Widget>[
                      Text('${quality.aqi}', style: TextStyle(fontSize: 40.0, color: Colors.white)),
                      Text('AQI 指数', style: TextStyle(fontSize: 20.0, color: Colors.white)),
                    ],
                  ),
                )),
                Expanded(
                    child: Center(
                  child: Column(
                    children: <Widget>[
                      Text('${quality.pm25}', style: TextStyle(fontSize: 40.0, color: Colors.white)),
                      Text('PM2.5 指数', style: TextStyle(fontSize: 20.0, color: Colors.white)),
                    ],
                  ),
                )),
              ],
            )
          ],
        ));
  }
}

class LifeSuggestions extends StatelessWidget {
  final AsyncSnapshot<WeatherModel> snapshot;

  LifeSuggestions({Key key, this.snapshot}) : super(key: key);

  Widget _suggestionWidget(String content) =>
      Padding(padding: const EdgeInsets.only(top: 20.0), child: Text(content, style: TextStyle(color: Colors.white, fontSize: 16.0)));

  @override
  Widget build(BuildContext context) {
    var _suggestion = snapshot.data.HeWeather[0].suggestion;

    return Container(
      padding: const EdgeInsets.all(12.0),
      color: Colors.black54,
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('生活建议', style: TextStyle(fontSize: 24.0, color: Colors.white)),
          _suggestionWidget('舒适度：${_suggestion.comf.brf}\n${_suggestion.comf.txt}'),
          _suggestionWidget('洗车指数：${_suggestion.cw.brf}\n${_suggestion.cw.txt}'),
          _suggestionWidget('运动指数：${_suggestion.sport.brf}\n${_suggestion.sport.txt}'),
        ],
      ),
    );
  }
}
