import 'package:dio/dio.dart';
import 'package:e_com/core/core.dart';
import 'package:e_com/feature/auth/controller/auth_ctrl.dart';
import 'package:e_com/feature/region_settings/controller/region_ctrl.dart';
import 'package:e_com/feature/region_settings/provider/region_provider.dart';
import 'package:e_com/locator.dart';
import 'package:e_com/models/settings/region_model.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

export 'package:dio/dio.dart' show DioException;

class DioClient {
  DioClient(this._ref) {
    _dio = Dio(_options);
    _dio.interceptors.add(_interceptorsWrapper());
    _dio.interceptors.add(talk.dioLogger);
  }

  late Dio _dio;

  final _options = BaseOptions(
    baseUrl: Endpoints.baseApiUrl,
    connectTimeout: Endpoints.connectionTimeout,
    receiveTimeout: Endpoints.receiveTimeout,
    responseType: ResponseType.json,
    headers: {'Accept': 'application/json'},
  );

  final Ref _ref;

  Future<Map<String, String?>> header() async {
    final region = await _ref.watch(regionCtrlProvider.future);
    final token = locate<SharedPreferences>().getString(PrefKeys.accessToken);

    final currencyUid = region.currencyUid;
    final langCode = region.langCode;

    return {
      'api-lang': langCode,
      'currency-uid': currencyUid,
      'Authorization': 'Bearer $token',
    };
  }

  // Get:-----------------------------------------------------------------------
  Future<Response> get(
    String url, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final Response response = await _dio.get(
        url,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } on DioException {
      rethrow;
    }
  }

  // Post:----------------------------------------------------------------------
  Future<Response> post(
    String url, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final formData = data == null
          ? null
          : FormData.fromMap(data, ListFormat.multiCompatible);

      final Response response = await _dio.post(
        url,
        data: formData,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } on DioException {
      rethrow;
    }
  }

  Future<Response> download(
    String url,
    String savePath, {
    void Function(int, int)? onReceiveProgress,
  }) async {
    try {
      final Response response = await _dio.get(
        url,
        onReceiveProgress: onReceiveProgress,
        options: Options(
          headers: {},
          responseType: ResponseType.bytes,
          followRedirects: false,
          validateStatus: (status) {
            return (status ?? 0) < 500;
          },
        ),
      );
      Logger(response.data, 'download');
      return response;
    } on DioException {
      rethrow;
    }
  }

  // Interceptors :----------------------------------------------------------------------
  _interceptorsWrapper() => InterceptorsWrapper(
        onRequest: (options, handler) async {
          final headers = await header();
          options.headers.addAll(headers);
          return handler.next(options);
        },
        onResponse: (res, handler) {
          _ref
              .read(localeCurrencyStateProvider.notifier)
              .update((state) => LocalCurrency.fromMap(res.data));

          final statusCtrl = _ref.read(serverStatusProvider.notifier);
          final Map<String, dynamic> response = res.data ?? {};

          final code = response['code'];

          statusCtrl.update(code);
          return handler.next(res);
        },
        onError: (DioException error, handler) async {
          if (error.response?.statusCode == 401) {
            _ref.read(authCtrlProvider.notifier).logOut();
          }
          final statusCtrl = _ref.read(serverStatusProvider.notifier);
          final data = error.response?.data;

          if (data is Map?) {
            final response = data ?? {};
            final code = response['code'];
            statusCtrl.update(code);
          }
          return handler.next(error);
        },
      );
}
