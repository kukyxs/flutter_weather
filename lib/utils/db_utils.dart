import 'package:flutter_weather/model/district_model.dart';
import 'package:flutter_weather/model/province_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseUtils {
  final String _dbName = 'weather.db';
  final String _tableProvinces = 'provinces'; // 省表
  final String _tableCities = 'cities'; // 市表
  final String _tableDistricts = 'districts'; // 区表
  static Database _db;

  static DatabaseUtils _instance;

  static DatabaseUtils get instance => DatabaseUtils();

  DatabaseUtils._internal() {
    getDatabasesPath().then((path) async {
      _db = await openDatabase(join(path, _dbName), version: 1, onCreate: (db, version) {
        db.execute('create table $_tableProvinces('
            'id integer primary key autoincrement,'
            'province_id integer not null unique,'
            'province_name text not null'
            ')');

        db.execute('create table $_tableCities('
            'id integer primary key autoincrement,'
            'city_id integer not null unique,'
            'city_name text not null,'
            'province_id integer not null,'
            'foreign key(province_id) references $_tableProvinces(province_id)'
            ')');

        db.execute('create table $_tableDistricts('
            'id integer primary key autoincrement,'
            'district_id integer not null unique,'
            'district_name text not null,'
            'weather_id text not null unique,'
            'city_id integer not null,'
            'foreign key(city_id) references $_tableCities(city_id)'
            ')');
      }, onUpgrade: (db, oldVersion, newVersion) {});
    });
  }

  factory DatabaseUtils() {
    if (_instance == null) {
      _instance = DatabaseUtils._internal();
    }
    return _instance;
  }

  Future<List<ProvinceModel>> queryAllProvinces() async =>
      ProvinceModel.fromProvinceTableList(await _db.rawQuery('select province_id, province_name from $_tableProvinces'));

  Future<List<ProvinceModel>> queryAllCitiesInProvince(String proid) async => ProvinceModel.fromCityTableList(await _db.rawQuery(
        'select city_id, city_name from $_tableCities where province_id = ?',
        [proid],
      ));

  Future<List<DistrictModel>> queryAllDistrictsInCity(String cityid) async => DistrictModel.fromDistrictTableList(await _db.rawQuery(
        'select district_id, district_name, weather_id from $_tableDistricts where city_id = ?',
        [cityid],
      ));

  Future<void> insertProvinces(List<ProvinceModel> provinces) async {
    var batch = _db.batch();
    provinces.forEach((p) => batch.rawInsert(
          'insert or ignore into $_tableProvinces (province_id, province_name) values (?, ?)',
          [p.id, p.name],
        ));
    batch.commit();
  }

  Future<void> insertCitiesInProvince(List<ProvinceModel> cities, String proid) async {
    var batch = _db.batch();
    cities.forEach((c) => batch.rawInsert(
          'insert or ignore into $_tableCities (city_id, city_name, province_id) values (?, ?, ?)',
          [c.id, c.name, proid],
        ));
    batch.commit();
  }

  Future<void> insertDistrictsInCity(List<DistrictModel> districts, String cityid) async {
    var batch = _db.batch();
    districts.forEach((d) => batch.rawInsert(
          'insert or ignore into $_tableDistricts (district_id, district_name, weather_id, city_id) values (?, ?, ?, ?)',
          [d.id, d.name, d.weatherId, cityid],
        ));
    batch.commit();
  }
}
