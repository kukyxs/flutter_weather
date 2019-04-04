import 'package:dio/dio.dart';

typedef ErrorCallback = void Function(String msg);

class HttpUtils {
  static const GET = 'get';
  static const POST = 'post';

  static Dio _dio;

  static HttpUtils _instance;

  HttpUtils._internal({String baseUrl}) {
    _dio = Dio(BaseOptions(baseUrl: baseUrl, connectTimeout: 10000, receiveTimeout: 10000));
  }

  factory HttpUtils({String baseUrl}) {
    if (_instance == null) _instance = HttpUtils._internal(baseUrl: baseUrl);
    return _instance;
  }

  addInterceptor(List<InterceptorsWrapper> interceptors) {
    _dio.interceptors.clear();
    _dio.interceptors.addAll(interceptors);
  }

  Future<Response<T>> getRequest<T>(url, {Map params, ErrorCallback callback}) => _request(url, GET, params: params, callback: callback);

  Future<Response<T>> postRequest<T>(url, {Map params, ErrorCallback callback}) => _request(url, POST, params: params, callback: callback);

  Future<Response> download(url, path, {ProgressCallback receive, CancelToken token}) =>
      _dio.download(url, path, onReceiveProgress: receive, cancelToken: token);

  Future<Response<T>> _request<T>(
    url,
    String method, {
    Map params,
    Options opt,
    ErrorCallback callback,
    ProgressCallback send,
    ProgressCallback receive,
    CancelToken token,
  }) async {
    try {
      Response<T> rep;

      if (method == GET) {
        /// 当有参数的时候，get 方法使用 queryParams 会出错，不懂原因，使用拼接没有问题
        if (params != null && params.isNotEmpty) {
          var sb = StringBuffer('?');
          params.forEach((key, value) {
            sb.write('$key=$value&');
          });
          url += sb.toString().substring(0, sb.length - 1);
        }
        rep = await _dio.get(url, options: opt, onReceiveProgress: receive, cancelToken: token);
      } else if (method == POST) {
        rep = params == null
            ? await _dio.post(url, options: opt, cancelToken: token, onSendProgress: send, onReceiveProgress: receive)
            : await _dio.post(url, data: params, options: opt, cancelToken: token, onSendProgress: send, onReceiveProgress: receive);
      }

      if (rep.statusCode != 200 && callback != null) {
        callback('network error, and code is ${rep.statusCode}');
        return null;
      }
      return rep;
    } catch (e) {
      if (callback != null) {
        callback('network error, catch error: ${e.toString()}');
      }
      return null;
    }
  }
}
