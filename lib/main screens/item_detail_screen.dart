import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ifood_user_app/widgets/app_bar.dart';
import 'package:number_inc_dec/number_inc_dec.dart';

import '../assistant methods/assistant_methods.dart';
import '../models/items_model.dart';

class ItemDetailScreen extends StatefulWidget {
  final Items? model;
  const ItemDetailScreen({Key? key , this.model}) : super(key: key);

  @override
  State<ItemDetailScreen> createState() => _ItemDetailScreenState();
}

class _ItemDetailScreenState extends State<ItemDetailScreen> {
  TextEditingController counterTextEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(sellerUID: widget.model!.sellerUID),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(widget.model!.thumbnailUrl.toString() , fit: BoxFit.cover,),
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(20),
              // width: MediaQuery.of(context).size.width * 0.95,
              child: NumberInputPrefabbed.roundedButtons(
                  controller: counterTextEditingController,
                incDecBgColor: Colors.amber,
                min: 1,
                max: 10,
                initialValue: 1,
                buttonArrangement:  ButtonArrangement.incRightDecLeft,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(widget.model!.itemTitle.toString(),
                textAlign: TextAlign.justify,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(widget.model!.itemDescription.toString(),
                textAlign: TextAlign.justify,
                style: const TextStyle(fontWeight: FontWeight.normal, fontSize: 14),),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 20),
              child: Text(
                '${widget.model!.itemPrice!.toString()} EGP',
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    fontFamily: 'Kiwi',
                    color: Colors.cyan
                ),
              ),
            ),
            Center(
              child: InkWell(
                onTap: (){
                  int itemCounter = int.parse(counterTextEditingController.text.toString());
                  List<String> separateItemIDsList = separateItemIDs();
                  //check if item exist

                  separateItemIDsList.contains(widget.model!.itemID) ?
                      Fluttertoast.showToast(msg: 'Items is already in cart')
                  //add to cart
                      : addItemToCart(widget.model!.itemID, context, itemCounter);
                },
                child: Container(
                  alignment: Alignment.bottomCenter,
                  decoration:  BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Colors.cyan , Colors.amber ],
                        begin: FractionalOffset(0.0,0.0),
                        end: FractionalOffset(1.0,0.0),
                        stops: [0.0 , 1.0],
                        tileMode: TileMode.clamp,
                      ),
                    borderRadius: BorderRadius.circular(20)
                  ),
                  width: MediaQuery.of(context).size.width-20,
                  height: 50,
                  child: const Center(
                    child: Text('Add to Cart',
                    style: TextStyle(color: Colors.white , fontSize: 20),),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
