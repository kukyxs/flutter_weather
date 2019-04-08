import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_weather/bloc/bloc_provider.dart';
import 'package:flutter_weather/bloc/settings_bloc.dart';
import 'package:flutter_weather/configs/application.dart';
import 'package:flutter_weather/configs/preferences_key.dart';
import 'package:flutter_weather/configs/resource.dart';
import 'package:flutter_weather/routers/routers.dart';
import 'package:flutter_weather/utils/api.dart';
import 'package:flutter_weather/utils/preference_utils.dart';
import 'package:rxdart/rxdart.dart';

/// 首页信息展示
class SplashPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (WeatherApi.WEATHER_KEY != null && WeatherApi.WEATHER_KEY.isNotEmpty) {
      // 判断是否选择了新的主题，默认 0，如果选择了则更新
      PreferenceUtils.instance.getInteger(PreferencesKey.THEME_COLOR_INDEX, 0).then((index) {
        BlocProvider.of<SettingBloc>(context).switchTheme(index);
      });

      // 刷新头部跟随
      PreferenceUtils.instance.getBool(PreferencesKey.SLIVER_HEADER, false).then((bool) {
        BlocProvider.of<SettingBloc>(context).changeSliverState(bool);
      });

      // 5s 计时，如果已经选择城市，跳转天气界面，否则进入城市选择
      Observable.timer(0, Duration(milliseconds: 5000)).listen((_) {
        PreferenceUtils.instance.getString(PreferencesKey.WEATHER_CITY_ID).then((city) {
          Application.router.navigateTo(context, city.isEmpty ? Routers.provinces : Routers.generateWeatherRouterPath(city), replace: true);
        });
      });
    } else {
      Observable.timer(0, Duration(milliseconds: 500)).listen((_) {
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('未设置 Key'),
                content: Text('未设置 Key，请到 "utils/api#WEATHER_KEY" 进行配置'),
                actions: <Widget>[
                  FlatButton(
                      onPressed: () {
                        SystemNavigator.pop();
                        exit(0);
                      },
                      child: Text('确定'))
                ],
              );
            });
      });
    }

    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(Resource.pngSplash, width: 200.0, height: 200.0),
            SizedBox(
                width: MediaQuery.of(context).size.width * 0.7,
                child: Text(
                  '所有天气数据均为模拟数据，仅用作学习目的使用，请勿当作真实的天气预报软件来使用',
                  textAlign: TextAlign.center,
                  softWrap: true,
                  style: TextStyle(color: Colors.red[700], fontSize: 16.0),
                ))
          ],
        ),
      ),
    );
  }
}
