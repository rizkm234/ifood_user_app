import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ifood_user_app/assistant%20methods/assistant_methods.dart';
import 'package:ifood_user_app/global/global.dart';
import 'package:ifood_user_app/main%20screens/home_screen.dart';

class PlacedOrderScreen extends StatefulWidget {
  final String? addressID;
  final double? totalAmount;
  final String? sellerUID;
  const PlacedOrderScreen({Key? key,
      this.addressID,
      this.totalAmount,
      this.sellerUID,
  }) : super(key: key);

  @override
  State<PlacedOrderScreen> createState() => _PlacedOrderScreenState();
}

class _PlacedOrderScreenState extends State<PlacedOrderScreen> {
  String orderId = DateTime.now().millisecondsSinceEpoch.toString();
  addOrderDetails(){
    writeOrderDetailsForUser({
      'orderId' : orderId,
      'addressID' : widget.addressID,
      'totalAmount' : widget.totalAmount,
      'sellerUID' : widget.sellerUID,
      'orderBy' : sharedPreferences!.getString('uid'),
      'productIDS' : sharedPreferences!.getStringList('userCart'),
      'paymentDetails' : 'Cash on delivery',
      'orderTime' : orderId,
      'isSuccess' : true,
      'riderUID' : '',
      'status' : 'normal',
    });

    writeOrderDetailsForSeller({
      'orderId' : orderId,
      'addressID' : widget.addressID,
      'totalAmount' : widget.totalAmount,
      'sellerUID' : widget.sellerUID,
      'orderBy' : sharedPreferences!.getString('uid'),
      'productIDS' : sharedPreferences!.getStringList('userCart'),
      'paymentDetails' : 'Cash on delivery',
      'orderTime' : orderId,
      'isSuccess' : true,
      'riderUID' : '',
      'status' : 'normal',
    }).whenComplete((){
      clearCartNow(context);
      setState(() {
        orderId = '';
        Navigator.pushReplacement(
            context, MaterialPageRoute(
            builder: (context)=>const HomeScreen()));

        Fluttertoast.showToast(
            msg: 'Congratulations, Your order has been placed successfully.'
        );
      });
    });
  }

  Future writeOrderDetailsForUser (Map<String , dynamic> data) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(sharedPreferences!.getString('uid'))
        .collection('orders')
        .doc(orderId)
        .set(data);
  }

  Future writeOrderDetailsForSeller (Map<String , dynamic> data) async {
    await FirebaseFirestore.instance
        .collection('orders')
        .doc(orderId)
        .set(data);
  }


  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.cyan , Colors.amber ],
              begin: FractionalOffset(0.0,0.0),
              end: FractionalOffset(1.0,0.0),
              stops: [0.0 , 1.0],
              tileMode: TileMode.clamp,
            )
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('images/delivery.jpg'),
            const SizedBox(height: 12,),
            ElevatedButton(
              onPressed: (){
                addOrderDetails();
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(10),
                backgroundColor: Colors.cyan,),
              child: const Text('Place Order', style: TextStyle(fontSize: 20 ,color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
