import 'package:dio/dio.dart';

/// 监听当前的网络请求状态，根据状态显示一些必要提醒
enum NetState {
  requesting, // 正在请求
  succeed, // 请求成功
  failed, // 请求出错
}

typedef ErrorCallback = void Function(String msg);

typedef NetStateCallback = void Function(NetState state);

/// 网络请求封装
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

  Future<Response<T>> getRequest<T>(
    url, {
    Map params,
    Options opt,
    NetStateCallback state,
    ErrorCallback error,
    ProgressCallback receive,
    CancelToken token,
  }) =>
      _request(url, GET, params: params, opt: opt, state: state, error: error, receive: receive, token: token);

  Future<Response<T>> postRequest<T>(
    url, {
    Map params,
    Options opt,
    NetStateCallback state,
    ErrorCallback error,
    ProgressCallback send,
    ProgressCallback receive,
    CancelToken token,
  }) =>
      _request(url, POST, params: params, opt: opt, state: state, error: error, send: send, receive: receive, token: token);

  Future<Response> download(url, path, {ProgressCallback receive, CancelToken token}) =>
      _dio.download(url, path, onReceiveProgress: receive, cancelToken: token);

  Future<Response<T>> _request<T>(
    url,
    String method, {
    Map params,
    Options opt,
    NetStateCallback state,
    ErrorCallback error,
    ProgressCallback send,
    ProgressCallback receive,
    CancelToken token,
  }) async {
    try {
      Response<T> rep;
      if (state != null) {
        state(NetState.requesting);
      }

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

      if (rep.statusCode != 200 && error != null) {
        if (state != null) {
          state(NetState.failed);
        }
        error('network error, and code is ${rep.statusCode}');
        return null;
      }

      if (state != null) {
        state(NetState.succeed);
      }
      return rep;
    } catch (e) {
      if (error != null) {
        error('network error, catch error: ${e.toString()}');
      }

      if (state != null) {
        state(NetState.failed);
      }
      return null;
    }
  }
}
