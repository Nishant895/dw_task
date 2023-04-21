
import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:task/data/data_status.dart';
import 'package:task/home/model/product_list_model.dart';

class ProductListViewModel with ChangeNotifier{
  DataStatus _dataStatus = DataStatus.initial('Empty data');

  int cartvalue = 0;

  List<ProductListModel> productList = [
    ProductListModel(productName: "Product 1", price: "10", itemCount: 0),
    ProductListModel(productName: "Product 2", price: "20", itemCount: 0),
    ProductListModel(productName: "Product 3", price: "30", itemCount: 0),
    ProductListModel(productName: "Product 4", price: "40", itemCount: 0),
    ProductListModel(productName: "Product 5", price: "50", itemCount: 0),
    ProductListModel(productName: "Product 6", price: "10", itemCount: 0),
    ProductListModel(productName: "Product 7", price: "40", itemCount: 0),
  ];

  List<ProductListModel> cartList = [];


  List<ProductListModel> productListFromDb =  [];


  List<ProductListModel>? get getProductList {
    return productListFromDb;
  }

  int get getcartvalue {
    return cartvalue;
  }

  List<ProductListModel>? get getcartList {
    return cartList;
  }

  DataStatus get getDataStatus {
    return _dataStatus;
  }


  getValueFromDb() async{
    _dataStatus = DataStatus.loading('loading');
    notifyListeners();

    var box = await Hive.openBox('ProductListBox');


    if(box.get("PRODUCT_LIST") == null){
      var stringList = ProductListModel.encode(productList);
      box.put("PRODUCT_LIST", stringList);

      // convert string data to jsonMap
      var getStringList = box.get("PRODUCT_LIST");

      // convert json map list to object model list
      productListFromDb  = ProductListModel.decode(getStringList!);

      cartvalue = 0;
      for(int i = 0; i<productListFromDb.length ; i++){
        cartvalue = cartvalue + productListFromDb[i].itemCount;
      }

      _dataStatus = DataStatus.completed('complete');

    }else{

      // convert string data to jsonMap
      var getStringList = box.get("PRODUCT_LIST");

      // convert json map list to object model list
      productListFromDb  = ProductListModel.decode(getStringList!);

      cartvalue = 0;
      for(int i = 0; i<productListFromDb.length ; i++){

        cartvalue = cartvalue + productListFromDb[i].itemCount;
      }

      _dataStatus = DataStatus.completed('complete');

    }

    notifyListeners();
  }

  addProductInCart(int index) async {
    var box = await Hive.openBox('ProductListBox');
    // convert string data to jsonMap
    var getStringList = box.get("PRODUCT_LIST");
    // convert json map list to object model list
    productListFromDb  = ProductListModel.decode(getStringList!);
    for(int i = 0; i<productListFromDb.length ; i++){

      if(i == index){
        productListFromDb.elementAt(index).itemCount = productListFromDb.elementAt(index).itemCount + 1;

        var stringList = ProductListModel.encode(productListFromDb);
        box.put("PRODUCT_LIST", stringList);

        // convert string data to jsonMap
        var getStringList = box.get("PRODUCT_LIST");

        // convert json map list to object model list
        productListFromDb  = ProductListModel.decode(getStringList!);

        cartvalue = 0;
        for(int i = 0; i<productListFromDb.length ; i++){
          cartvalue = cartvalue + productListFromDb[i].itemCount;
        }

        notifyListeners();
      }
    }

  }

  subtractProductInCart(int index) async {
    var box = await Hive.openBox('ProductListBox');
    // convert string data to jsonMap
    var getStringList = box.get("PRODUCT_LIST");

    // convert json map list to object model list
    productListFromDb  = ProductListModel.decode(getStringList!);
    for(int i = 0; i<productListFromDb.length ; i++){
      if(i == index){
        productListFromDb.elementAt(index).itemCount = productListFromDb.elementAt(index).itemCount - 1;

        var stringList = ProductListModel.encode(productListFromDb);
        box.put("PRODUCT_LIST", stringList);

        // convert string data to jsonMap
        var getStringList = box.get("PRODUCT_LIST");

        // convert json map list to object model list
        productListFromDb  = ProductListModel.decode(getStringList!);

        cartvalue = 0;
        for(int i = 0; i<productListFromDb.length ; i++){
          cartvalue = cartvalue + productListFromDb[i].itemCount;
        }

        notifyListeners();
      }
    }
  }

  createCartList() async {
    cartList = [];
    var box = await Hive.openBox('ProductListBox');
    // convert string data to jsonMap
    var getStringList = box.get("PRODUCT_LIST");

    // convert json map list to object model list
    productListFromDb  = ProductListModel.decode(getStringList!);

    for(int i = 0; i< productListFromDb.length ; i++){
      if(productListFromDb[i].itemCount > 0){
        cartList.add(productListFromDb[i]);
      }
    }
    var stringCartList = ProductListModel.encode(cartList);

    box.put("CART_LIST", stringCartList);

    notifyListeners();
  }

}