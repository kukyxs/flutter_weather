import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_weather/bloc/bloc_provider.dart';
import 'package:flutter_weather/bloc/provinces_bloc.dart';
import 'package:flutter_weather/bloc/settings_bloc.dart';
import 'package:flutter_weather/configs/application.dart';
import 'package:flutter_weather/model/province_model.dart';
import 'package:flutter_weather/routers/routers.dart';
import 'package:flutter_weather/utils/fluro_convert_util.dart';

/// 全国省选择列表页
class ProvinceListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var _bloc = BlocProvider.of<ProvincesBloc>(context);
    var _themeBloc = BlocProvider.of<SettingBloc>(context);

    // 数据库数据填充
    Application.db.queryAllProvinces().then((ps) => _bloc.changeProvinces(ps));
    // 网络数据更新列表并刷新数据库数据
    _bloc.requestAllProvinces().then((provinces) {
      _bloc.changeProvinces(provinces);
      Application.db.insertProvinces(provinces);
    });

    return StreamBuilder(
        stream: _themeBloc.colorStream,
        initialData: _themeBloc.color,
        builder: (_, AsyncSnapshot<Color> snapshot) => Theme(
            data: ThemeData(primarySwatch: snapshot.data, iconTheme: IconThemeData(color: snapshot.data)),
            child: Scaffold(
              appBar: AppBar(
                title: Text('请选择省份'),
              ),
              body: Container(
                color: Colors.black12,
                alignment: Alignment.center,
                // 省列表选择
                child: StreamBuilder(
                  stream: _bloc.provinceStream,
                  initialData: _bloc.provinces,
                  builder: (_, AsyncSnapshot<List<ProvinceModel>> snapshot) => !snapshot.hasData || snapshot.data.isEmpty
                      ? CupertinoActivityIndicator(radius: 12.0)
                      : ListView.builder(
                          physics: BouncingScrollPhysics(),
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          itemBuilder: (_, index) => InkWell(
                                child: Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text(snapshot.data[index].name, style: TextStyle(fontSize: 18.0, color: Colors.black)),
                                ),
                                onTap: () => Application.router.navigateTo(
                                    context,
                                    // 跳转下层省内城市选择
                                    Routers.generateProvinceRouterPath(
                                        snapshot.data[index].id, FluroConvertUtils.fluroCnParamsEncode(snapshot.data[index].name)),
                                    transition: TransitionType.fadeIn),
                              ),
                          itemExtent: 50.0,
                          itemCount: snapshot.data.length),
                ),
              ),
            )));
  }
}
