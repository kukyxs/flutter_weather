import 'package:flutter/material.dart';
import 'package:flutter_weather/bloc/bloc_provider.dart';
import 'package:rxdart/rxdart.dart';

class ThemeBloc extends BaseBloc {
  /// 所有主题色列表
  static const themeColors = [Colors.blue, Colors.red, Colors.green, Colors.yellow, Colors.pink, Colors.purple];

  Color _color = themeColors[0];

  Color get color => _color;

  BehaviorSubject<Color> _colorController = BehaviorSubject();

  Observable<Color> get colorStream => Observable(_colorController.stream);

  /// 切换主题通知刷新
  switchTheme(int themeIndex) {
    _color = themeColors[themeIndex];
    _colorController.add(_color);
  }

  @override
  void dispose() {
    _colorController?.close();
  }
}
