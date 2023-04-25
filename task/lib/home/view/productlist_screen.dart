
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:task/data/data_status.dart';
import 'package:badges/badges.dart' as badges;
import 'package:task/home/view_model/productlist_viewmodel.dart';

import '../model/product_list_model.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({Key? key}) : super(key: key);

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {

  List<ProductListModel> productList = [];
  List<ProductListModel>  _productFilteredList = [];
  List<ProductListModel> cartList = [];

  int cartValue = 0;
  

  final TextEditingController _searchQueryController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    DataStatus dataStatus =  Provider.of<ProductListViewModel>(context).getDataStatus;
    if(dataStatus.status  != Status.COMPLETED){
      WidgetsBinding.instance.addPostFrameCallback((_){
        Provider.of<ProductListViewModel>(context, listen: false).getValueFromDb();
      });
    }
    productList = Provider.of<ProductListViewModel>(context).getProductList!;
    cartValue = Provider.of<ProductListViewModel>(context).getcartvalue;
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: appbarWidget(cartValue),
      body: _searchQueryController.text.isEmpty
      ?  
      productListWidget(productList)
      : productListWidget(_productFilteredList),
    );
  }

  PreferredSizeWidget appbarWidget(int cartValue){
    return AppBar(
      elevation: 1,
      automaticallyImplyLeading: false,
      systemOverlayStyle: const SystemUiOverlayStyle(
        // Status bar color
        statusBarColor: Colors.white,


        // Status bar brightness (optional)
        statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
        statusBarBrightness: Brightness.light, // For iOS (dark icons)
      ),
      toolbarHeight: 50,// Set this height
      flexibleSpace: SafeArea(
        child : Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: TextField(
            controller: _searchQueryController,
            autofocus: false,
            decoration: const InputDecoration(
              hintText: "Search in product",
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top : -10.0),
              hintStyle: TextStyle(color: Colors.black),
            ),
            style: const TextStyle(color: Colors.black, fontSize: 16.0,fontWeight: FontWeight.normal),
            onChanged: (query) => updateSearchQuery(query),
          ),
          ),
        ),
    );
  }

  void updateSearchQuery(String newQuery) {
    List<ProductListModel>? dummySearchList = [];
    _productFilteredList = [];
    for(int i = 0; i<productList.length ; i++){
      if (productList[i].productName.toLowerCase().contains(newQuery.toLowerCase())) {
        dummySearchList.add(productList[i]);
      }
    }

    setState(() {
      _productFilteredList.clear();
      _productFilteredList.addAll(dummySearchList);

    });


  }
  
  Widget productListWidget(List<ProductListModel> productList){
    return ListView.builder(
        padding: const EdgeInsets.only(bottom: kFloatingActionButtonMargin + 15,top: 10),
        itemCount: productList.length,
        itemBuilder: (BuildContext context, int index){
          return
            Padding(padding: const EdgeInsets.symmetric(horizontal: 15),

                child : Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: Container(
                      padding: const EdgeInsets.all(15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Image.asset("assets/images/ic_product.png",height: 100,width: 100,),
                              const SizedBox(width: 10),
                              Text(productList[index].productName.toString(),style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 16,color: Colors.black),)
                            ],
                          ),
                          if(productList[index].itemCount != 0)...[
                            Container(
                                width: 70,
                                height: 30,
                                decoration: const BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.all(Radius.circular(5))
                                ),
                                child : Center(
                                    child:
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: 30,
                                          child:  IconButton(
                                              onPressed: (){
                                                Provider.of<ProductListViewModel>(context, listen: false).subtractProductInCart(index);
                                              }, icon: Image.asset("assets/images/ic_subtract.png",height: 30,width: 30,color: Colors.white,)),
                                        ),
                                        Text(productList[index].itemCount.toString(),style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 16,color: Colors.white),),
                                        SizedBox(
                                          width: 30,
                                          child :    IconButton(
                                              onPressed: (){
                                                setState(() {
                                                  Provider.of<ProductListViewModel>(context, listen: false).addProductInCart(index);
                                                });
                                              },
                                              icon: Image.asset("assets/images/ic_add.png",height: 30,width: 30,color : Colors.white)),
                                        )

                                      ],

                                    ))
                            )
                          ]else...[
                            InkWell(
                              onTap: (){
                               Provider.of<ProductListViewModel>(context, listen: false).addProductInCart(index);
                              },
                              child:   Container(
                                  width: 70,
                                  height: 30,
                                  decoration: const BoxDecoration(
                                      color: Colors.green,
                                      borderRadius: BorderRadius.all(Radius.circular(5))
                                  ),
                                  child : const Center(
                                      child: Text("Add",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16,color: Colors.white),
                                      ))
                              ),
                            )
                          ]
                        ],
                      ),
                    )
                ));
        });
  }
}
