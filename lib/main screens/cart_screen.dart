import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ifood_user_app/assistant%20methods/total_amount.dart';
import 'package:ifood_user_app/main%20screens/address_screen.dart';
import 'package:ifood_user_app/models/cart_model.dart';
import 'package:ifood_user_app/models/items_model.dart';
import 'package:ifood_user_app/widgets/cart_item_design.dart';
import 'package:ifood_user_app/widgets/progress_bar.dart';
import 'package:provider/provider.dart';
import '../assistant methods/assistant_methods.dart';
import '../assistant methods/cart_item_counter.dart';
import '../widgets/text_widget.dart';
import 'home_screen.dart';

class CartScreen extends StatefulWidget {
  String? sellerUID ;
  CartScreen ({this.sellerUID});
  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<int>? separateItemQuantityList;
  num totalAmount = 0;

  @override
void initState() {
    super.initState();
    separateItemQuantityList = separateItemQuantities();
    print (separateItemQuantityList);
    totalAmount = 0;
    Provider.of<TotalAmount>(context , listen: false).displayTotalAmount(0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // leading: IconButton(
        //   icon: const Icon(Icons.clear_all),
        //   onPressed: (){
        //     clearCartNow(context);
        //   },
        // ),
        title: const Text('iFood',
          style: TextStyle(fontSize: 45 , fontFamily: 'Signatra'),),
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          Stack(
            children: [
              IconButton(
                onPressed:(){},
                icon: const Icon(Icons.shopping_cart),
              ),
              Positioned(
                  child: Stack(
                    children:  [
                      const Icon(
                        Icons.brightness_1,
                        size: 20,
                        color: Colors.green,
                      ),
                      Positioned(
                        top: 3,
                        right: 5.8,
                        child: Center(
                          child: Consumer<CartItemCounter>(
                            builder: (context , counter , c){
                              return Text(counter.count.toString(),
                                style: const TextStyle(color: Colors.white , fontSize: 12),
                              );
                            },
                          ),
                        ),
                      )
                    ],
                    //style: const TextStyle(color: Colors.white , fontSize: 12),
                  ))
            ],
          )
        ],
        flexibleSpace: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.cyan , Colors.amber ],
                begin: FractionalOffset(0.0,0.0),
                end: FractionalOffset(1.0,0.0),
                stops: [0.0 , 1.0],
                tileMode: TileMode.clamp,
              )
          ),
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(width: 10,),
          Align(
            alignment: Alignment.bottomLeft,
            child: FloatingActionButton.extended(
              heroTag: 'btn1',
                onPressed: (){
                  clearCartNow(context);
                  Navigator.pushReplacement(
                      context, MaterialPageRoute(builder: (context)=> const HomeScreen()));
                  Fluttertoast.showToast(msg: 'Cart has been cleared');
                },
                label: const Text('Clear Cart', style: TextStyle(fontSize: 16),),
              backgroundColor: Colors.red,
              icon: const Icon(Icons.clear_all , color: Colors.white,),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: FloatingActionButton.extended(
              heroTag: 'btn2',
                onPressed: (){
                  Navigator.push(
                      context, MaterialPageRoute(
                      builder: (context)=>
                          AddressScreen(
                            totalAmount : totalAmount.toDouble(),
                            sellerUID : widget.sellerUID ,
                          )));
                },
                label: const Text('Check Out', style: TextStyle(fontSize: 16)),
              backgroundColor: Colors.cyan,
              icon: const Icon(Icons.navigate_next , color: Colors.white,),
            ),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          // total price
          SliverPersistentHeader(
            pinned: true,
            delegate: TextWidgetHeader(
                title:'My Cart List'
            ),
          ),
          SliverToBoxAdapter(
            child: Consumer2<TotalAmount , CartItemCounter>(
              builder:(context ,amountProvider , cartProvide , c ){
                return Padding(
                    padding: EdgeInsets.all(8),
                  child: Center(
                    child:cartProvide.count == 0? Container()
                        :Text("Total Price: ${amountProvider.tAmount.toString()} EGP",
                    style: const TextStyle(
                      color: Colors.black54,
                      fontSize: 18,
                      fontWeight: FontWeight.w500
                    ),)
                  ),
                );
              } ,
            ),
          ),
          //display cart items
          StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('items')
                  .where('itemID' , whereIn:separateItemIDs())
                  .orderBy('publishedDate', descending: true)
                  .snapshots(),
              builder: (context , snapshot){
                return !snapshot.hasData
                    ? SliverToBoxAdapter(
                      child: Center(
                        child: circularProgress(),
                      ),
                    )
                    : SliverList(
                    delegate: SliverChildBuilderDelegate((context , index){
                      Items model = Items.fromJson(
                          snapshot.data!.docs[index].data() as Map<String, dynamic> ,
                      );
                      Cart cModel = Cart.fromJson(
                        snapshot.data!.docs[index].data() as Map<String, dynamic> ,
                      );
                      if (index == 0){
                        totalAmount =0;
                        totalAmount = totalAmount + (model.itemPrice! * separateItemQuantityList![index]);
                      }else {
                        totalAmount = totalAmount + (model.itemPrice! * separateItemQuantityList![index]);
                      }
                      if (snapshot.data!.docs.length-1 == index){
                        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                          Provider.of<TotalAmount>(
                              context , listen: false
                          ).displayTotalAmount(totalAmount.toDouble());
                        });
                      }
                      return CartItemDesign(
                        model:  model,
                        context: context,
                        QuantityNumber:separateItemQuantityList![index],
                      );
                    },
                    childCount: snapshot.hasData ? snapshot.data!.docs.length : 0,
                    )
                );
              }
          ),
        ],
      ),
    );
  }
}
