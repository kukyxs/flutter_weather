import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_weather/bloc/bloc_provider.dart';
import 'package:flutter_weather/bloc/provinces_bloc.dart';
import 'package:flutter_weather/configs/application.dart';
import 'package:flutter_weather/model/province_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_weather/routers/routers.dart';
import 'package:flutter_weather/utils/fluro_convert_util.dart';

class ProvinceListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ProvincesBloc _bloc = BlocProvider.of<ProvincesBloc>(context);
    _bloc.requestAllProvinces().then((provinces) => _bloc.changeProvinces(provinces));

    return Scaffold(
      appBar: AppBar(
        title: Text('请选择省份'),
      ),
      body: Container(
        alignment: Alignment.center,
        child: StreamBuilder(
          stream: _bloc.provinceStream,
          initialData: _bloc.provinces,
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
                            Routers.generateProvinceRouterPath(
                                snapshot.data[index].id, FluroConvertUtils.fluroCnParamsEncode(snapshot.data[index].name)),
                            transition: TransitionType.fadeIn),
                      ),
                  itemExtent: 50.0,
                  itemCount: snapshot.data.length),
        ),
      ),
    );
  }
}
