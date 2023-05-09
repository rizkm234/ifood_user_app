import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:ifood_user_app/main%20screens/menus_screen.dart';
import 'package:ifood_user_app/models/items_model.dart';
import 'package:ifood_user_app/widgets/app_bar.dart';
import 'package:ifood_user_app/widgets/items_design.dart';
import '../global/global.dart';
import '../models/menus_model.dart';
import '../widgets/sellers_design.dart';
import '../widgets/my_drawer.dart';
import '../widgets/text_widget.dart';


class ItemsScreen extends StatefulWidget {
  final Menus? model;
   ItemsScreen({Key? key , this.model}) : super(key: key);

  @override
  State<ItemsScreen> createState() => _ItemsScreenState();
}

class _ItemsScreenState extends State<ItemsScreen> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: MyAppBar(sellerUID: widget.model!.sellerUID),
      body:  CustomScrollView(
        slivers: [
          SliverPersistentHeader(
            pinned: true ,
            delegate: TextWidgetHeader(
                title:'Items of ${widget.model!.menuTitle!}'
            ),
          ),
          StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('sellers')
                  .doc(widget.model!.sellerUID)
                  .collection('menus')
                  .doc(widget.model!.menuID)
                  .collection('items')
                  .orderBy('publishedDate' , descending: true)
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
                    Items sModel = Items.fromJson(
                        snapshot.data!.docs[index].data()! as Map<String , dynamic>
                    );
                    //design for displaying sellers
                    return ItemsDesignWidget(
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
