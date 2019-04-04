/// 打印类
class Logger {
  final String _name; // 基础打印信息筛选标志
  bool _debug = true;

  Logger._internal(this._name);

  static Map<String, Logger> _cache;

  factory Logger(String name) {
    if (_cache == null) {
      _cache = {};
    }

    if (_cache.containsKey(name)) {
      return _cache[name];
    } else {
      var logger = Logger._internal(name);
      _cache[name] = logger;
      return logger;
    }
  }

  void log(Object msg, [String tag]) {
    if (_debug) {
      print('$_name => ${tag == null ? '' : '$tag: '}$msg');
    }
  }
}
