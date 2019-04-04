import 'package:flutter/material.dart';
import 'package:flutter_weather/bloc/bloc_provider.dart';
import 'package:rxdart/rxdart.dart';

class SettingBloc extends BaseBloc {
  /// 所有主题色列表
  static const themeColors = [Colors.blue, Colors.red, Colors.green, Colors.deepOrange, Colors.pink, Colors.purple];

  Color _color = themeColors[0];

  bool _sliverHeader = false;

  Color get color => _color;

  bool get sliverHeader => _sliverHeader;

  BehaviorSubject<Color> _colorController = BehaviorSubject();

  BehaviorSubject<bool> _headerController = BehaviorSubject();

  Observable<Color> get colorStream => Observable(_colorController.stream);

  Observable<bool> get headerStream => Observable(_headerController.stream);

  /// 切换主题通知刷新
  switchTheme(int themeIndex) {
    _color = themeColors[themeIndex];
    _colorController.add(_color);
  }

  /// 头部是否跟随
  changeSliverState(bool enabled) {
    _sliverHeader = enabled;
    _headerController.add(_sliverHeader);
  }

  @override
  void dispose() {
    _colorController?.close();
    _headerController?.close();
  }
}
