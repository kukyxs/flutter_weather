import 'package:flutter/material.dart';
import 'package:flutter_weather/bloc/bloc_provider.dart';
import 'package:flutter_weather/bloc/theme_bloc.dart';
import 'package:flutter_weather/configs/preferences_key.dart';
import 'package:flutter_weather/utils/preference_utils.dart';

class ThemePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var _bloc = BlocProvider.of<ThemeBloc>(context);

    return StreamBuilder(
        stream: _bloc.colorStream,
        initialData: _bloc.color,
        builder: (_, AsyncSnapshot<Color> snapshot) => Theme(
              data: ThemeData(primarySwatch: snapshot.data, iconTheme: IconThemeData(color: snapshot.data)),
              child: Scaffold(
                appBar: AppBar(
                  title: Text('主题色选择'),
                ),
                body: Container(
                  color: Colors.black12,
                  padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 20.0),
                  child: CustomScrollView(
                    slivers: <Widget>[
                      SliverToBoxAdapter(
                          child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text('当前主题色：', style: TextStyle(fontSize: 16.0, color: snapshot.data)),
                          Container(width: 40.0, height: 40.0, color: snapshot.data)
                        ],
                      )),
                      SliverPadding(padding: const EdgeInsets.symmetric(vertical: 20.0)),
                      SliverGrid(
                          delegate: SliverChildBuilderDelegate(
                              (_, index) => InkWell(
                                    child: Container(color: ThemeBloc.themeColors[index]),
                                    onTap: () {
                                      _bloc.switchTheme(index);
                                      PreferenceUtils.instance.saveInteger(PreferencesKey.THEME_COLOR_INDEX, index);
                                    },
                                  ),
                              childCount: ThemeBloc.themeColors.length),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, mainAxisSpacing: 20.0, crossAxisSpacing: 20.0)),
                    ],
                  ),
                ),
              ),
            ));
  }
}
