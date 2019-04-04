import 'package:flutter_weather/bloc/bloc_provider.dart';
import 'package:flutter_weather/configs/application.dart';
import 'package:flutter_weather/model/district_model.dart';
import 'package:flutter_weather/model/province_model.dart';
import 'package:flutter_weather/utils/api.dart';
import 'package:flutter_weather/utils/logger.dart';
import 'package:rxdart/rxdart.dart';

/// 天气城市信息管理类
class ProvincesBloc extends BaseBloc {
  final _logger = Logger('ProvincesBloc');

  List<ProvinceModel> _provinces = []; // 全国省
  List<ProvinceModel> _cities = []; // 省内市
  List<DistrictModel> _districts = []; // 市内区

  List<ProvinceModel> get provinces => _provinces;

  List<ProvinceModel> get cities => _cities;

  List<DistrictModel> get districts => _districts;

  BehaviorSubject<List<ProvinceModel>> _provinceController = BehaviorSubject();

  BehaviorSubject<List<ProvinceModel>> _citiesController = BehaviorSubject();

  BehaviorSubject<List<DistrictModel>> _districtController = BehaviorSubject();

  /// stream，用于 StreamBuilder 的 stream 参数
  Observable<List<ProvinceModel>> get provinceStream => Observable(_provinceController.stream);

  Observable<List<ProvinceModel>> get cityStream => Observable(_citiesController.stream);

  Observable<List<DistrictModel>> get districtStream => Observable(_districtController.stream);

  /// 通知刷新省份列表
  changeProvinces(List<ProvinceModel> provinces) {
    _provinces.clear();
    _provinces.addAll(provinces);
    _provinceController.add(_provinces);
  }

  /// 通知刷新城市列表
  changeCities(List<ProvinceModel> cities) {
    _cities.clear();
    _cities.addAll(cities);
    _citiesController.add(_cities);
  }

  /// 通知刷新区列表
  changeDistricts(List<DistrictModel> districts) {
    _districts.clear();
    _districts.addAll(districts);
    _districtController.add(_districts);
  }

  /// 请求全国省
  Future<List<ProvinceModel>> requestAllProvinces() async {
    var resp = await Application.http.getRequest(WeatherApi.WEATHER_PROVINCE, error: (msg) => _logger.log(msg, 'province'));
    return resp == null || resp.data == null ? [] : ProvinceModel.fromMapList(resp.data);
  }

  /// 请求省内城市
  Future<List<ProvinceModel>> requestAllCitiesInProvince(String proid) async {
    var resp = await Application.http.getRequest('${WeatherApi.WEATHER_PROVINCE}/$proid', error: (msg) => _logger.log(msg, 'city'));
    return resp == null || resp.data == null ? [] : ProvinceModel.fromMapList(resp.data);
  }

  /// 请求市内的区
  Future<List<DistrictModel>> requestAllDistrictsInCity(String proid, String cityid) async {
    var resp = await Application.http.getRequest('${WeatherApi.WEATHER_PROVINCE}/$proid/$cityid', error: (msg) => _logger.log(msg, 'district'));
    return resp == null || resp.data == null ? [] : DistrictModel.fromMapList(resp.data);
  }

  @override
  void dispose() {
    _provinceController?.close();
    _citiesController?.close();
    _districtController?.close();
  }
}
