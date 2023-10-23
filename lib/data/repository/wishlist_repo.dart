import 'package:flutter/material.dart';
import 'package:shoptrangle/data/datasource/remote/dio/dio_client.dart';
import 'package:shoptrangle/data/datasource/remote/exception/api_error_handler.dart';
import 'package:shoptrangle/data/model/response/base/api_response.dart';
import 'package:shoptrangle/utill/app_constants.dart';

class WishListRepo {
  final DioClient dioClient;

  WishListRepo({@required this.dioClient});

  Future<ApiResponse> getWishList() async {
    try {
      final response = await dioClient.get(AppConstants.WISH_LIST_GET_URI);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> addWishList(int productID) async {
    try {
      final response = await dioClient.post(AppConstants.ADD_WISH_LIST_URI + productID.toString());
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> removeWishList(int productID) async {
    try {
      final response = await dioClient.delete(AppConstants.REMOVE_WISH_LIST_URI + productID.toString());
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
}
