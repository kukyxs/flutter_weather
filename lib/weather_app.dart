import 'package:flutter/material.dart';
import 'package:flutter_weather/bloc/bloc_provider.dart';
import 'package:flutter_weather/bloc/provinces_bloc.dart';
import 'package:flutter_weather/bloc/settings_bloc.dart';
import 'package:flutter_weather/configs/application.dart';

class WeatherApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        bloc: SettingBloc(), // 主题色切换 BLoC
        child: BlocProvider(
          bloc: ProvincesBloc(), // 城市切换 BLoC
          child: MaterialApp(
            title: 'Weather App',
            onGenerateRoute: Application.router.generator,
            debugShowCheckedModeBanner: false,
          ),
        ));
  }
}
