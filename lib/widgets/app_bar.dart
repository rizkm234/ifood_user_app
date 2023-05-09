import 'package:flutter/material.dart';
import 'package:ifood_user_app/assistant%20methods/cart_item_counter.dart';
import 'package:ifood_user_app/main%20screens/cart_screen.dart';
import 'package:provider/provider.dart';

class MyAppBar extends StatefulWidget with PreferredSizeWidget {
  final PreferredSizeWidget? bottom;
  final String? sellerUID ;
  MyAppBar({this.bottom , this.sellerUID});

  @override
  State<MyAppBar> createState() => _MyAppBarState();

  @override
  Size get preferredSize => bottom == null ? Size(56, AppBar().preferredSize.height):
  Size(56, 80+AppBar().preferredSize.height);
}

class _MyAppBarState extends State<MyAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: (){
          Navigator.pop(context);
        },
      ),
      title: const Text('iFood',
        style: TextStyle(fontSize: 45 , fontFamily: 'Signatra'),),
      centerTitle: true,
      automaticallyImplyLeading: true,
      actions: [
        Stack(
          children: [
            IconButton(
              onPressed:(){
                //send user to cart screen
                Navigator.push(
                    context, MaterialPageRoute(
                    builder: (context)=>CartScreen(sellerUID: widget.sellerUID)));
              },
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
    );
  }
}
