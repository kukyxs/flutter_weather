import 'package:flutter/material.dart';
import 'package:flutter_weather/bloc/bloc_provider.dart';
import 'package:flutter_weather/bloc/provinces_bloc.dart';
import 'package:flutter_weather/bloc/weather_bloc.dart';
import 'package:flutter_weather/configs/application.dart';

class WeatherApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      bloc: ProvincesBloc(),
      child: BlocProvider(
        bloc: WeatherBloc(),
        child: MaterialApp(
          title: 'Weather App',
          onGenerateRoute: Application.router.generator,
          debugShowCheckedModeBanner: false,
        ),
      ),
    );
  }
}
