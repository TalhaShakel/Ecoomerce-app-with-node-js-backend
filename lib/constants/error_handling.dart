import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'utils.dart';

void httpErrorHandle({
  required http.Response response,
  required BuildContext context,
  required VoidCallback onSuccess,
  VoidCallback? onBadRequest,
  VoidCallback? onUnauthorized,
  VoidCallback? onForbidden,
  VoidCallback? onNotFound,
  VoidCallback? onInternalServerError,
  VoidCallback? onUnknownError,
}) {
  switch (response.statusCode) {
    case 200:
      onSuccess();
      break;
    case 400:
      onBadRequest?.call();
      if (onBadRequest == null) {
        showSnackBar(context, jsonDecode(response.body)['msg']);
      }
      break;
    case 401:
      onUnauthorized?.call();
      if (onUnauthorized == null) {
        showSnackBar(context, "Unauthorized");
      }
      break;
    case 403:
      onForbidden?.call();
      if (onForbidden == null) {
        showSnackBar(context, "Forbidden");
      }
      break;
    case 404:
      onNotFound?.call();
      if (onNotFound == null) {
        showSnackBar(context, "Not Found");
      }
      break;
    case 500:
      onInternalServerError?.call();
      if (onInternalServerError == null) {
        showSnackBar(context, jsonDecode(response.body)['error']);
      }
      break;
    default:
      onUnknownError?.call();
      if (onUnknownError == null) {
        showSnackBar(context, response.body);
      }
  }
}
