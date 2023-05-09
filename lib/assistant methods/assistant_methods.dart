import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ifood_user_app/assistant%20methods/cart_item_counter.dart';
import 'package:ifood_user_app/global/global.dart';
import 'package:provider/provider.dart';

  separateOrderItemIDs(orderIDs){
  List<String> separateItemIDsList = [], defaultItemList = [];

  defaultItemList = List<String>.from(orderIDs);
  for (int i=0 ; i<defaultItemList.length; i++ ){
    String item = defaultItemList[i].toString();
    var pos = item.lastIndexOf(':');
    String getItemId = (pos != -1) ? item.substring(0 , pos) : item ;
    print('This is itemID now = $getItemId');
    separateItemIDsList.add(getItemId);
  }
  print('This is items List now = ');
  print(separateItemIDsList);
  return separateItemIDsList ;
}


  separateItemIDs(){
    List<String> separateItemIDsList = [], defaultItemList = [];

    defaultItemList = sharedPreferences!.getStringList('userCart')!;
    for (int i=0 ; i<defaultItemList.length; i++ ){
      String item = defaultItemList[i].toString();
      var pos = item.lastIndexOf(':');
      String getItemId = (pos != -1) ? item.substring(0 , pos) : item ;
      print('This is itemID now = $getItemId');
      separateItemIDsList.add(getItemId);
    }
    print('This is items List now = ');
    print(separateItemIDsList);
    return separateItemIDsList ;
  }


  addItemToCart(String ? foodItemId, BuildContext context, int itemCounter){
    List <String>? tempList = sharedPreferences!.getStringList('userCart');
    tempList!.add('${foodItemId!}:$itemCounter');
    FirebaseFirestore.instance.collection('users')
        .doc(firebaseAuth.currentUser!.uid)
        .update({
      'userCart' : tempList,
    }).then((value){
      Fluttertoast.showToast(msg: 'Item Added Successfully.');

      sharedPreferences!.setStringList('userCart', tempList);

      //update the badge
      Provider.of<CartItemCounter>(context , listen: false).displayCartListItemsNumber();
    });
    }


  separateItemQuantities(){
  List<int> separateItemQuantityList = [];
  List<String> defaultItemList = [];

  defaultItemList = sharedPreferences!.getStringList('userCart')!;

  for (int i=1 ; i<defaultItemList.length; i++ ){
    String item = defaultItemList[i].toString();
    List<String> listItemCharacters = item.split(':').toList();
    var quantityNumber = int.parse(listItemCharacters[1].toString());

    print('This is item Quantity Number = ${quantityNumber.toString()}');
    separateItemQuantityList.add(quantityNumber);
  }
  print('This is items List now = ');
  print(separateItemQuantityList);
  return separateItemQuantityList ;
}

  separateOrderItemQuantities(orderIDs){
  List<String> separateItemQuantityList = [];
  List<String> defaultItemList = [];

  defaultItemList = List<String>.from(orderIDs);

  for (int i=1 ; i<defaultItemList.length; i++ ){
    String item = defaultItemList[i].toString();
    List<String> listItemCharacters = item.split(':').toList();
    var quantityNumber = int.parse(listItemCharacters[1].toString());

    print('This is item Quantity Number = ${quantityNumber.toString()}');
    separateItemQuantityList.add(quantityNumber.toString());
  }
  print('This is items List now = ');
  print(separateItemQuantityList);
  return separateItemQuantityList ;
}

  clearCartNow(context){
    sharedPreferences!.setStringList('userCart', ['fakeData']);
    List<String> ? emptyList =sharedPreferences!.getStringList('userCart');
    FirebaseFirestore.instance
        .collection('users')
        .doc(firebaseAuth.currentUser!.uid).update({
      'userCart' : emptyList ,
    }).then((value) {
      sharedPreferences!.setStringList('userCart', emptyList!);
      Provider.of<CartItemCounter>(context , listen: false).displayCartListItemsNumber();

    });
  }