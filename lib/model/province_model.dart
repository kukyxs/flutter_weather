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
}
