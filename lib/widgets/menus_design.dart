import 'package:flutter/material.dart';
import 'package:ifood_user_app/main%20screens/items_screen.dart';
import 'package:ifood_user_app/models/menus_model.dart';
import 'package:ifood_user_app/models/sellers_model.dart';

class MenusDesignWidget extends StatefulWidget {
  Menus? model ;
  BuildContext? context;
   MenusDesignWidget({Key? key ,
      this.model ,
      this.context
   }) : super(key: key);

  @override
  State<MenusDesignWidget> createState() => _MenusDesignWidgetState();
}

class _MenusDesignWidgetState extends State<MenusDesignWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Navigator.push(
            context, MaterialPageRoute(
            builder: (context)=> ItemsScreen(
            model: widget.model,
        )));
      },
      splashColor: Colors.amber,
      child: Container(
        height: MediaQuery.of(context).size.height/2.5,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            // Divider(
            //   height: 4,
            //   thickness: 3,
            //   color: Colors.grey[300],
            // ),

            Image.network(widget.model!.thumbnailUrl! ,
              height: 220,
            width: double.infinity,
            fit: BoxFit.cover,),
            const SizedBox(height: 1,),
            Text(widget.model!.menuTitle! ,
              style: const TextStyle(
                color: Colors.cyan,
                fontSize: 20,
                fontFamily: 'Train'
              ),
            ),
            Text(widget.model!.menuInfo! ,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
            ),
            Divider(
              height: 4,
              thickness: 3,
              color: Colors.grey[300],
            ),
          ],
        ),
      ),
    );
  }
}
