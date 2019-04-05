import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_weather/bloc/bloc_provider.dart';
import 'package:flutter_weather/bloc/provinces_bloc.dart';
import 'package:flutter_weather/bloc/settings_bloc.dart';
import 'package:flutter_weather/configs/application.dart';
import 'package:flutter_weather/configs/preferences_key.dart';
import 'package:flutter_weather/model/district_model.dart';
import 'package:flutter_weather/routers/routers.dart';
import 'package:flutter_weather/utils/preference_utils.dart';

/// 市内区选择列表页
class DistrictListPage extends StatelessWidget {
  final String provinceId;
  final String cityId;
  final String name;

  DistrictListPage({Key key, this.provinceId, this.cityId, this.name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _bloc = BlocProvider.of<ProvincesBloc>(context);
    var _themeBloc = BlocProvider.of<SettingBloc>(context);

    // 数据库数据填充
    Application.db.queryAllDistrictsInCity(cityId).then((ds) => _bloc.changeDistricts(ds));
    // 网络数据更新列表并刷新数据库数据
    _bloc.requestAllDistrictsInCity(provinceId, cityId).then((ds) {
      _bloc.changeDistricts(ds);
      Application.db.insertDistrictsInCity(ds, cityId);
    });

    return StreamBuilder(
        stream: _themeBloc.colorStream,
        initialData: _themeBloc.color,
        builder: (_, AsyncSnapshot<Color> snapshot) => Theme(
            data: ThemeData(primarySwatch: snapshot.data, iconTheme: IconThemeData(color: snapshot.data)),
            child: Scaffold(
              appBar: AppBar(
                title: Text(name),
              ),
              body: Container(
                color: Colors.black12,
                alignment: Alignment.center,
                // 区选择，最后一层选择
                child: StreamBuilder(
                    stream: _bloc.districtStream,
                    initialData: _bloc.districts,
                    builder: (_, AsyncSnapshot<List<DistrictModel>> snapshot) => !snapshot.hasData || snapshot.data.isEmpty
                        ? CupertinoActivityIndicator(radius: 12.0)
                        : ListView.builder(
                            physics: BouncingScrollPhysics(),
                            padding: const EdgeInsets.symmetric(horizontal: 12.0),
                            itemBuilder: (_, index) => InkWell(
                                child: Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text(snapshot.data[index].name, style: TextStyle(fontSize: 18.0, color: Colors.black)),
                                ),
                                // 设置为当前区，并清理路由 stack，将天气界面设置到最上层
                                onTap: () {
                                  PreferenceUtils.instance.saveString(PreferencesKey.WEATHER_CITY_ID, snapshot.data[index].weatherId);
                                  Application.router.navigateTo(context, Routers.generateWeatherRouterPath(snapshot.data[index].weatherId),
                                      transition: TransitionType.inFromRight, clearStack: true);
                                }),
                            itemCount: snapshot.data.length,
                            itemExtent: 50.0)),
              ),
            )));
  }
}
