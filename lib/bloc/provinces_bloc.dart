import 'package:flutter_weather/bloc/bloc_provider.dart';
import 'package:flutter_weather/configs/application.dart';
import 'package:flutter_weather/model/district_model.dart';
import 'package:flutter_weather/model/province_model.dart';
import 'package:flutter_weather/utils/api.dart';
import 'package:flutter_weather/utils/logger.dart';
import 'package:rxdart/rxdart.dart';

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

  Observable<List<ProvinceModel>> get provinceStream => Observable(_provinceController.stream);

  Observable<List<ProvinceModel>> get cityStream => Observable(_citiesController.stream);

  Observable<List<DistrictModel>> get districtStream => Observable(_districtController.stream);

  changeProvinces(List<ProvinceModel> provinces) {
    _provinces.clear();
    _provinces.addAll(provinces);
    _provinceController.add(_provinces);
  }

  changeCities(List<ProvinceModel> cities) {
    _cities.clear();
    _cities.addAll(cities);
    _citiesController.add(_cities);
  }

  changeDistricts(List<DistrictModel> districts) {
    _districts.clear();
    _districts.addAll(districts);
    _districtController.add(_districts);
  }

  /// 请求全国省
  Future<List<ProvinceModel>> requestAllProvinces() async {
    var resp = await Application.http.getRequest(WeatherApi.WEATHER_PROVINCE, callback: (msg) => _logger.log(msg, 'province'));
    return resp == null || resp.data == null ? [] : ProvinceModel.fromMapList(resp.data);
  }

  /// 请求省内城市
  Future<List<ProvinceModel>> requestAllCitiesInProvince(String proid) async {
    var resp = await Application.http.getRequest('${WeatherApi.WEATHER_PROVINCE}/$proid', callback: (msg) => _logger.log(msg, 'city'));
    return resp == null || resp.data == null ? [] : ProvinceModel.fromMapList(resp.data);
  }

  /// 请求市内的区
  Future<List<DistrictModel>> requestAllDistrictsInCity(String proid, String cityid) async {
    var resp = await Application.http.getRequest('${WeatherApi.WEATHER_PROVINCE}/$proid/$cityid', callback: (msg) => _logger.log(msg, 'district'));
    return resp == null || resp.data == null ? [] : DistrictModel.fromMapList(resp.data);
  }

  @override
  void dispose() {
    _provinceController?.close();
    _citiesController?.close();
    _districtController?.close();
  }
}
