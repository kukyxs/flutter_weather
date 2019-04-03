import 'package:flutter/material.dart';
import 'package:flutter_weather/configs/application.dart';

class WeatherApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      onGenerateRoute: Application.router.generator,
      debugShowCheckedModeBanner: false,
      supportedLocales: const [const Locale('zh')],
    );
  }
}
