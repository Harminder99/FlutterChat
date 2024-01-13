import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:untitled2/NetworkApi/ApiEndpoints.dart';

import 'ApiResponse.dart';
import 'HeaderService.dart';

class ApiService {
  final Dio _dio = Dio();
  final HeaderService _headerService;
  final Map<String, CancelToken> _cancelTokens = {};

  ApiService(this._headerService);

  void cancelAllApi() {
    _cancelTokens.forEach((key, token) {
      token.cancel("Cancelled");
    });
    _cancelTokens.clear();

  }

  void cancelApi(String apiEndPoint) {
    CancelToken? token = _cancelTokens[apiEndPoint];
    token?.cancel("Cancelled");
    _cancelTokens.remove(apiEndPoint);
  }
  Future<ApiResponse<T>> getWithBody<T>(String apiEndPoint, String params,dynamic body, T Function(dynamic) fromJson) async {
    try {
      debugPrint("Future ==> ${ApiEndpoints.baseUrl}$apiEndPoint$params");
      CancelToken cancelToken = CancelToken();
      _cancelTokens[apiEndPoint] = cancelToken;
      Response response = await _dio.get(
        "${ApiEndpoints.baseUrl}$apiEndPoint$params",
        data: body,
        options: Options(headers: _headerService.getHeaders(apiEndPoint)),
        cancelToken: cancelToken,
      );
      cancelApi(apiEndPoint);
      return ApiResponse(data: fromJson(response.data));
    } on DioException catch (e) {
      cancelApi(apiEndPoint);
      final errorMessage = e.response?.data["message"] ?? 'Unknown error occurred';
      final status = e.response?.statusCode;
      return ApiResponse(error: ApiError(message: errorMessage, status: status));
    } catch (e) {
      debugPrint("API Error ==> ${e.toString()}");
      cancelApi(apiEndPoint);
      return ApiResponse(error: ApiError(message: 'Unknown error occurred', status: 400));
    }
  }


  Future<ApiResponse<T>> get<T>(String apiEndPoint, String params, T Function(dynamic) fromJson) async {
    debugPrint("Future ==> ${ApiEndpoints.baseUrl}$apiEndPoint$params");
    try {
      debugPrint("Future ==> ${ApiEndpoints.baseUrl}$apiEndPoint$params");
      CancelToken cancelToken = CancelToken();
      _cancelTokens[apiEndPoint] = cancelToken;
      Response response = await _dio.get(
        "${ApiEndpoints.baseUrl}$apiEndPoint$params",
        options: Options(headers: _headerService.getHeaders(apiEndPoint)),
        cancelToken: cancelToken,
      );
      cancelApi(apiEndPoint);
      return ApiResponse(data: fromJson(response.data));
    } on DioException catch (e) {
      cancelApi(apiEndPoint);
      final errorMessage = e.response?.data["message"] ?? 'Unknown error occurred';
      final status = e.response?.statusCode;
      return ApiResponse(error: ApiError(message: errorMessage, status: status));
    } catch (e) {
      debugPrint("API Error ==> ${e.toString()}");
      cancelApi(apiEndPoint);
      return ApiResponse(error: ApiError(message: 'Unknown error occurred', status: 400));
    }
  }

  Future<ApiResponse<T>> post<T>(String apiEndPoint, dynamic data, T Function(dynamic) fromJson) async {
    try {
      debugPrint("data ==> ${ApiEndpoints.baseUrl}$apiEndPoint $data");
      CancelToken cancelToken = CancelToken();
      _cancelTokens[apiEndPoint] = cancelToken;
      Response response = await _dio.post(
        "${ApiEndpoints.baseUrl}$apiEndPoint",
        data: data,
        options: Options(headers: _headerService.getHeaders(apiEndPoint)),
        cancelToken: cancelToken,
      );
      cancelApi(apiEndPoint);

      return ApiResponse(data: fromJson(response.data));
    } on DioException catch (e) {
      cancelApi(apiEndPoint);
      final errorMessage = e.response?.data["message"] ?? 'Unknown error occurred';
      final status = e.response?.statusCode;
      return ApiResponse(error: ApiError(message: errorMessage, status: status));
    } catch (e) {
      debugPrint("API Error ==> ${e.toString()}");
      cancelApi(apiEndPoint);
      return ApiResponse(error: ApiError(message: 'Unknown error occurred', status: 400));
    }
  }

  Future<ApiResponse<T>> patch<T>(String apiEndPoint, dynamic data, T Function(dynamic) fromJson) async {
    try {
      CancelToken cancelToken = CancelToken();
      _cancelTokens[apiEndPoint] = cancelToken;
      Response response = await _dio.patch(
        "${ApiEndpoints.baseUrl}$apiEndPoint",
        data: data,
        options: Options(headers: _headerService.getHeaders(apiEndPoint)),
        cancelToken: cancelToken,
      );
      cancelApi(apiEndPoint);
      return ApiResponse(data: fromJson(response.data));
    } on DioException catch (e) {
      cancelApi(apiEndPoint);
      final errorMessage = e.response?.data["message"] ?? 'Unknown error occurred';
      final status = e.response?.statusCode;
      return ApiResponse(error: ApiError(message: errorMessage, status: status));
    } catch (e) {
      debugPrint("API Error ==> ${e.toString()}");
      cancelApi(apiEndPoint);
      return ApiResponse(error: ApiError(message: 'Unknown error occurred', status: 400));
    }
  }


  Future<ApiResponse<T>> delete<T>(String apiEndPoint, dynamic data, T Function(dynamic) fromJson) async {
    try {
      CancelToken cancelToken = CancelToken();
      _cancelTokens[apiEndPoint] = cancelToken;
      Response response = await _dio.delete(
        "${ApiEndpoints.baseUrl}$apiEndPoint",
        data: data,
        options: Options(headers: _headerService.getHeaders(apiEndPoint)),
        cancelToken: cancelToken,
      );
      cancelApi(apiEndPoint);
      return ApiResponse(data: fromJson(response.data));
    } on DioException catch (e) {
      cancelApi(apiEndPoint);
      final errorMessage = e.response?.data["message"] ?? 'Unknown error occurred';
      final status = e.response?.statusCode;
      return ApiResponse(error: ApiError(message: errorMessage, status: status));
    } catch (e) {
      debugPrint("API Error ==> ${e.toString()}");
      cancelApi(apiEndPoint);
      return ApiResponse(error: ApiError(message: 'Unknown error occurred', status: 400));
    }
  }

}
