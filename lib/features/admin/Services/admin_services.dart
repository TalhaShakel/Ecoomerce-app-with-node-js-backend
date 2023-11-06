import 'dart:convert';
import 'dart:io';
import 'package:amazone_clone/constants/global_variables.dart';
import 'package:cloudinary_public/cloudinary_public.dart';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../../../Models/product.dart';
import '../../../PROVIDERS/user_provider.dart';
import '../../../constants/error_handling.dart';
import '../../../constants/utils.dart';

class AdminServices {
  void sellProduct({
    required BuildContext context,
    required String name,
    required String description,
    required double price,
    required double quantity,
    required String category,
    required List<File> images,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      EasyLoading.show();
      final cloudinary =
          CloudinaryPublic('djh4x7a6p', 'zhg6l1h2', cache: false);

      // final cloudinary = CloudinaryPublic('djh4x7a6p', 'ml_default');
      List<String> imageUrls = [];
      int l = images.length;
      print(l);

      for (int i = 0; i < l; i++) {
        print(i);
        // CloudinaryResponse response = await cloudinary.uploadFile(
        //   CloudinaryFile.fromFile(images[i].path,
        //       resourceType: CloudinaryResourceType.Image),
        // );
        CloudinaryResponse res = await cloudinary.uploadFile(
          CloudinaryFile.fromFile(images[i].path, folder: name),
        );
        imageUrls.add(res.secureUrl);
      }
      print(imageUrls);

      // print(object)
      Product product = Product(
        name: name,
        description: description,
        quantity: quantity,
        images: imageUrls,
        category: category,
        price: price,
      );
      print(product.toJson());
      http.Response res = await http.post(
        Uri.parse('$uri/admin/add-product'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
        body: product.toJson(),
      );
      print("Request Body: ${res.body}");
      print("Status Code: ${res.statusCode}");
      if (res.statusCode == 200)
        EasyLoading.showSuccess("Product Added Successfully!");

      EasyLoading.dismiss();
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          showSnackBar(context, 'Product Added Successfully!');
          Navigator.pop(context);
        },
      );
    } catch (e) {
      EasyLoading.dismiss();

      showSnackBar(context, e.toString());
    }
  }

  
  
  
  Future<List<Product>> fetchAllProducts(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<Product> productList = [];
    try {
      http.Response res =
          await http.get(Uri.parse('$uri/admin/get-products'), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': userProvider.user.token,
      });
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          for (int i = 0; i < jsonDecode(res.body).length; i++) {
            productList.add(
              Product.fromJson(
                jsonEncode(
                  jsonDecode(res.body)[i],
                ),
              ),
            );
          }
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    return productList;
  }
}
