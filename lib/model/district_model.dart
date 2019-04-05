class DistrictModel {
  String name;
  String weatherId;
  int id;

  static DistrictModel fromMap(Map<String, dynamic> map) {
    DistrictModel city = new DistrictModel();
    city.name = map['name'];
    city.weatherId = map['weather_id'];
    city.id = map['id'];
    return city;
  }

  static List<DistrictModel> fromMapList(dynamic mapList) {
    List<DistrictModel> list = new List(mapList.length);
    for (int i = 0; i < mapList.length; i++) {
      list[i] = fromMap(mapList[i]);
    }
    return list;
  }

  static DistrictModel fromTDistrictTable(Map<String, dynamic> map) {
    DistrictModel city = new DistrictModel();
    city.name = map['district_name'];
    city.weatherId = map['weather_id'];
    city.id = map['district_id'];
    return city;
  }

  static List<DistrictModel> fromDistrictTableList(dynamic mapList) {
    List<DistrictModel> list = new List(mapList.length);
    for (int i = 0; i < mapList.length; i++) {
      list[i] = fromTDistrictTable(mapList[i]);
    }
    return list;
  }
}
