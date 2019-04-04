class WeatherApi {
  static const WEATHER_HOST = 'http://guolin.tech';

  /// 获取城市列表，省级市通过添加省 id 获取，市级下的城市再添加城市 id 获取
  /// 例如 /api/china/1/2 则获取到 北京市海淀区
  static const WEATHER_PROVINCE = '/api/china';

  /// 获取当前城市的天气状态，模拟数据，需要传入的参数：
  /// cityid 根据获取城市信息后返回的 weather_id，key 需要到和风天气申请
  static const WEATHER_STATUS = '/api/weather';

  /// 获取图片背景 api
  static const WEATHER_BACKGROUND = '/api/bing_pic';

  /// 请求天气 api 的 key，请到 http://guolin.tech/api/weather/register 申请免费的 key
  static const WEATHER_KEY = '21fdcdadc9a24472a38377b2e57b20d5';

  /// 默认背景
  static const DEFAULT_BACKGROUND = 'http://cn.bing.com/th?id=OHR.NelderPlot_ZH-CN3786459560_1920x1080.jpg&rf=LaDigue_1920x1081920x1080.jpg';
}
