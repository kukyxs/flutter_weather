class ProvinceModel {
  String name;
  int id;

  static ProvinceModel fromMap(Map<String, dynamic> map) {
    ProvinceModel province = new ProvinceModel();
    province.name = map['name'];
    province.id = map['id'];
    return province;
  }

  static List<ProvinceModel> fromMapList(dynamic mapList) {
    List<ProvinceModel> list = new List(mapList.length);
    for (int i = 0; i < mapList.length; i++) {
      list[i] = fromMap(mapList[i]);
    }
    return list;
  }

  static ProvinceModel fromProvinceTable(Map<String, dynamic> map) {
    ProvinceModel model = new ProvinceModel();
    model.id = map['province_id'];
    model.name = map['province_name'];
    return model;
  }

  static List<ProvinceModel> fromProvinceTableList(dynamic mapList) {
    List<ProvinceModel> list = new List(mapList.length);
    for (int i = 0; i < mapList.length; i++) {
      list[i] = fromProvinceTable(mapList[i]);
    }
    return list;
  }

  static ProvinceModel fromCityTable(Map<String, dynamic> map) {
    ProvinceModel model = new ProvinceModel();
    model.id = map['city_id'];
    model.name = map['city_name'];
    return model;
  }

  static List<ProvinceModel> fromCityTableList(dynamic mapList) {
    List<ProvinceModel> list = new List(mapList.length);
    for (int i = 0; i < mapList.length; i++) {
      list[i] = fromCityTable(mapList[i]);
    }
    return list;
  }
}
