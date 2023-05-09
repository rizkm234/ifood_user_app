import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ifood_user_app/models/sellers_model.dart';
import '../widgets/sellers_design.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {

  Future<QuerySnapshot>? restaurantsDocumentsList ;
  String sellerNameText = '';

  initSearchingRestaurant(String textEntered){
    restaurantsDocumentsList =  FirebaseFirestore.instance
        .collection('sellers')
        .where('sellerName' , isGreaterThanOrEqualTo: textEntered).get();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
        title: TextFormField(
          onChanged: (textEntered){
            setState(() {
              sellerNameText = textEntered;
            });
            initSearchingRestaurant(textEntered);
          },
          decoration: InputDecoration(
            hintText:  'Search Rest / Cafe...',
              hintStyle: const TextStyle(color: Colors.white54),
              border: InputBorder.none,
            suffixIcon: IconButton(
              icon: const Icon(Icons.search , color: Colors.white),
              onPressed: (){
                initSearchingRestaurant(sellerNameText);
              } ,
            )
          ),
          style: const TextStyle(color: Colors.white , fontSize: 16),
        ),
      ),
      body: FutureBuilder<QuerySnapshot>(
        future:restaurantsDocumentsList ,
        builder: (context,snapshot){
          return snapshot.hasData
              ?ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context , index){
                  Sellers model = Sellers.fromJson(
                    snapshot.data!.docs[index].data()! as Map<String,dynamic>
                  );
                  return SellersDesignWidget(
                    model: model,
                    context: context,
                  );
                }
          )
              : Center(child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text('No record found' , style: TextStyle(fontSize: 30, color: Colors.grey,),
                  ),
                  Icon(Icons.search_off , size: 50, color: Colors.grey,)
                ],
              ),);
        },
      ),
    );
  }
}
