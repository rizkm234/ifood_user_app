import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ifood_user_app/assistant%20methods/assistant_methods.dart';
import 'package:ifood_user_app/global/global.dart';
import 'package:ifood_user_app/widgets/my_drawer.dart';
import 'package:ifood_user_app/widgets/order_cart.dart';
import 'package:ifood_user_app/widgets/progress_bar.dart';
import 'package:ifood_user_app/widgets/simple_appBar.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SimpleAppBar(title: 'History',),
      drawer: const MyDrawer(),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(sharedPreferences!.getString('uid'))
            .collection('orders')
            .where('status' , isEqualTo: 'ended' )
            .orderBy('orderTime' , descending: true).snapshots(),
        builder: (context , snapshot){
          return snapshot.hasData
              ? ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context , index){
                return FutureBuilder<QuerySnapshot>(
                  future:FirebaseFirestore.instance
                      .collection('items')
                      .where('itemID', whereIn: separateOrderItemIDs((snapshot.data!.docs[index].data()! as Map <String , dynamic>)['productIDS'] ))
                      .where('orderBy' , whereIn: (snapshot.data!.docs[index].data()! as Map <String , dynamic>)['uid'])
                      .orderBy('publishedDate', descending: true).get(),
                  builder: (context , snap){
                    return snap.hasData
                        ? OrderCart(
                        itemCount: snap.data!.docs.length,
                        data: snap.data!.docs,
                        orderID: snapshot.data!.docs[index].id,
                        seperateQuatitesList: separateOrderItemQuantities((snapshot.data!
                            .docs[index].data()! as Map <String , dynamic>)
                        ['productIDS']))
                        : Center(child: circularProgress(),);
                  },
                );
              }
          )
              : Center(child: circularProgress(),);
        },
      ),
    );
  }
}
