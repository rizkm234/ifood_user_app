import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ifood_user_app/Splash%20Screen/splash_screen.dart';
import 'package:ifood_user_app/assistant%20methods/assistant_methods.dart';
import 'package:ifood_user_app/models/sellers_model.dart';
import '../global/global.dart';
import '../models/menus_model.dart';
import '../widgets/app_bar.dart';
import '../widgets/menus_design.dart';
import '../widgets/my_drawer.dart';
import '../widgets/text_widget.dart';
import 'home_screen.dart';


class MenusScreen extends StatefulWidget {
  final Sellers? model;
   MenusScreen({Key? key, this.model}) : super(key: key);

  @override
  State<MenusScreen> createState() => _MenusScreenState();
}

class _MenusScreenState extends State<MenusScreen> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: (){
            clearCartNow(context);
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context)=> const HomeScreen()));
            // Fluttertoast.showToast(msg: 'Cart has been cleared');
          },
        ),
        title: const Text('iFood',
          style: TextStyle(fontSize: 45 , fontFamily: 'Signatra'),),
        centerTitle: true,
        automaticallyImplyLeading: true,
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
      body:  CustomScrollView(
        slivers: [
          SliverPersistentHeader(
            pinned: true ,
            delegate: TextWidgetHeader(title:'${widget.model!.sellerName!} Menus'),),
          StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('sellers')
                  .doc(widget.model!.sellerUID)
                  .collection('menus').orderBy('publishedDate' , descending: true)
                  .snapshots(),
              builder: (context ,snapshot){
                return !snapshot.hasData ?
                const SliverToBoxAdapter(
                  child: Center(
                    child: CircularProgressIndicator( color: Colors.cyan,),
                  ),
                ): SliverStaggeredGrid.countBuilder(
                  crossAxisCount: 1 ,
                  staggeredTileBuilder: (c)=> const StaggeredTile.fit(1),
                  itemBuilder: (context , index){
                    Menus sModel = Menus.fromJson(
                        snapshot.data!.docs[index].data()! as Map<String , dynamic>
                    );
                    //design for displaying sellers
                    return MenusDesignWidget(
                      model: sModel,
                      context: context,
                    );
                  },
                  itemCount: snapshot.data!.docs.length,
                );
              }
          ),
        ],
      ),
    );
  }
}
