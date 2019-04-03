import 'package:flutter/material.dart';
import 'package:flutter_weather/configs/application.dart';
import 'package:flutter_weather/configs/resource.dart';
import 'package:flutter_weather/routers/routers.dart';

class SplashPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(milliseconds: 2000))
        .then((_) => Application.router.navigateTo(context, Routers.generateWeatherRouterPath('')));

    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        color: Colors.white,
        child: Image.asset(Resource.pngSplash, width: 200.0, height: 200.0),
      ),
    );
  }
}
