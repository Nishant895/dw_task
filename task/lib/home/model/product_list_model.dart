import 'dart:convert';

import 'package:hive/hive.dart';

@HiveType(typeId: 1)
class ProductListModel{

  @HiveField(0)
  String productName;

  @HiveField(1)
  String price;

  @HiveField(2)
  int itemCount;

  ProductListModel({required this.productName,required this.price,required this.itemCount});

  factory ProductListModel.fromJson(Map<String, dynamic> jsonData) {
    return ProductListModel(
      productName: jsonData['ProductName'],
      price: jsonData['Price'],
      itemCount: jsonData['ItemCount'],
    );
  }

  static Map<String, dynamic> toMap(ProductListModel productListModel) => {
    'ProductName': productListModel.productName,
    'Price': productListModel.price,
    'ItemCount': productListModel.itemCount,
  };

  static String encode(List<ProductListModel> productList) => json.encode(
    productList
        .map<Map<String, dynamic>>((music) => ProductListModel.toMap(music))
        .toList(),
  );

  static List<ProductListModel> decode(String productList) =>
      (json.decode(productList) as List<dynamic>)
          .map<ProductListModel>((item) => ProductListModel.fromJson(item))
          .toList();

}

