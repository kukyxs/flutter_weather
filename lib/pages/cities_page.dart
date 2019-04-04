import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_weather/bloc/bloc_provider.dart';
import 'package:flutter_weather/bloc/provinces_bloc.dart';
import 'package:flutter_weather/configs/application.dart';
import 'package:flutter_weather/model/province_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_weather/routers/routers.dart';
import 'package:flutter_weather/utils/fluro_convert_util.dart';

class CityListPage extends StatelessWidget {
  final String provinceId;
  final String name;

  CityListPage({Key key, this.provinceId, this.name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _bloc = BlocProvider.of<ProvincesBloc>(context);
    _bloc.requestAllCitiesInProvince(provinceId).then((cs) => _bloc.changeCities(cs));

    return Scaffold(
      appBar: AppBar(
        title: Text(name),
      ),
      body: Container(
        alignment: Alignment.center,
        child: StreamBuilder(
            stream: _bloc.cityStream,
            initialData: _bloc.cities,
            builder: (_, AsyncSnapshot<List<ProvinceModel>> snapshot) => !snapshot.hasData || snapshot.data.isEmpty
                ? CupertinoActivityIndicator(radius: 12.0)
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    itemBuilder: (_, index) => InkWell(
                          child: Container(
                            alignment: Alignment.centerLeft,
                            child: Text(snapshot.data[index].name, style: TextStyle(fontSize: 18.0, color: Colors.black)),
                          ),
                          onTap: () => Application.router.navigateTo(
                              context,
                              Routers.generateCityRouterPath(
                                  int.parse(provinceId), snapshot.data[index].id, FluroConvertUtils.fluroCnParamsEncode(snapshot.data[index].name)),
                              transition: TransitionType.fadeIn),
                        ),
                    itemExtent: 50.0,
                    itemCount: snapshot.data.length)),
      ),
    );
  }
}
