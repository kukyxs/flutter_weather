class DistrictModel {
  String name;
  String weather_id;
  int id;

  static DistrictModel fromMap(Map<String, dynamic> map) {
    DistrictModel city = new DistrictModel();
    city.name = map['name'];
    city.weather_id = map['weather_id'];
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
}
